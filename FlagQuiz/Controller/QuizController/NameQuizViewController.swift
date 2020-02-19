//
//  NameQuizViewController.swift
//  nameQuiz
//
//  Created by Soohan Lee on 2020/01/20.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

final class NameQuizViewController: QuizViewController {
  
  // MARK: - Properties
  
  private let nameQuizView = NameQuizView()
  
  // MARK: Life Cycle
  
  override func loadView() {
    super.loadView()
    
    nameQuizView.delegate = self
    
    view = nameQuizView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initNameQuizViewController()
  }
  
  private func initNameQuizViewController() {
    makeQuestion(for: NameQuizViewController.self)
    showQuestion()
    
    nameQuizView.setScoreLabel(text: "\(Singleton.shared.nameQuiz.score)")
    
    nameQuizView.setRootViewControllerForBannerView(self)
    nameQuizView.loadBannerViewAD()
  }
  
  // MARK: -
  
  private func showCorrectOrIncorrectPopup(text: String, color: UIColor) {
    nameQuizView.setCorrectOrIncorrectLabel(text: text)
    nameQuizView.setCorrectOrIncorrectViewBackgroundColor(color)
    
    UIView.animateKeyframes(withDuration: 0.6, delay: 0, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1 / 2) {
        self.nameQuizView.setCorrectOrIncorrectViewAlpha(1)
      }
      UIView.addKeyframe(withRelativeStartTime: 1 / 2, relativeDuration: 1 / 2) {
        self.nameQuizView.setCorrectOrIncorrectViewAlpha(0)
      }
    })
  }
  
  // MARK: -
  
  func showQuestion() {
    guard let currentQuestion = Singleton.shared.nameQuiz.questionList.last else { return }
    
    let countryIndex = currentQuestion.answers
    let leftTopButtonCountry     = Singleton.shared.countryInfo[countryIndex[ButtonLocation.leftTop    .key]]
    let rightTopButtonCountry    = Singleton.shared.countryInfo[countryIndex[ButtonLocation.rightTop   .key]]
    let leftBottomButtonCountry  = Singleton.shared.countryInfo[countryIndex[ButtonLocation.leftBottom .key]]
    let rightBottomButtonCountry = Singleton.shared.countryInfo[countryIndex[ButtonLocation.rightBottom.key]]
    let countryName: String!
    
    switch currentQuestion.correctAnswerLocation {
    case .leftTop    : countryName = leftTopButtonCountry    .name
    case .rightTop   : countryName = rightTopButtonCountry   .name
    case .leftBottom : countryName = leftBottomButtonCountry .name
    case .rightBottom: countryName = rightBottomButtonCountry.name
    }
    
    guard
      let leftTopButtonnameImage     = UIImage(named: leftTopButtonCountry    .flagImageName),
      let rightTopButtonnameImage    = UIImage(named: rightTopButtonCountry   .flagImageName),
      let leftBottomButtonnameImage  = UIImage(named: leftBottomButtonCountry .flagImageName),
      let rightBottomButtonnameImage = UIImage(named: rightBottomButtonCountry.flagImageName) else { return }
    
    nameQuizView.setLeftTopButton    (image: leftTopButtonnameImage)
    nameQuizView.setRightTopButton   (image: rightTopButtonnameImage)
    nameQuizView.setLeftBottomButton (image: leftBottomButtonnameImage)
    nameQuizView.setRightBottomButton(image: rightBottomButtonnameImage)
    
    let localizedCountryName = NSLocalizedString(countryName, comment: "Country name")
    nameQuizView.setCountryNameLabel(text: localizedCountryName)
  }
  
  func initLifeImageView(_ count: Int) {
    switch count {
    case 4: nameQuizView.hideFifithLifeImageView(false)
      fallthrough
    case 3: nameQuizView.hideFourthLifeImageView(false)
      fallthrough
    case 2: nameQuizView.hideThirdLifeImageView (false)
      fallthrough
    case 1: nameQuizView.hideSecondLifeImageView(false)
      fallthrough
    case 0: nameQuizView.hideFirstLifeImageView (false)
    default: break
    }
  }
  
  func makeAllButtonsEnable() {
    nameQuizView.makeAllButtonsEnable(true)
  }
  
  func initScoreLabel() {
    nameQuizView.setScoreLabel(text: "\(Singleton.shared.nameQuiz.score)")
  }
  
}

extension NameQuizViewController: NameQuizViewDelegate {
  func button(_ button: AnswerButton, didTouchUpInsideAt location: ButtonLocation) {
    let isCorrect = checkIsCorrect(answerLocation: location, for: NameQuizViewController.self)
    
    if isCorrect {
      Singleton.shared.nameQuiz.score += 1
      nameQuizView.setScoreLabel(text: "\(Singleton.shared.nameQuiz.score)")
      
      nameQuizView.makeAllButtonsEnable(false)
      
      showCorrectOrIncorrectPopup(text: "Correct", color: Color.systemBlue)
      
      makeQuestion(for: NameQuizViewController.self)
      
      let delay: DispatchTime = .now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: delay) {
          self.showQuestion()
          self.nameQuizView.makeAllButtonsEnable(true)
        }
    } else {
      Singleton.shared.nameQuiz.life -= 1
      
      button.isEnabled = false
      
      showCorrectOrIncorrectPopup(text: "Incorrect", color: Color.systemRed)
      
      switch Singleton.shared.nameQuiz.life {
      case 4:
        nameQuizView.hideFifithLifeImageView(true)
      case 3:
        nameQuizView.hideFourthLifeImageView(true)
      case 2:
        nameQuizView.hideThirdLifeImageView(true)
      case 1:
        nameQuizView.hideSecondLifeImageView(true)
      case 0:
        nameQuizView.hideFirstLifeImageView(true)
        
        let gameOverPopupViewController = GameOverPopupViewController()
        
        gameOverPopupViewController.modalPresentationStyle = .overFullScreen
        gameOverPopupViewController.modalTransitionStyle = .crossDissolve
        
        gameOverPopupViewController.finalScore = Singleton.shared.nameQuiz.score
        
        present(gameOverPopupViewController, animated: true)
      default: break
      }
    }
  }
}
