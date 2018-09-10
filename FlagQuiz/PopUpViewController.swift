//
//  PopUpViewController.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 9. 3..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var viewController: ViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scoreLabel.text = ("\(viewController?.getScore() ?? -1)")
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true) {
            self.viewController?.initScore()
            self.viewController?.initLife()
            self.viewController?.initQuiz()
            self.viewController?.makeQuestion()
            self.viewController?.textFitInButton()
            self.viewController?.setDefaultButtonStyle()
            self.viewController?.correctOrInaccurateLabel.text = ""
        }
    }
    
}
