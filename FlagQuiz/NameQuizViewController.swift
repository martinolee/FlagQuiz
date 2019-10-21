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
        
        displayQuestion()
        
        bannerView.adUnitID = bannerAdUnitID
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
    }
    
    override func displayQuestion() {
        print("NameQuizViewController.displayQuestion()")
        
        for i in 0...3 {
            buttonArray[i].imageView?.image = UIImage(named: flagInfo[quizList[currentQuizIndex].example[i]].imageName)
        }
    }
}
