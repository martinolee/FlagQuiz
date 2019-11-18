//
//  PopUpViewController.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 9. 3..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var restartButton: UIButton!
    @IBOutlet var continueButton: UIButton!
    
    @IBOutlet var popupViewWidth: NSLayoutConstraint!
    
    var flagViewController: FlagQuizViewController! =  FlagQuizViewController()
    var nameViewController: NameQuizViewController! = NameQuizViewController()
    
    var isFromFlag: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        
        if #available(iOS 13.0, *) {
            restartButton.setTitleColor(UIColor.label, for: .normal)
        } else {
            // Fallback on earlier versions
            
            restartButton.setTitleColor(.black, for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFromFlag == true {
            scoreLabel.text = ("\(flagViewController.getScore())") + " " + NSLocalizedString("Point", comment: "")
        } else {
            scoreLabel.text = ("\(nameViewController.getScore())") + " " + NSLocalizedString("Point", comment: "")
        }
        
        restartButton.setTitle(NSLocalizedString("Restart", comment: ""), for: .normal)
        if #available(iOS 13.0, *) {
            continueButton.setAttributedTitle(NSAttributedString(string: NSLocalizedString("Continue", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.label]), for: .normal)
        } else {
            // Fallback on earlier versions
            
            continueButton.setAttributedTitle(NSAttributedString(string: NSLocalizedString("Continue", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]), for: .normal)
        }
        
    }
    
    @IBAction func continueGame(_ sender: Any) {
        if isFromFlag == true {
            if flagViewController.rewardBaseAd.isReady == true {
                flagViewController.rewardBaseAd.present(fromRootViewController: self)
            } else {
                let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Ad did not load", comment: ""), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default)
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            if nameViewController.rewardBaseAd.isReady == true {
                nameViewController.rewardBaseAd.present(fromRootViewController: self)
            } else {
                let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Ad did not load", comment: ""), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default)
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true) {
            self.initQuiz()
        }
    }
    
    func initQuiz() {
        if isFromFlag == true {
            self.flagViewController.initScore()
            self.flagViewController.initLife()
            self.flagViewController.initQuiz()
            self.flagViewController.makeQuiz()
            self.flagViewController.displayQuestion()
            self.flagViewController.textFitInButton()
            self.flagViewController.initButtons(array: flagViewController.buttonArray)
        } else {
            self.nameViewController.initScore()
            self.nameViewController.initLife()
            self.nameViewController.initQuiz()
            self.nameViewController.makeQuiz()
            self.nameViewController.displayQuestion()
            self.nameViewController.fitTextInLabel()
            self.nameViewController.initButtons(array: nameViewController.buttonArray)
        }

    }
    
    func fitTextInButton() {
        var fontSize: CGFloat = 100
        let border: CGFloat = 0
        repeat {
            fontSize -= 1
            scoreLabel.font = scoreLabel.font.withSize(fontSize)
        } while scoreLabel.textWidth() + border > popUpView.bounds.width
    }
    
}
