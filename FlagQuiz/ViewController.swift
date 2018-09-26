//
//  ViewController.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 3. 18..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {

    @IBOutlet weak var flagImageView: UIImageView!
    
    @IBOutlet weak var leftTopButton: UIButton!
    @IBOutlet weak var rightTopButton: UIButton!
    @IBOutlet weak var leftBottomButton: UIButton!
    @IBOutlet weak var rightBottomButton: UIButton!
    
    @IBOutlet weak var firstLife: UIImageView!
    @IBOutlet weak var secondLife: UIImageView!
    @IBOutlet weak var thirdLife: UIImageView!
    @IBOutlet weak var fourthLife: UIImageView!
    @IBOutlet weak var fifthLife: UIImageView!
    
    @IBOutlet weak var correctOrIncorrectView: UIView!
    @IBOutlet weak var correctOrIncorrectLabel: UILabel!
    
    var buttonArray: Array<UIButton> = []
    var lifeArray: Array<UIImageView> = []
    private var quizList: Array<Quiz> = Array<Quiz>()
    private var currentQuizIndex: Int = 0
    private var score: Int = 0
    private var life: Int = 5
    
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
        self.life = lifeArray.count
        
        for i in 0..<lifeArray.count {
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
            
            AudioServicesPlaySystemSound(1520)
            
            score += 1
            
            showCorrectOrIncorrectViewAfterHide(backgroundColor: UIColor.blue, message: NSLocalizedString("Correct", comment: ""))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.makeQuestion()
                self.textFitInButton()
                self.setDefaultButtonStyle()
            }
            
        } else {
            btn.isEnabled = false
            btn.setTitleColor(UIColor(red: 1, green: 0, blue: 0, alpha: 0.4), for: .disabled)
            
            AudioServicesPlaySystemSound(1521)
            
            life -= 1
            
            showCorrectOrIncorrectViewAfterHide(backgroundColor: UIColor.red, message: NSLocalizedString("Wrong", comment: ""))
            
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
        
        for i in 0...3 {
            var newNumber:Int
            var isDuplicated:Bool
            repeat {
                repeat {
                    isDuplicated = false
                    newNumber = Int(arc4random_uniform(UInt32(flagInfo.count)))
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
    }
    
    func textFitInButton() {
        for i in 0..<buttonArray.count {
            if let title = buttonArray[i].title(for: .normal), var font = buttonArray[i].titleLabel?.font {
                var attr = [NSAttributedStringKey.font: font]
                var fontSize:CGFloat = 31
                repeat {
                    fontSize = fontSize - 1
                    buttonArray[i].titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
                    font = (buttonArray[i].titleLabel?.font)!
                    attr = [NSAttributedStringKey.font: font]

                } while UIScreen.main.bounds.size.width/2 - 40 < (title as NSString).size(withAttributes: attr).width && fontSize > 8
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animateAlongsideTransition(in: nil, animation: nil) { _ in
            self.textFitInButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.life = lifeArray.count
        
        makeQuestion()
        textFitInButton()
        setDefaultButtonStyle()
        
        UIView.appearance().isExclusiveTouch = true
        
        for i in 0...3 {
            buttonArray[i].setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
    }
    
}
