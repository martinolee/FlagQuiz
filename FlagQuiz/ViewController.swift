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
    var answerList: Array<Int> = [0, 0, 0, 0]
    var correctAnswer = Int(arc4random_uniform(UInt32(4)))
    var correctCountry: String = ""
    var score: Int = 0
    
    var selectedButton: UIButton!
    
    func setButtonStyle(button: UIButton, isSelected: Bool) {
        if isSelected {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .regular)
            button.setTitleColor(UIColor.black, for: .normal)
        } else {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
            button.setTitleColor(self.view.tintColor, for: .normal)
        }
    }

    @IBAction func checkAnswer(_ btn: UIButton) {
        guard let btnText = btn.titleLabel?.text else {
            return
        }
        
        if correctCountry == btnText {
            correctOrInaccurateLabel.text = "정답"
            correctOrInaccurateLabel.textColor = UIColor.blue
            if selectedButton != btn {
                score += 1
            }
            
        } else {
            correctOrInaccurateLabel.text = "오답"
            correctOrInaccurateLabel.textColor = UIColor.red
            if score >= 1 && selectedButton != btn {
                score -= 1
            }
        }
        
        setButtonStyle(button: btn, isSelected: true)

        if selectedButton != nil && btn != selectedButton {
            setButtonStyle(button: selectedButton, isSelected: false)
        }

        scoreLabel.text = "\(score)"
        nextButton.isEnabled = true
        selectedButton = btn
    }
        
    @IBAction func nextQuiz(_ sender: Any) {
        correctOrInaccurateLabel.text = ""
        setButtonStyle(button: selectedButton, isSelected: false)
        makeQuestion()
        selectedButton = nil
    }
    
    
    func makeQuestion() {
        nextButton.isEnabled = false
        
        answerList[0] = Int(arc4random_uniform(UInt32(flagInfo.count)))
        print(flagInfo[answerList[0]].name)
        for i in 1...3 {
            answerList[i] = Int(arc4random_uniform(UInt32(flagInfo.count)))
            var isDuplicated = false
            
            repeat {
                isDuplicated = false
                for j in  0...i-1 {
                    if answerList[i] == answerList[j] {
                        answerList[i] = Int(arc4random_uniform(UInt32(flagInfo.count)))
                        isDuplicated = true
                        break
                    }
                }
                
            } while isDuplicated
            print(flagInfo[answerList[i]].name)
        }
        
        correctAnswer = Int(arc4random_uniform(UInt32(4)))
        flagImageView.image = UIImage(named: flagInfo[answerList[correctAnswer]].imageName)
        correctCountry = flagInfo[answerList[correctAnswer]].name
        
        for i in 0...3 {
            buttonArray[i].setTitle(flagInfo[answerList[i]].name, for: .normal)
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
        
        scoreLabel.text = "\(score)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
