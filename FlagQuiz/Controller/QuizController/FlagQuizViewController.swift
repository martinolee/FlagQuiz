//
//  FlagQuizViewController.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/20.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

final class FlagQuizViewController: QuizViewController {
  
  // MARK: - Properties
  
  let flagQuizView = FlagQuizView()
  
  // MARK: Life Cycle
  
  override func loadView() {
    super.loadView()
    
    flagQuizView.delegate = self
    
    view = flagQuizView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initFlagQuizViewController()
    flagQuizView.setRootViewControllerForBannerView(self)
    flagQuizView.loadBannerViewAD()
  }
  
  // MARK: - Configuration
  
  private func initFlagQuizViewController() {
    makeQuestion(for: FlagQuizViewController.self)
    showQuestion()
    
    flagQuizView.setScoreLabel(text: "\(Singleton.shared.flagQuiz.score)")
  }
  
  // MARK: - 
  
  private func showCorrectOrIncorrectPopup(text: String, color: UIColor) {
    flagQuizView.setCorrectOrIncorrectLabel(text: text)
    flagQuizView.setCorrectOrIncorrectViewBackgroundColor(color)
    
    UIView.animateKeyframes(withDuration: 0.6, delay: 0, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1 / 2) {
        self.flagQuizView.setCorrectOrIncorrectViewAlpha(1)
      }
      UIView.addKeyframe(withRelativeStartTime: 1 / 2, relativeDuration: 1 / 2) {
        self.flagQuizView.setCorrectOrIncorrectViewAlpha(0)
      }
    })
  }
  
  // MARK: -
  
  func showQuestion() {
    guard let currentQuestion = Singleton.shared.flagQuiz.questionList.last else { return }
    
    let countryIndex = currentQuestion.answers
    let leftTopButtonCountry     = Singleton.shared.countryInfo[countryIndex[ButtonLocation.leftTop    .key]]
    let rightTopButtonCountry    = Singleton.shared.countryInfo[countryIndex[ButtonLocation.rightTop   .key]]
    let leftBottomButtonCountry  = Singleton.shared.countryInfo[countryIndex[ButtonLocation.leftBottom .key]]
    let rightBottomButtonCountry = Singleton.shared.countryInfo[countryIndex[ButtonLocation.rightBottom.key]]
    let flagImage: UIImage!
    
    switch currentQuestion.correctAnswerLocation {
    case .leftTop    : flagImage = UIImage(named: leftTopButtonCountry    .flagImageName)
    case .rightTop   : flagImage = UIImage(named: rightTopButtonCountry   .flagImageName)
    case .leftBottom : flagImage = UIImage(named: leftBottomButtonCountry .flagImageName)
    case .rightBottom: flagImage = UIImage(named: rightBottomButtonCountry.flagImageName)
    }
    
    flagQuizView.setLeftTopButton    (text: leftTopButtonCountry    .name)
    flagQuizView.setRightTopButton   (text: rightTopButtonCountry   .name)
    flagQuizView.setLeftBottomButton (text: leftBottomButtonCountry .name)
    flagQuizView.setRightBottomButton(text: rightBottomButtonCountry.name)
    
    flagQuizView.setFlagImageView(flagImage)
  }
  
  func initLifeImageView() {
      flagQuizView.hideFifithLifeImageView(false)
      flagQuizView.hideFourthLifeImageView(false)
      flagQuizView.hideThirdLifeImageView (false)
      flagQuizView.hideSecondLifeImageView(false)
      flagQuizView.hideFirstLifeImageView (false)
  }
  
  func makeAllButtonsEnable() {
    flagQuizView.makeAllButtonsEnable(true)
  }
  
  func initScoreLabel() {
    flagQuizView.setScoreLabel(text: "\(Singleton.shared.flagQuiz.score)")
  }
  
}

extension FlagQuizViewController: FlagQuizViewDelegate {
  func button(_ button: AnswerButton, didTouchUpInsideAt location: ButtonLocation) {
    let isCorrect = checkIsCorrect(answerLocation: location, for: FlagQuizViewController.self)
    
    if isCorrect {
      Singleton.shared.flagQuiz.score += 1
      flagQuizView.setScoreLabel(text: "\(Singleton.shared.flagQuiz.score)")
        
      flagQuizView.makeAllButtonsEnable(false)
      button.setTitleColor(Color.systemBlue, for: .disabled)
      
      showCorrectOrIncorrectPopup(text: "Correct", color: Color.systemBlue)
      
      makeQuestion(for: FlagQuizViewController.self)
      
      let delay = 0.5
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        self.showQuestion()
        button.setTitleColor(Color.label,     for: .normal)
        button.setTitleColor(Color.systemRed, for: .disabled)
        self.flagQuizView.makeAllButtonsEnable(true)
      }
    } else {
      Singleton.shared.flagQuiz.life -= 1
      
      button.isEnabled = false
      
      showCorrectOrIncorrectPopup(text: "Incorrect", color: Color.systemRed)
      
      switch Singleton.shared.flagQuiz.life {
      case 4:
        flagQuizView.hideFifithLifeImageView(true)
      case 3:
        flagQuizView.hideFourthLifeImageView(true)
      case 2:
        flagQuizView.hideThirdLifeImageView(true)
      case 1:
        flagQuizView.hideSecondLifeImageView(true)
      case 0:
        flagQuizView.hideFirstLifeImageView(true)
        
        let gameOverPopupViewController = GameOverPopupViewController()
        
        gameOverPopupViewController.modalPresentationStyle = .overFullScreen
        gameOverPopupViewController.modalTransitionStyle = .crossDissolve
        
        gameOverPopupViewController.finalScore = Singleton.shared.flagQuiz.score
        
        present(gameOverPopupViewController, animated: true)
      default:
        break
      }
    }
    
  }
}
