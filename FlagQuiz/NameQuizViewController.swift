//
//  NameQuizViewController.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2019/09/27.
//  Copyright © 2019 이수한. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class NameQuizViewController: QuizViewController {
    
    @IBOutlet weak var countryNameLabel: UILabel!
    
    @IBOutlet weak var flagLeftTopButton: UIButton!
    @IBOutlet weak var flagRightTopButton: UIButton!
    @IBOutlet weak var flagLeftBottomButton: UIButton!
    @IBOutlet weak var flagRightBottomButton: UIButton!
    
    @IBOutlet weak var firstLife: UIImageView!
    @IBOutlet weak var secondLife: UIImageView!
    @IBOutlet weak var thirdLife: UIImageView!
    @IBOutlet weak var fourthLife: UIImageView!
    @IBOutlet weak var fifthLife: UIImageView!
    
    var buttonArray: Array<UIButton> = []
    var lifeArray: Array<UIImageView> = []
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var correctOrIncorrectView: UIView!
    @IBOutlet weak var correctOrIncorrectLabel: UILabel!
    
    @IBOutlet var difficultyNotificationView: UIView!
    @IBOutlet var difficultyLabel: UILabel!
    
    @IBOutlet var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonArray.append(flagLeftTopButton)
        buttonArray.append(flagRightTopButton)
        buttonArray.append(flagLeftBottomButton)
        buttonArray.append(flagRightBottomButton)
        
        lifeArray.append(firstLife)
        lifeArray.append(secondLife)
        lifeArray.append(thirdLife)
        lifeArray.append(fourthLife)
        lifeArray.append(fifthLife)
        
        correctOrIncorrectView.alpha = 0
        
        difficultyLabel.text = NSLocalizedString("Level Up", comment: "")
        difficultyNotificationView.alpha = 0
        
        self.life = lifeArray.count
        
        scoreLabel.text = "\(score)"
        
        for i in 0...3 {
            buttonArray[i].imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        }
        
        displayQuestion()
        
        bannerView.adUnitID = bannerAdUnitID
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
    }
    
    override func displayQuestion() {
        countryNameLabel.text = flagInfo[quizList[currentQuizIndex].example[quizList[currentQuizIndex].correctAnswerIndex]].name
        
        for i in 0...3 {
            buttonArray[i].setImage(UIImage(named: flagInfo[quizList[currentQuizIndex].example[i]].imageName), for: .normal)
        }
    }
    
    override func showCorrectOrIncorrectViewAfterHide(backgroundColor: UIColor, message: String) {
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
    
    override func initLife() {
        super.initLife()
        
        for i in 0..<lifeArray.count {
            lifeArray[i].alpha = 1
        }
    }
    
    override func initButtons(array buttonArray: Array<UIButton>) {
        super.initButtons(array: buttonArray)
    }
    
    @IBAction func onTouchUpInside(_ btn: UIButton) {
        let isCorrect = checkAnswer(selectedButtonTag: btn.tag)
        
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
                self.displayQuestion()
                self.initButtons(array: self.buttonArray)
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
                popUpView.nameViewController = self
                
                self.present(popUpView, animated: true, completion: nil)
            }
        }
    }
    
}
