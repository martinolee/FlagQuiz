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
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var restartButton: UIButton!
    @IBOutlet var continueButton: UIButton!
    
    @IBOutlet var popupViewWidth: NSLayoutConstraint!
    
    var viewController: FlagQuizViewController! =  FlagQuizViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scoreLabel.text = ("\(viewController?.getScore() ?? -1) ") + NSLocalizedString("Point", comment: "")
        
        restartButton.setTitle(NSLocalizedString("Restart", comment: ""), for: .normal)
        continueButton.setAttributedTitle(NSAttributedString(string: NSLocalizedString("Continue", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]), for: .normal)
        
//        print("label width: \(), popup width: \(popupViewWidth.constant)")
//        fitTextInLabel()
//        print("label width: \(), popup width: \(popupViewWidth.constant)")
        
    }
    
    @IBAction func continueGame(_ sender: Any) {
        if viewController?.rewardBaseAd.isReady == true {
            viewController?.rewardBaseAd.present(fromRootViewController: self)
        } else {
            let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Ad did not load", comment: ""), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true) {
            self.initQuiz()
        }
    }
    
    func initQuiz() {
        self.viewController?.initScore()
        self.viewController?.initLife()
        self.viewController?.initQuiz()
        self.viewController?.makeQuestion()
        self.viewController?.displayQuestion()
        self.viewController?.textFitInButton()
        self.viewController?.setDefaultButtonStyle()
    }
    
    func fitTextInLabel() {
        if let title = scoreLabel.text, var font = scoreLabel.font {
            var fontSize: CGFloat = 56
            var attr = [NSAttributedString.Key.font: font]
            repeat {
                fontSize = fontSize - 1
                scoreLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .ultraLight)
                font = (scoreLabel.font)!
                attr = [NSAttributedString.Key.font: font]
                
            } while title.size(withAttributes: attr).width > popupViewWidth.constant
        }
        
    }
    
}
