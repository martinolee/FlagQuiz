//
//  ViewController.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 3. 18..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var leftTopButton: UIButton!
    @IBOutlet weak var rightTopButton: UIButton!
    @IBOutlet weak var leftBottomButton: UIButton!
    @IBOutlet weak var rightBottomButton: UIButton!
    @IBOutlet weak var correctOrInaccurateLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var buttonArray: Array<UIButton> = []
    var quizList: Array<Quiz> = Array<Quiz>()
    var currentQuizIndex: Int = 0
    var correctCountry: String = ""
    var score: Int = 0
    
    var selectedButton: UIButton!
    
    func setDefaultButtonStyle() {
        for i in 0...3 {
            buttonArray[i].setTitleColor(UIColor.black, for: .normal)
            buttonArray[i].isEnabled = true
        }
    }
    
    @IBAction func checkAnswer(_ btn: UIButton) {
        guard let btnText = btn.titleLabel?.text else {
            return
        }
        
        if correctCountry == btnText {
            correctOrInaccurateLabel.text = "정답"
            correctOrInaccurateLabel.textColor = UIColor.blue
            
            for i in 0...3 {
                buttonArray[i].setTitleColor(UIColor(red: 1, green: 0, blue: 0, alpha: 0.4), for: .disabled)
                buttonArray[i].isEnabled = false
            }
            
            btn.setTitleColor(UIColor.blue, for: .disabled)
            btn.isEnabled = false
            
            if selectedButton != btn {
                score += 1
            }
            
            nextButton.isEnabled = true
            
        } else {
            correctOrInaccurateLabel.text = "오답"
            correctOrInaccurateLabel.textColor = UIColor.red
            
            btn.setTitleColor(UIColor(red: 1, green: 0, blue: 0, alpha: 0.4), for: .disabled)
            btn.isEnabled = false
            
            if #available(iOS 10.0, *) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred() // 진동
            } else {
                // Fallback on earlier versions
            }
            
            if score >= 1 && selectedButton != btn {
                score -= 1
            }
        }
        
        scoreLabel.text = "\(score)"
        selectedButton = btn
    }
    
    @IBAction func nextQuiz(_ sender: Any) {
        correctOrInaccurateLabel.text = ""
        makeQuestion()
        textFitInButton()
        setDefaultButtonStyle()
        selectedButton = nil
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
        var currentQuizIndex: Int
        nextButton.isEnabled = false
        
        let correctAnswerIndex = Int(arc4random_uniform(4))
        quizList.append(Quiz(example: makeExample(inQuizList: quizList, correctAnswerIndex: correctAnswerIndex), correctAnswerIndex: correctAnswerIndex))
        
         currentQuizIndex = quizList.count - 1
        
        flagImageView.image = UIImage(named: flagInfo[quizList[currentQuizIndex].example[quizList[currentQuizIndex].correctAnswerIndex]].imageName)
        correctCountry = flagInfo[quizList[currentQuizIndex].example[quizList[currentQuizIndex].correctAnswerIndex]].name
        
        for i in 0...3 {
            buttonArray[i].setTitle(flagInfo[quizList[currentQuizIndex].example[i]].name, for: .normal)
        }
        
        for i in 0...3 {
            print(flagInfo[quizList[currentQuizIndex].example[i]].name)
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
        
        makeQuestion()
        textFitInButton()
        setDefaultButtonStyle()
        
        scoreLabel.text = "\(score)"
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
