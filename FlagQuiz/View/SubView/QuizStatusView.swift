//
//  QuizStatusView.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/24.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class QuizStatusView: UIView {
  
  // MARK: - Properties
  
  private let firstLifeImageView: UIImageView = {
    let imageView = UIImageView()
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "heart")
    
    return imageView
  }()
  
  private let secondLifeImageView: UIImageView = {
    let imageView = UIImageView()
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "heart")
    
    return imageView
  }()
  
  private let thirdLifeImageView: UIImageView = {
    let imageView = UIImageView()
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "heart")
    
    return imageView
  }()
  
  private let fourthLifeImageView: UIImageView = {
    let imageView = UIImageView()
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "heart")
    
    return imageView
  }()
  
  private let fifthLifeImageView: UIImageView = {
    let imageView = UIImageView()
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "heart")
    
    return imageView
  }()
  
  private lazy var lifeStackView: UIStackView = {
    let stackView = UIStackView()
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    
    stackView.addArrangedSubview(firstLifeImageView)
    stackView.addArrangedSubview(secondLifeImageView)
    stackView.addArrangedSubview(thirdLifeImageView)
    stackView.addArrangedSubview(fourthLifeImageView)
    stackView.addArrangedSubview(fifthLifeImageView)
    
    return stackView
  }()
  
  private let scoreLabel: UILabel = {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.font = .systemFont(ofSize: 30, weight: .thin)
    
    return label
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
    addAllView()
    setupAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  
  private func configureView() {
    self.backgroundColor = .clear
    
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  // MARK: - Setup UI
  
  private func addAllView() {
    self.addSubview(lifeStackView)
    self.addSubview(scoreLabel)
  }
  
  private func setupAutoLayout() {
    setupFirstLifeImageViewAutoLayout()
    setupLifeStackViewAutoLayout()
    setupScoreLabelAutoLayout()
  }
  
  private func setupFirstLifeImageViewAutoLayout() {
    NSLayoutConstraint.activate([
      firstLifeImageView.widthAnchor .constraint(equalToConstant: 40.0),
    ])
  }
  
  private func setupLifeStackViewAutoLayout() {
    NSLayoutConstraint.activate([
      lifeStackView.topAnchor     .constraint(equalTo: self.topAnchor),
      lifeStackView.leadingAnchor .constraint(equalTo: self.leadingAnchor),
      lifeStackView.trailingAnchor.constraint(lessThanOrEqualTo: scoreLabel.leadingAnchor),
      lifeStackView.bottomAnchor  .constraint(equalTo: self.bottomAnchor),
    ])
  }
  
  private func setupScoreLabelAutoLayout() {
    NSLayoutConstraint.activate([
      scoreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      scoreLabel.centerYAnchor .constraint(equalTo: lifeStackView.centerYAnchor),
    ])
  }
  
  // MARK: - Element Control
  
  func setScoreLabel(text: String) {
    scoreLabel.text = text
  }
  
  func hideFirstLifeImageView(_ hidden: Bool) {
    firstLifeImageView.isHidden = hidden
  }
  
  func hideSecondLifeImageView(_ hidden: Bool) {
    secondLifeImageView.isHidden = hidden
  }
  
  func hideThirdLifeImageView(_ hidden: Bool) {
    thirdLifeImageView.isHidden = hidden
  }
  
  func hideFourthLifeImageView(_ hidden: Bool) {
    fourthLifeImageView.isHidden = hidden
  }
  
  func hideFifithLifeImageView(_ hidden: Bool) {
    fifthLifeImageView.isHidden = hidden
  }
  
}
