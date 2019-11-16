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

private let maxLifeCount = 5
var isConfiged:Bool = false

class QuizViewController: UIViewController, GADRewardBasedVideoAdDelegate {   
    
    internal var quizList: Array<Quiz> = Array<Quiz>()
    internal var currentQuizIndex: Int = 0
    internal var score: Int = 0
    internal var life: Int = maxLifeCount
    private let difficulty = [[30, 20], [40, 30], [50, 40]]
    private var difficultyLevel = 0
    
    var rewardBaseAd: GADRewardBasedVideoAd!
    private var isEarnReward: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfig()
        
        makeQuestion()
        
        UIView.appearance().isExclusiveTouch = true
    }
    
    func setConfig() {
        
        if !isConfiged {

            initFlagInfo()
            
            isConfiged = !isConfiged
        }
    }
    
    
    func initFlagInfo() {
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
    }
    
    func initQuiz() {
        self.quizList.removeAll()
        self.currentQuizIndex = 0
    }
    
    func initScore() {
        self.score = 0
    }
    
    func getScore() -> Int {
        return self.score
    }
    
    func initLife() {
        self.life = maxLifeCount
    }
    
    func earnLife(life: Int) {
        self.life = life
    }
    
    func initIsEarnLife() {
        self.isEarnReward = false
    }
    
    func initButtons(array: Array<UIButton>) {
        for i in 0..<array.count {
            array[i].isEnabled = true
        }
    }
    
    func showCorrectOrIncorrectViewAfterHide(backgroundColor: UIColor, message: String) {
        
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
    
    func changeScoreLabel() {
        
    }
    
    func checkAnswer(selectedButtonTag: Int) -> Bool {
        return quizList[currentQuizIndex].correctAnswerIndex == selectedButtonTag ? true : false
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
        
        for i in 0...3 {
            print("\(quizList[currentQuizIndex].example[i]). \(flagInfo[quizList[currentQuizIndex].example[i]].name)")
            if i == 3 {
                print("")
            }
        }
    }
    
    func displayQuestion() {
        print("QuizViewController.displayQuestion()")
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
        }
        
        initIsEarnLife()
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
    }
    
}
