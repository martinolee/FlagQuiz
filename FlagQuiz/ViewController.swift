//
//  ViewController.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 3. 18..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var leftTopButton: UIButton!
    @IBOutlet weak var rightTopButton: UIButton!
    @IBOutlet weak var leftBottomButton: UIButton!
    @IBOutlet weak var rightBottomButton: UIButton!
    
    var buttonArray: Array<UIButton> = []
    
    @IBAction func checkAnswer(_ sender: Any) {
        //정담 확인
        
        makeQuestion()
    }
    
    func makeQuestion() {
        var answerList: Array<Int> = [0, 0, 0, 0]
        answerList[0] = Int(arc4random_uniform(UInt32(countryList.count)))
        print(answerList[0])
        for i in 1...3 {
            answerList[i] = Int(arc4random_uniform(UInt32(countryList.count)))
            var isDuplicated = false
            repeat {
                for j in  0...i-1 {
                    if answerList[i] == answerList[j] {
                        answerList[i] = Int(arc4random_uniform(UInt32(countryList.count)))
                        isDuplicated = true
                        break
                    }
                }
                
            } while isDuplicated
            
            print(answerList[i])
        }
        
        let correctAnswer = Int(arc4random_uniform(UInt32(4)))
        flagImageView.image = UIImage(named: countryList[answerList[correctAnswer]])
        for i in 0...3 {
            buttonArray[i].setTitle(String(countryList[answerList[i]].characters.dropLast(4)), for: .normal)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                buttonArray.append(leftTopButton)
                buttonArray.append(rightTopButton)
                buttonArray.append(leftBottomButton)
                buttonArray.append(rightBottomButton)
        
        makeQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

