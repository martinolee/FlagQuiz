//
//  FlagInfoTableViewCell.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/22.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class FlagInfoTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  
  static let identifier = "FlagInfoTableViewCell"
  
  private let flagImageView: UIImageView = {
    let imageView = UIImageView()
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    imageView.contentMode = .scaleAspectFit
    
    return imageView
  }()
  
  private let countryNameLabel: UILabel = {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 30, weight: .regular)
    label.numberOfLines = 0
    
    return label
  }()
  
  // MARK: - Initialization
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configureCell()
    addAllView()
    setupFlagImageViewAutoLayout()
    setupCountryNameLabelAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  
  private func configureCell() {
    self.backgroundColor = Color.tertiarySystemGroupedBackground
  }
  
  // MARK: - Setup UI
  
  private func addAllView() {
    self.addSubview(flagImageView)
    self.addSubview(countryNameLabel)
  }
  
  private func setupFlagImageViewAutoLayout() {
    NSLayoutConstraint.activate([
      flagImageView.topAnchor     .constraint(equalTo: self.topAnchor, constant: 4),
      flagImageView.leadingAnchor .constraint(equalTo: self.leadingAnchor, constant: 16),
      flagImageView.trailingAnchor.constraint(equalTo: countryNameLabel.leadingAnchor, constant: -8),
      flagImageView.bottomAnchor  .constraint(equalTo: self.bottomAnchor, constant: -4),
      flagImageView.widthAnchor   .constraint(equalToConstant: 150),
      flagImageView.heightAnchor  .constraint(equalToConstant: 100),
    ])
  }
  
  private func setupCountryNameLabelAutoLayout() {
    NSLayoutConstraint.activate([
      countryNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
      countryNameLabel.centerYAnchor .constraint(equalTo: flagImageView.centerYAnchor),
    ])
  }
  
  // MARK: - Element Control
  
  func set(flagImage: UIImage, countryName: String) {
    flagImageView.image = flagImage
    countryNameLabel.text = countryName
  }
}
