//
//  CorrectOrIncorrectView.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/02/14.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class CorrectOrIncorrectView: UIView {
  
  // MARK: - Properties
  
  private let correctOrIncorrectLabel: UILabel = {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .center
    label.textColor = Color.white
    label.font = .systemFont(ofSize: 23, weight: .medium)
    
    return label
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
    addAllView()
    setupCorrectOrIncorrectViewAutoLayout()
    setupCorrectOrIncorrectLabelAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  
  private func configureView() {
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.layer.masksToBounds = true
    self.layer.cornerRadius = UI.CornerRadius.forCorrectOrIncorectView
  }
  
  // MARK: - Setup UI
  
  private func addAllView() {
    self.addSubview(correctOrIncorrectLabel)
  }
  
  private func setupCorrectOrIncorrectViewAutoLayout() {
    NSLayoutConstraint.activate([
      self.widthAnchor .constraint(greaterThanOrEqualToConstant: UI.Size.correctOrIncorrectViewWidth),
      self.heightAnchor.constraint(greaterThanOrEqualToConstant: UI.Size.correctOrIncorrectViewHeight),
    ])
  }
  
  private func setupCorrectOrIncorrectLabelAutoLayout() {
    NSLayoutConstraint.activate([
      correctOrIncorrectLabel.topAnchor     .constraint(greaterThanOrEqualTo: self.topAnchor),
      correctOrIncorrectLabel.leadingAnchor .constraint(greaterThanOrEqualTo: self.leadingAnchor),
      correctOrIncorrectLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor),
      correctOrIncorrectLabel.bottomAnchor  .constraint(greaterThanOrEqualTo: self.bottomAnchor),
      correctOrIncorrectLabel.centerXAnchor .constraint(equalTo: self.centerXAnchor),
      correctOrIncorrectLabel.centerYAnchor .constraint(equalTo: self.centerYAnchor),
    ])
  }
  
  // MARK: - Element Control
  
  func setCorrectOrIncorrectLabel(text: String) {
    correctOrIncorrectLabel.text = text
  }
  
}
