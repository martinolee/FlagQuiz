//
//  DetailCountryViewController.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 6. 18..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit

class DetailCountryViewController: UIViewController {
    @IBOutlet weak var detailFlagImageView: UIImageView!
    
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailFlagImageView.image = UIImage(named: imageName!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }

}
