//
//  QuestionView.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/22.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class QuestionView: UIView {
  
  // MARK: - Properties
  
  var delegate: QuestionViewDelegate?
  
  var buttonType: UIButton.ButtonType!
  
  private lazy var leftTopButton: AnswerButton = {
    let button = AnswerButton(location: .leftTop)
    
    button.addTarget(self, action: #selector(whenButtonDidTouchUpInsideAt(_:)), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var rightTopButton: AnswerButton = {
    let button = AnswerButton(location: .rightTop)
    
    button.addTarget(self, action: #selector(whenButtonDidTouchUpInsideAt(_:)), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var leftBottomButton: AnswerButton = {
    let button = AnswerButton(location: .leftBottom)
    
    button.addTarget(self, action: #selector(whenButtonDidTouchUpInsideAt(_:)), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var rightBottomButton: AnswerButton = {
    let button = AnswerButton(location: .rightBottom)
    
    button.addTarget(self, action: #selector(whenButtonDidTouchUpInsideAt(_:)), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var buttonList = [UIButton]()

  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
    configureButtonList()
    addAllView()
    setupAllAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(buttonType: UIButton.ButtonType) {
    self.buttonType = buttonType
    
    super.init(frame: .zero)
    
    configureView()
    configureButtonList()
    addAllView()
    setupAllAutoLayout()
  }
  
  // MARK: - Configuration
  
  private func configureView() {
    self.backgroundColor = .clear
  }
  
  private func configureButtonList() {
    buttonList.append(leftTopButton)
    buttonList.append(rightTopButton)
    buttonList.append(leftBottomButton)
    buttonList.append(rightBottomButton)
  }
  
  // MARK: - Setup UI
  
  private func addAllView() {
    for button in buttonList {
      self.addSubview(button)
    }
  }
  
  private func setupAllAutoLayout() {
    setupLeftTopButtonAutoLayout()
    setupRightTopButtonAutoLayout()
    setupLeftBottomButtonAutoLayout()
    setupRightBottomButtonAutoLayout()
  }
  
  private func setupLeftTopButtonAutoLayout() {
    NSLayoutConstraint.activate([
      leftTopButton.topAnchor    .constraint(equalTo: self.topAnchor),
      leftTopButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      leftTopButton.heightAnchor .constraint(equalTo: self.heightAnchor, multiplier: 0.5),
      leftTopButton.widthAnchor  .constraint(equalTo: self.widthAnchor,  multiplier: 0.5),
    ])
  }
  
  private func setupRightTopButtonAutoLayout() {
    NSLayoutConstraint.activate([
      rightTopButton.topAnchor    .constraint(equalTo: leftTopButton.topAnchor),
      rightTopButton.leadingAnchor.constraint(equalTo: leftTopButton.trailingAnchor),
      rightTopButton.heightAnchor .constraint(equalTo: leftTopButton.heightAnchor),
      rightTopButton.widthAnchor  .constraint(equalTo: leftTopButton.widthAnchor),
    ])
  }
  
  private func setupLeftBottomButtonAutoLayout() {
    NSLayoutConstraint.activate([
      leftBottomButton.topAnchor    .constraint(equalTo: leftTopButton.bottomAnchor),
      leftBottomButton.leadingAnchor.constraint(equalTo: leftTopButton.leadingAnchor),
      leftBottomButton.heightAnchor .constraint(equalTo: leftTopButton.heightAnchor),
      leftBottomButton.widthAnchor  .constraint(equalTo: leftTopButton.widthAnchor),
    ])
  }
  
  private func setupRightBottomButtonAutoLayout() {
    NSLayoutConstraint.activate([
      rightBottomButton.topAnchor    .constraint(equalTo: leftBottomButton.topAnchor),
      rightBottomButton.leadingAnchor.constraint(equalTo: leftBottomButton.trailingAnchor),
      rightBottomButton.heightAnchor .constraint(equalTo: leftTopButton   .heightAnchor),
      rightBottomButton.widthAnchor  .constraint(equalTo: leftTopButton   .widthAnchor),
    ])
  }
  
  // MARK: - Action Handler
  
  @objc
  private func whenButtonDidTouchUpInsideAt(_ sender: AnswerButton) {
    delegate?.button(sender, didTouchUpInsideAt: sender.location)
  }
  
  // MARK: - Element Control
  
  func setLeftTopButton(text: String) {
    leftTopButton.setTitle(text, for: .normal)
    leftTopButton.setTitle(text, for: .disabled)
  }
  
  func setRightTopButton(text: String) {
    rightTopButton.setTitle(text, for: .normal)
    rightTopButton.setTitle(text, for: .disabled)
  }
  
  func setLeftBottomButton(text: String) {
    leftBottomButton.setTitle(text, for: .normal)
    leftBottomButton.setTitle(text, for: .disabled)
  }
  
  func setRightBottomButton(text: String) {
    rightBottomButton.setTitle(text, for: .normal)
    rightBottomButton.setTitle(text, for: .disabled)
  }
  
  func setLeftTopButton(image: UIImage) {
    leftTopButton.setImage(image, for: .normal)
  }
  
  func setRightTopButton(image: UIImage) {
    rightTopButton.setImage(image, for: .normal)
  }
  
  func setLeftBottomButton(image: UIImage) {
    leftBottomButton.setImage(image, for: .normal)
  }
  
  func setRightBottomButton(image: UIImage) {
    rightBottomButton.setImage(image, for: .normal)
  }
  
  func makeAllButtonsEnable(_ enable: Bool) {
    for button in buttonList {
      button.isEnabled = enable
    }
  }
  
}
