//
//  FlagQuizViewController.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2019/09/27.
//  Copyright © 2019 이수한. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class FlagQuizViewController: QuizViewController {
    @IBOutlet var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewRightConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewBottomConstraint: NSLayoutConstraint!
    
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
        
        buttonArray.append(leftTopButton)
        buttonArray.append(rightTopButton)
        buttonArray.append(leftBottomButton)
        buttonArray.append(rightBottomButton)
        
        lifeArray.append(firstLife)
        lifeArray.append(secondLife)
        lifeArray.append(thirdLife)
        lifeArray.append(fourthLife)
        lifeArray.append(fifthLife)
        
        self.life = lifeArray.count
        
        for button in buttonArray {
            if #available(iOS 13.0, *) {
                button.setTitleColor(UIColor.label, for: .normal)
            } else {
                // Fallback on earlier versions
                
                button.setTitleColor(UIColor.black, for: .normal)
            }
            button.titleLabel?.textAlignment = NSTextAlignment.center
        }
        
        correctOrIncorrectView.alpha = 0
        
        difficultyLabel.text = NSLocalizedString("Level Up", comment: "")
        difficultyNotificationView.alpha = 0
        
        scoreLabel.text = "\(score)"
        
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
        
        bannerView.adUnitID = bannerAdUnitID
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
        
        UpdateModule.run(updateType: .normal)
        
        displayQuestion()
        initButtons(array: buttonArray)
        textFitInButton()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animateAlongsideTransition(in: nil, animation: nil) { _ in
            self.textFitInButton()
        }
    }
    
    override func displayQuestion() {
        flagImageView.image = UIImage(named: flagInfo[quizList[currentQuizIndex].example[quizList[currentQuizIndex].correctAnswerIndex]].imageName)
        
        for i in 0...3 {
            buttonArray[i].setTitle(NSLocalizedString(flagInfo[quizList[currentQuizIndex].example[i]].name, comment: ""), for: .normal)
            buttonArray[i].setTitle(NSLocalizedString(flagInfo[quizList[currentQuizIndex].example[i]].name, comment: ""), for: .disabled)
        }
        
    }
    
    override func initScore() {
        super.initScore()
        
        self.scoreLabel.text = "\(score)"
    }
    
    override func initLife() {
        super.initLife()
        
        for i in 0..<lifeArray.count {
            lifeArray[i].alpha = 1
        }
    }
    
    override func earnLife(life: Int) {
        super.earnLife(life: life)
        
        for i in 0..<life {
            lifeArray[i].alpha = 1
        }
    }
    
    override func initButtons(array: Array<UIButton>) {
        super.initButtons(array: buttonArray)
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
                self.textFitInButton()
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
                popUpView.flagViewController = self
                
                self.present(popUpView, animated: true) {
                    popUpView.isFromFlag = true
                }
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
                    
                } while (UIScreen.main.bounds.size.width/2 - 40) < ((title as NSString).size(withAttributes: attr).width) && (fontSize > 24)
            }
        }
    }
}

