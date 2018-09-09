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

    @IBOutlet weak var correctOrInaccurateLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    @IBOutlet weak var leftTopButton: UIButton!
    @IBOutlet weak var rightTopButton: UIButton!
    @IBOutlet weak var leftBottomButton: UIButton!
    @IBOutlet weak var rightBottomButton: UIButton!
    
    @IBOutlet weak var firstLife: UIImageView!
    @IBOutlet weak var secondLife: UIImageView!
    @IBOutlet weak var thirdLife: UIImageView!
    
    var buttonArray: Array<UIButton> = []
    var lifeArray: Array<UIImageView> = []
    var quizList: Array<Quiz> = Array<Quiz>()
    var currentQuizIndex: Int = 0
    var score: Int = 0
    var life: Int = 3
    
    func setDefaultButtonStyle() {
        for i in 0...3 {
            buttonArray[i].isEnabled = true
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
            
            correctOrInaccurateLabel.text = "정답"
            correctOrInaccurateLabel.textColor = UIColor.blue
            
            AudioServicesPlaySystemSound(1520)
            
            score += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.correctOrInaccurateLabel.text = ""
                self.makeQuestion()
                self.textFitInButton()
                self.setDefaultButtonStyle()
            }
            
        } else {
            btn.isEnabled = false
            btn.setTitleColor(UIColor(red: 1, green: 0, blue: 0, alpha: 0.4), for: .disabled)
            
            correctOrInaccurateLabel.text = "오답"
            correctOrInaccurateLabel.textColor = UIColor.red
            
            AudioServicesPlaySystemSound(1521)
            
            life -= 1
            
            if life == 2 {
                thirdLife.isHidden = true
            } else if life == 1 {
                secondLife.isHidden = true
            } else if life == 0 {
                firstLife.isHidden = true
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let popUpView = storyboard.instantiateViewController(withIdentifier: "popUp") as! PopUpViewController
                popUpView.score = self.score
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
            buttonArray[i].setTitle(flagInfo[quizList[currentQuizIndex].example[i]].name, for: .normal)
            buttonArray[i].setTitle(flagInfo[quizList[currentQuizIndex].example[i]].name, for: .disabled)
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
        
        correctOrInaccurateLabel.text = ""
        
        buttonArray.append(leftTopButton)
        buttonArray.append(rightTopButton)
        buttonArray.append(leftBottomButton)
        buttonArray.append(rightBottomButton)
        
        lifeArray.append(firstLife)
        lifeArray.append(secondLife)
        lifeArray.append(thirdLife)
        
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
