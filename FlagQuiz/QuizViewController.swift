//
//  QuizViewController.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 3. 18..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit
import AudioToolbox
import GoogleMobileAds

class QuizViewController: UIViewController, GADRewardBasedVideoAdDelegate {
    
    @IBOutlet weak var flagImageView: UIImageView!
    
    @IBOutlet var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewRightConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftTopButton: UIButton!
    @IBOutlet weak var rightTopButton: UIButton!
    @IBOutlet weak var leftBottomButton: UIButton!
    @IBOutlet weak var rightBottomButton: UIButton!
    
    @IBOutlet weak var firstLife: UIImageView!
    @IBOutlet weak var secondLife: UIImageView!
    @IBOutlet weak var thirdLife: UIImageView!
    @IBOutlet weak var fourthLife: UIImageView!
    @IBOutlet weak var fifthLife: UIImageView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var correctOrIncorrectView: UIView!
    @IBOutlet weak var correctOrIncorrectLabel: UILabel!
    
    @IBOutlet var difficultyNotificationView: UIView!
    @IBOutlet var difficultyLabel: UILabel!
    
    @IBOutlet var bannerView: GADBannerView!
    var rewardBaseAd: GADRewardBasedVideoAd!
    
    var buttonArray: Array<UIButton> = []
    var lifeArray: Array<UIImageView> = []
    private var quizList: Array<Quiz> = Array<Quiz>()
    private var currentQuizIndex: Int = 0
    private var score: Int = 0
    private var life: Int = 5
    private let difficulty = [[30, 20], [40, 30], [50, 40]]
    private var difficultyLevel = 0
    
    private var isEarnReward: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "CountryList", ofType: "csv")
        let url = URL(fileURLWithPath: path!)
        let countryList = try! NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue)
        var lines = countryList.components(separatedBy: "\n")
        
        // csv 파일 열 제목 삭제
        lines.remove(at: 0)
        
        // 마지막 빈 배열 삭제
        lines.remove(at: lines.count - 1)
        
        for line in lines {
            let column = line.components(separatedBy: ",")
            flagInfo.append(FlagInfo(name: column[0], imageName: column[1], GDP: Int(column[3]) ?? -1, area: Int(column[4]) ?? -1, difficulty: 0))
        }
        
        flagInfo = flagInfo.sorted(by: { $0.GDP > $1.GDP })
        for i in 0..<flagInfo.count {
            flagInfo[i].difficulty = i * 10
        }
        flagInfo = flagInfo.sorted(by: { $0.area > $1.area })
        for i in 0..<flagInfo.count {
            flagInfo[i].difficulty = flagInfo[i].difficulty + i
        }
        flagInfo = flagInfo.sorted(by: { $0.difficulty < $1.difficulty })
        
        let languageList = ["ko": "South Korea",
                            "zh-Hant": "Taiwan",
                            "ja": "Japan",
                            "zh-Hans": "China",
                            "ar": "Saudi Arabia",
                            "ru": "Russia"]
        
        for language in languageList {
            if getCurrentLanguage() == language.key {
                for i in 0 ..< flagInfo.count {
                    if flagInfo[i].name == language.value {
                        flagInfo.insert(flagInfo[i], at: 0)
                        flagInfo.remove(at: i + 1)
                    }
                }
            }
        }
        
        for i in 0 ..< flagInfo.count {
            print("\(i). \(flagInfo[i].name)")
        }
        
        buttonArray.append(leftTopButton)
        buttonArray.append(rightTopButton)
        buttonArray.append(leftBottomButton)
        buttonArray.append(rightBottomButton)
        
        lifeArray.append(firstLife)
        lifeArray.append(secondLife)
        lifeArray.append(thirdLife)
        lifeArray.append(fourthLife)
        lifeArray.append(fifthLife)
        
        correctOrIncorrectView.alpha = 0
        
        difficultyLabel.text = NSLocalizedString("Level Up", comment: "")
        difficultyNotificationView.alpha = 0
        
        scoreLabel.text = "\(score)"
        self.life = lifeArray.count
        
        if ( UIDevice.current.userInterfaceIdiom == .phone ) {
            imageViewTopConstraint.constant = 30
            imageViewBottomConstraint.constant = 30
            imageViewLeftConstraint.constant = 40
            imageViewRightConstraint.constant = 40
        } else if ( UIDevice.current.userInterfaceIdiom == .pad ) {
            imageViewTopConstraint.constant = 80
            imageViewBottomConstraint.constant = 80
            imageViewLeftConstraint.constant = 100
            imageViewRightConstraint.constant = 100
        }
        
        makeQuestion()
        textFitInButton()
        setDefaultButtonStyle()
        
        UIView.appearance().isExclusiveTouch = true
        
        for i in 0...3 {
            buttonArray[i].setTitleColor(UIColor.black, for: .normal)
            buttonArray[i].titleLabel?.textAlignment = NSTextAlignment.center
        }
        
        bannerView.adUnitID = bannerAdUnitID
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
        
        rewardBaseAd = GADRewardBasedVideoAd.sharedInstance()
        rewardBaseAd.delegate = self
        
        rewardBaseAd.load(GADRequest(), withAdUnitID: rewardAdUnitId)
        
        UpdateModule.run(updateType: .normal)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animateAlongsideTransition(in: nil, animation: nil) { _ in
            self.textFitInButton()
        }
    }
    
    func getCurrentLanguage() -> String {
        let languages = NSLocale.preferredLanguages
        let currentLanguage = languages[0]
        return currentLanguage
    }
    
    func initQuiz() {
        self.quizList.removeAll()
        self.currentQuizIndex = 0
    }
    
    func initScore() {
        self.score = 0
        self.scoreLabel.text = "\(score)"
    }
    
    func getScore() -> Int {
        return self.score
    }
    
    func initLife() {
        self.life = lifeArray.count
        
        for i in 0..<lifeArray.count {
            lifeArray[i].alpha = 1
        }
    }
    
    func earnLife(life: Int) {
        self.life = life
        
        for i in 0..<life {
            lifeArray[i].alpha = 1
        }
    }
    
    func setDefaultButtonStyle() {
        for i in 0...3 {
            buttonArray[i].isEnabled = true
        }
    }
    
    func showCorrectOrIncorrectViewAfterHide(backgroundColor: UIColor, message: String) {
        correctOrIncorrectLabel.text = message
        correctOrIncorrectView.backgroundColor = backgroundColor
        UIView.animate(withDuration: 0.3) {
            self.correctOrIncorrectView.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.3, animations: {
                self.correctOrIncorrectView.alpha = 0
            })
        }
    }
    
    func popupShowAfterHide(popupView: UIView, duration: Double) {
        UIView.animate(withDuration: duration) {
            popupView.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: 0.3, animations: {
                popupView.alpha = 0
            })
        }
    }
    
    @IBAction func checkAnswer(_ btn: UIButton) {
        let isCorrect = quizList[currentQuizIndex].correctAnswerIndex == btn.tag ? true : false
        
        if isCorrect {
            for i in 0...3 {
                buttonArray[i].isEnabled = false
            }
            for i in 0...3 {
                buttonArray[i].setTitleColor(UIColor(red: 1, green: 0, blue: 0, alpha: 0.4), for: .disabled)
            }
            btn.setTitleColor(UIColor.blue, for: .disabled)
            
            Vibration.success.vibrate()
            
            score += 1
            
            scoreLabel.text = "\(score)"
            
            showCorrectOrIncorrectViewAfterHide(backgroundColor: UIColor(red: 80/255, green: 80/255, blue: 255/255, alpha: 1), message: NSLocalizedString("Correct", comment: ""))
            
            if score % 10 == 0 {
                popupShowAfterHide(popupView: difficultyNotificationView, duration: 0.3)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.makeQuestion()
                self.textFitInButton()
                self.setDefaultButtonStyle()
            }
            
        } else {
            btn.isEnabled = false
            btn.setTitleColor(UIColor(red: 1, green: 0, blue: 0, alpha: 0.4), for: .disabled)
            
            Vibration.error.vibrate()
            
            life -= 1
            
            showCorrectOrIncorrectViewAfterHide(backgroundColor: UIColor(red: 255/255, green: 80/255, blue: 80/255, alpha: 1), message: NSLocalizedString("Wrong", comment: ""))
            
            UIView.animate(withDuration: 0.3) {
                self.lifeArray[self.life].alpha = 0
            }
            
            let isDie = life == 0 ? true : false
            
            if isDie {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let popUpView = storyboard.instantiateViewController(withIdentifier: "popUp") as! PopUpViewController
                popUpView.viewController = self
                
                self.present(popUpView, animated: true, completion: nil)
            }
        }
    }
    
    func isDupPrevExample(newExample: Int, prevExample: Array<Int>) -> Bool {
        for index in 0 ..< prevExample.count {
            if newExample == prevExample[index] {
                return true
            }
        }
        return false
    }
    
    
    func isDupQuiz(newExample: Int, isCorrectAnswer: Bool, quizList: Array<Quiz>) -> Bool {
        // 이전 예시와 중복 확인
        if quizList.count > 0 && isDupPrevExample(newExample: newExample, prevExample: quizList[quizList.count - 1].example) {
            return true
        }
        
        // 모든 정답과 중복 확인
        if isCorrectAnswer && quizList.count > 0 {
            for index in 0 ..< quizList.count - 1 {
                if newExample == quizList[index].example[quizList[index].correctAnswerIndex] {
                    return true
                }
            }
        }
        return false
    }
    
    func makeExample(inQuizList: Array<Quiz>, correctAnswerIndex: Int) -> [Int] {
        var example: Array<Int> = Array<Int>()
        let quizCount = 20
        
        func selectCountryByDifficulty() -> Int {
            var indexSelectedCountry: Int = 0
            
            if difficulty[difficultyLevel][0] + difficulty[difficultyLevel][1] * score / 10 > flagInfo.count {
                indexSelectedCountry = Int(arc4random_uniform(UInt32(flagInfo.count)))
            } else {
                indexSelectedCountry = Int(arc4random_uniform(UInt32(difficulty[difficultyLevel][0] + difficulty[difficultyLevel][1] * score / 10)))
            }
            
            return indexSelectedCountry
        }
        
        for i in 0...3 {
            var newNumber:Int
            var isDuplicated:Bool
            repeat {
                repeat {
                    isDuplicated = false
                    newNumber = selectCountryByDifficulty()
                    for j in 0 ..< example.count {
                        if example[j] == newNumber {
                            isDuplicated = true
                        }
                    }
                } while isDuplicated
            } while isDupQuiz(newExample: newNumber, isCorrectAnswer: i == correctAnswerIndex, quizList: quizList)
            
            if quizList.count > quizCount {
                quizList.remove(at: 0)
            }
            
            example.append(newNumber)
        }
        
        return example
    }
    
    func makeQuestion() {
        let correctAnswerIndex = Int(arc4random_uniform(4))
        quizList.append(Quiz(example: makeExample(inQuizList: quizList, correctAnswerIndex: correctAnswerIndex), correctAnswerIndex: correctAnswerIndex))
        currentQuizIndex = quizList.count - 1
        
        flagImageView.image = UIImage(named: flagInfo[quizList[currentQuizIndex].example[quizList[currentQuizIndex].correctAnswerIndex]].imageName)
        
        for i in 0...3 {
            buttonArray[i].setTitle(NSLocalizedString(flagInfo[quizList[currentQuizIndex].example[i]].name, comment: ""), for: .normal)
            buttonArray[i].setTitle(NSLocalizedString(flagInfo[quizList[currentQuizIndex].example[i]].name, comment: ""), for: .disabled)
        }
        
        for i in 0...3 {
            print("\(quizList[currentQuizIndex].example[i]). \(flagInfo[quizList[currentQuizIndex].example[i]].name)")
            if i == 3 {
                print("")
            }
        }
    }
    
    func textFitInButton() {
        for i in 0..<buttonArray.count {
            if let title = buttonArray[i].title(for: .normal), var font = buttonArray[i].titleLabel?.font {
                var attr = [NSAttributedString.Key.font: font]
                var fontSize:CGFloat = 31
                repeat {
                    fontSize = fontSize - 1
                    buttonArray[i].titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
                    font = (buttonArray[i].titleLabel?.font)!
                    attr = [NSAttributedString.Key.font: font]
                    
                } while UIScreen.main.bounds.size.width/2 - 40 < (title as NSString).size(withAttributes: attr).width && fontSize > 24
            }
        }
    }
    
}

extension QuizViewController {
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        
        earnLife(life: Int(truncating: reward.amount))
        
        isEarnReward = true
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad has completed.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
        
        rewardBaseAd.load(GADRequest(), withAdUnitID: rewardAdUnitId)
        
        if isEarnReward {
            dismiss(animated: true, completion: nil)
            
            isEarnReward = false
        }
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
    }
    
}

enum Vibration {
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    case selection
    case oldSchool
    
    func vibrate() {
        
        switch self {
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            
        case .oldSchool:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
    }
    
}
