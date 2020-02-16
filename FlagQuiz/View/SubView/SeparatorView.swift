//
//  SeparatorView.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/20.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class SeparatorView: UIView {
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
    setupSeparatorHeight()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  
  private func configureView() {
    self.backgroundColor = Color.separator
    
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  // MARK: - Setup UI
  
  private func setupSeparatorHeight() {
    NSLayoutConstraint.activate([
      self.heightAnchor.constraint(equalToConstant: UI.Size.separatorHeight),
    ])
  }
  
}
