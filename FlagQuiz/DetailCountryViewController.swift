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
    
    @IBAction func moveToBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailFlagImageView.image = UIImage(named: imageName!)
    }

}
