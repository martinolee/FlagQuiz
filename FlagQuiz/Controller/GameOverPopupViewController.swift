//
//  GameOverPopupViewController.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/30.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class GameOverPopupViewController: UIViewController {
  
  // MARK: - Properties
  
  private let gameOverPopupView = GameOverPopupView()
  
  var finalScore: Int!
  
  // MARK: - Life Cycle
  
  override func loadView() {
    super.loadView()
    
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
  
}

extension GameOverPopupViewController: GameOverPopupViewDelegate {
  func whenContinueButtonDidTouchUpInside(_ button: UIButton) {
    
  }
  
  func whenRestartButtonDidTouchUpInside(_ button: UIButton) {
    let quizTabBarController = presentingViewController as! QuizTabBarController
    var quizViewController: QuizViewController?
    
    if quizTabBarController.selectedIndex == QuizType.flag.key {
      let flagQuizViewController =
        quizTabBarController.viewControllers![quizTabBarController.selectedIndex] as! FlagQuizViewController
      
      Singleton.shared.flagQuiz.initQuiz()
      flagQuizViewController.makeQuestion(for: FlagQuizViewController.self)
      
      quizViewController = flagQuizViewController
    } else if quizTabBarController.selectedIndex == QuizType.name.key {
      let nameQuizViewController =
        quizTabBarController.viewControllers![quizTabBarController.selectedIndex] as! NameQuizViewController
      
      Singleton.shared.nameQuiz.initQuiz()
      nameQuizViewController.makeQuestion(for: NameQuizViewController.self)
      
      quizViewController = nameQuizViewController
    }
    
    dismiss(animated: true) {
      let flagQuizViewController = quizViewController as? FlagQuizViewController
      let nameQuizViewController = quizViewController as? NameQuizViewController
      
      if flagQuizViewController != nil {
        flagQuizViewController!.initLifeImageView()
        flagQuizViewController!.initScoreLabel()
        flagQuizViewController!.makeAllButtonsEnable()
        flagQuizViewController!.showQuestion()
      } else if nameQuizViewController != nil {
        nameQuizViewController!.initLifeImageView()
        nameQuizViewController!.initScoreLabel()
        nameQuizViewController!.makeAllButtonsEnable()
        nameQuizViewController!.showQuestion()
      }
    }
  }
}
