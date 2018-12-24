//
//  PopUpViewController.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 9. 3..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PopUpViewController: UIViewController, GADRewardBasedVideoAdDelegate {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var rewardBaseAd: GADRewardBasedVideoAd!
    
    var viewController: QuizViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        rewardBaseAd = GADRewardBasedVideoAd.sharedInstance()
        rewardBaseAd.delegate = self
        
        rewardBaseAd.load(GADRequest(), withAdUnitID: rewardAdUnitId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scoreLabel.text = ("\(viewController?.getScore() ?? -1) ") + NSLocalizedString("Point", comment: "")
    }
    
    @IBAction func continueGame(_ sender: Any) {
        if rewardBaseAd.isReady == true {
            rewardBaseAd.present(fromRootViewController: self)
        }
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        self.viewController?.earnLife(life: Int(truncating: reward.amount))
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad has completed.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
        
        dismiss(animated: true, completion: nil)
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
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
