//
//  GameOverPopupView.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/30.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class GameOverPopupView: UIView {
  
  // MARK: - Properties
  
  var delegate: GameOverPopupViewDelegate?
  
  private let popupView: UIView = {
    let view = UIView()
    
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.backgroundColor = Color.systemBackground
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 8
    
    return view
  }()
  
  private let finalScoreLabel: UILabel = {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textColor = Color.label
    label.font = .systemFont(ofSize: 56, weight: .ultraLight)
    label.text = "Label"
    
    return label
  }()
  
  private let continueButton: UIButton = {
    let button = UIButton(type: .system)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.setTitleColor(Color.label, for: .normal)
    button.setTitle("Continue", for: .normal)
    
    button.addTarget(self, action: #selector(whenContinueButtonDidTouchUpInside(_:)), for: .touchUpInside)
    
    return button
  }()
  
  private let restartButton: UIButton = {
    let button = UIButton(type: .system)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.setTitleColor(Color.label, for: .normal)
    button.setTitle("Restart", for: .normal)
    
    button.addTarget(self, action: #selector(whenRestartButtonDidTouchUpInside(_:)), for: .touchUpInside)
    
    return button
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
    addAllView()
    setupPopupViewAutoLayout()
    setupFinalScoreLabelAutoLayout()
    setupContinueButtonAutoLayout()
    setupRestartButtonAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  
  private func configureView() {
    self.backgroundColor = Color.dim
  }
  
  // MARK: - Setup UI
  
  private func addAllView() {
    self.addSubview(popupView)
    popupView.addSubview(finalScoreLabel)
    popupView.addSubview(restartButton)
    popupView.addSubview(continueButton)
  }
  
  private func setupPopupViewAutoLayout() {
    let safeArea = self.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      popupView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      popupView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
      popupView.heightAnchor .constraint(equalToConstant: UI.Size.popupViewHeight),
      popupView.widthAnchor  .constraint(equalToConstant: UI.Size.popupViewWidth),
    ])
  }
  
  private func setupFinalScoreLabelAutoLayout() {
    NSLayoutConstraint.activate([
      finalScoreLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
      finalScoreLabel.centerYAnchor.constraint(equalTo: popupView.centerYAnchor, constant: -40)
    ])
  }
  
  private func setupContinueButtonAutoLayout() {
    NSLayoutConstraint.activate([
      continueButton.topAnchor    .constraint(equalTo: finalScoreLabel.bottomAnchor, constant: UI.Spacing.Top.mediumMargin),
      continueButton.centerXAnchor.constraint(equalTo: finalScoreLabel.centerXAnchor),
    ])
  }
  
  private func setupRestartButtonAutoLayout() {
    NSLayoutConstraint.activate([
      restartButton.topAnchor    .constraint(equalTo: continueButton.bottomAnchor, constant: UI.Spacing.Top.smallMargin),
      restartButton.centerXAnchor.constraint(equalTo: continueButton.centerXAnchor),
    ])
  }
  
  // MARK: - Action Handler
  
  @objc
  private func whenContinueButtonDidTouchUpInside(_ sender: UIButton) {
    delegate?.whenContinueButtonDidTouchUpInside(sender)
  }
  
  @objc
  private func whenRestartButtonDidTouchUpInside(_ sender: UIButton) {
    delegate?.whenRestartButtonDidTouchUpInside(sender)
  }
  
  // MARK: - Element Control
  
  func setFinalScoreLabel(text: String) { finalScoreLabel.text = text }
  
}
