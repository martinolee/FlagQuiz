//
//  GameOverPopupViewController.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/30.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GameOverPopupViewController: UIViewController {
  
  // MARK: - Properties
  
  private let gameOverPopupView = GameOverPopupView()
  
  private var hasWatchedFlagAD = false
  private var hasWatchedNameAD = false
  
  private var hasStartedPlayingFlagAD = false
  private var hasStartedPlayingNameAD = false
  
  var finalScore: Int!
  
  // MARK: - Life Cycle
  
  override func loadView() {
    gameOverPopupView.delegate = self
    
    view = gameOverPopupView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewController()
    setFinalScoreLabel()
  }
  
  // MARK: - Configuration
  
  private func configureViewController() {
    self.modalPresentationStyle = .fullScreen
    self.modalTransitionStyle = .crossDissolve
  }
  
  func setFinalScoreLabel() {
    gameOverPopupView.setFinalScoreLabel(text: "\(finalScore!) Point")
  }
  
  private func getPresentingViewController() -> QuizViewController {
    let quizTabBarController = presentingViewController as! QuizTabBarController
    var quizViewController: QuizViewController!
    
    if quizTabBarController.selectedIndex == QuizType.flag.key {
      let flagQuizViewController =
        quizTabBarController.viewControllers![quizTabBarController.selectedIndex] as! FlagQuizViewController
      
      quizViewController = flagQuizViewController
    } else if quizTabBarController.selectedIndex == QuizType.name.key {
      let nameQuizViewController =
        quizTabBarController.viewControllers![quizTabBarController.selectedIndex] as! NameQuizViewController
      
      quizViewController = nameQuizViewController
    }
    
    return quizViewController
  }
  
}

extension GameOverPopupViewController: GameOverPopupViewDelegate {
  func whenContinueButtonDidTouchUpInside(_ button: UIButton) {
    let flagQuizViewController = getPresentingViewController() as? FlagQuizViewController
    let nameQuizViewController = getPresentingViewController() as? NameQuizViewController
    
    if flagQuizViewController != nil {
      if Singleton.shared.flagRewardedAD.isReady {
        Singleton.shared.flagRewardedAD.present(fromRootViewController: self, delegate: self)
      }
    } else if nameQuizViewController != nil {
      if Singleton.shared.nameRewardedAD.isReady {
        Singleton.shared.nameRewardedAD.present(fromRootViewController: self, delegate: self)
      }
    }
  }
  
  func whenRestartButtonDidTouchUpInside(_ button: UIButton) {
    let flagQuizViewController = getPresentingViewController() as? FlagQuizViewController
    let nameQuizViewController = getPresentingViewController() as? NameQuizViewController
    
    dismiss(animated: true) {
      if flagQuizViewController != nil {
        Singleton.shared.flagQuiz.initQuiz()
        flagQuizViewController!.makeQuestion(for: FlagQuizViewController.self)
        flagQuizViewController!.initLifeImageView(4)
        flagQuizViewController!.initScoreLabel()
        flagQuizViewController!.makeAllButtonsEnable()
        flagQuizViewController!.showQuestion()
      } else if nameQuizViewController != nil {
        Singleton.shared.nameQuiz.initQuiz()
        nameQuizViewController!.makeQuestion(for: NameQuizViewController.self)
        nameQuizViewController!.initLifeImageView(4)
        nameQuizViewController!.initScoreLabel()
        nameQuizViewController!.makeAllButtonsEnable()
        nameQuizViewController!.showQuestion()
      }
    }
  }
}

extension GameOverPopupViewController: GADRewardedAdDelegate {
  /// Tells the delegate that the user earned a reward.
  func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
    print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    
    let flagQuizViewController = getPresentingViewController() as? FlagQuizViewController
    let nameQuizViewController = getPresentingViewController() as? NameQuizViewController
    
    if flagQuizViewController != nil {
      hasWatchedFlagAD = true
      Singleton.shared.flagQuiz.life = 2
      flagQuizViewController!.initLifeImageView(1)
    } else if nameQuizViewController != nil {
      hasWatchedNameAD = true
      Singleton.shared.nameQuiz.life = 2
      nameQuizViewController!.initLifeImageView(1)
    }
  }
  
  /// Tells the delegate that the rewarded ad was presented.
  func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
    print("Rewarded ad presented.")
    
    let flagQuizViewController = getPresentingViewController() as? FlagQuizViewController
    let nameQuizViewController = getPresentingViewController() as? NameQuizViewController
    
    if flagQuizViewController != nil {
      hasStartedPlayingFlagAD = true
    } else if nameQuizViewController != nil {
      hasStartedPlayingNameAD = true
    }
  }
  
  /// Tells the delegate that the rewarded ad was dismissed.
  func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
    print("Rewarded ad dismissed.")
    
    if hasStartedPlayingFlagAD {
      Singleton.shared.flagRewardedAD = GADRewardedAd(adUnitID: AdvertisingIdentifier.flagRewardedADUnitId)
      
      Singleton.shared.flagRewardedAD.load(GADRequest()) { error in
        if let error = error {
          print("Loading failed: \(error)")
        } else {
          print("Loading Succeeded")
        }
      }
    } else if hasStartedPlayingNameAD {
      Singleton.shared.nameRewardedAD = GADRewardedAd(adUnitID: AdvertisingIdentifier.nameRewardedADUnitId)
      
      Singleton.shared.nameRewardedAD.load(GADRequest()) { error in
        if let error = error {
          print("Loading failed: \(error)")
        } else {
          print("Loading Succeeded")
        }
      }
    }
    
    if hasWatchedFlagAD || hasWatchedNameAD { dismiss(animated: true) }
  }
  
  /// Tells the delegate that the rewarded ad failed to present.
  func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
    print("Rewarded ad failed to present.")
  }
}
