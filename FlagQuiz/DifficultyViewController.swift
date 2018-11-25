//
//  DifficultyViewController.swift
//  FlagQuiz
//
//  Created by 이수한 on 24/11/2018.
//  Copyright © 2018 이수한. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController {
    @IBOutlet var difficultyRiseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        difficultyRiseLabel.text = NSLocalizedString("Level Up", comment: "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.closePopup()
        }
        
    }
    
    func closePopup() {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
