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
    
    override func displayQuestion() {
        print("NameQuizViewController.displayQuestion()")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = bannerAdUnitID
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
    }
}
