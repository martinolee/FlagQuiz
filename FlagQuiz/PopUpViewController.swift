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
    
    var viewController: QuizViewController! =  QuizViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scoreLabel.text = ("\(viewController?.getScore() ?? -1) ") + NSLocalizedString("Point", comment: "")
        
        restartButton.setTitle(NSLocalizedString("Restart", comment: ""), for: .normal)
        continueButton.setTitle(NSLocalizedString("Continue", comment: ""), for: .normal)
    }
    
    @IBAction func continueGame(_ sender: Any) {
        if viewController?.rewardBaseAd.isReady == true {
            viewController?.rewardBaseAd.present(fromRootViewController: self)
        }
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true) {
            self.viewController?.initScore()
            self.viewController?.initLife()
            self.viewController?.initQuiz()
            self.viewController?.makeQuestion()
            self.viewController?.textFitInButton()
            self.viewController?.setDefaultButtonStyle()
        }
    }
    
}
