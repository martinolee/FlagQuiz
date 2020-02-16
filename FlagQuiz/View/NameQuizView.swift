//
//  NameQuizView.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/20.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class NameQuizView: UIView {
  
  // MARK: - Properties
  
  var delegate: NameQuizViewDelegate?
  
  private let quizStatusView: QuizStatusView = {
    let view = QuizStatusView()
    
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  private let separatorView: SeparatorView = {
    let view = SeparatorView()
    
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  private let correctOrIncorrectView: CorrectOrIncorrectView = {
    let view = CorrectOrIncorrectView()
    
    return view
  }()
  
  private let countryNameLabel: UILabel = {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 80, weight: .thin)
    label.numberOfLines = 0
    
    return label
  }()
  
  private lazy var questionView: QuestionView = {
    let view = QuestionView(buttonType: .custom)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    
    return view
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
    addAllView()
    setupAllAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  
  private func configureView() {
    self.backgroundColor = Color.tertiarySystemGroupedBackground
  }
  
  // MARK: - Setup UI
  
  private func addAllView() {
    self.addSubview(quizStatusView)
    self.addSubview(separatorView)
    self.addSubview(correctOrIncorrectView)
    self.addSubview(countryNameLabel)
    self.addSubview(questionView)
  }
  
  private func setupAllAutoLayout() {
    setupLifeScoreViewAutoLayout()
    setupSeparatorViewAutoLayout()
    setupCorrectOrIncorrectViewAutoLayout()
    setupCountryNameLabelAutoLayout()
    setupQuestionViewAutoLayout()
  }
  
  private func setupLifeScoreViewAutoLayout() {
    let safeArea = self.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      quizStatusView.topAnchor     .constraint(equalTo: safeArea.topAnchor),
      quizStatusView.leadingAnchor .constraint(equalTo: safeArea.leadingAnchor,  constant: UI.Spacing.Leading .toSafeArea),
      quizStatusView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: UI.Spacing.Trailing.toSafeArea),
      quizStatusView.heightAnchor  .constraint(equalToConstant: UI.Size.quizStatusViewHeight),
    ])
  }
  
  private func setupSeparatorViewAutoLayout() {
    let safeArea = self.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      separatorView.topAnchor     .constraint(equalTo: quizStatusView.bottomAnchor),
      separatorView.leadingAnchor .constraint(equalTo: safeArea.leadingAnchor),
      separatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
    ])
  }
  
  private func setupCorrectOrIncorrectViewAutoLayout() {
    NSLayoutConstraint.activate([
      correctOrIncorrectView.topAnchor    .constraint(equalTo: separatorView.bottomAnchor, constant: UI.Spacing.Top.forCorrectOrIncorrectView),
      correctOrIncorrectView.centerXAnchor.constraint(equalTo: separatorView.centerXAnchor),
    ])
  }
  
  private func setupCountryNameLabelAutoLayout() {
    let safeArea = self.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      countryNameLabel.topAnchor     .constraint(equalTo: separatorView.bottomAnchor),
      countryNameLabel.leadingAnchor .constraint(equalTo: safeArea.leadingAnchor),
      countryNameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      countryNameLabel.bottomAnchor  .constraint(equalTo: questionView.topAnchor),
    ])
  }
  
  private func setupQuestionViewAutoLayout() {
    let safeArea = self.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      questionView.leadingAnchor .constraint(equalTo: safeArea.leadingAnchor),
      questionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      questionView.bottomAnchor  .constraint(equalTo: safeArea.bottomAnchor),
      questionView.heightAnchor  .constraint(equalToConstant: 300),
    ])
  }
  
  // MARK: - Element Control
  
  func setCountryNameLabel(text: String) {
    countryNameLabel.text = text
  }
  
  func setScoreLabel(text: String) {
    quizStatusView.setScoreLabel(text: text)
  }
  
  func setLeftTopButton(image: UIImage) {
    questionView.setLeftTopButton(image: image)
  }
  
  func setRightTopButton(image: UIImage) {
    questionView.setRightTopButton(image: image)
  }
  
  func setLeftBottomButton(image: UIImage) {
    questionView.setLeftBottomButton(image: image)
  }
  
  func setRightBottomButton(image: UIImage) {
    questionView.setRightBottomButton(image: image)
  }
  
  func makeAllButtonsEnable(_ enable: Bool) {
    questionView.makeAllButtonsEnable(enable)
  }
  
  func hideFirstLifeImageView(_ hidden: Bool) {
    quizStatusView.hideFirstLifeImageView(hidden)
  }
  
  func hideSecondLifeImageView(_ hidden: Bool) {
    quizStatusView.hideSecondLifeImageView(hidden)
  }
  
  func hideThirdLifeImageView(_ hidden: Bool) {
    quizStatusView.hideThirdLifeImageView(hidden)
  }
  
  func hideFourthLifeImageView(_ hidden: Bool) {
    quizStatusView.hideFourthLifeImageView(hidden)
  }
  
  func hideFifithLifeImageView(_ hidden: Bool) {
    quizStatusView.hideFifithLifeImageView(hidden)
  }
  
  func setCorrectOrIncorrectViewAlpha(_ alpha: CGFloat) {
    correctOrIncorrectView.alpha = alpha
  }
  
  func setCorrectOrIncorrectViewBackgroundColor(_ color: UIColor) {
    correctOrIncorrectView.backgroundColor = color
  }
  
  func setCorrectOrIncorrectLabel(text: String) {
    correctOrIncorrectView.setCorrectOrIncorrectLabel(text: text)
  }
  
}

extension NameQuizView: QuestionViewDelegate {
  func button(_ button: AnswerButton, didTouchUpInsideAt location: ButtonLocation) {
    delegate?.button(button, didTouchUpInsideAt: location)
  }
}
