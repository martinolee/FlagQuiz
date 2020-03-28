//
//  AnswerButton.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/22.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class AnswerButton: UIButton {
  
  // MARK: - Properties
  
  var location: ButtonLocation!
  
  // MARK: - Initialization
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureButton()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(location: ButtonLocation) {
    self.init()
    self.location = location
  }
  
  // MARK: - Configuration
  
  private func configureButton() {
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.adjustsImageWhenDisabled = true
    self.adjustsImageWhenHighlighted = true
    self.tintAdjustmentMode = .dimmed
    self.setTitleColor(Color.systemRed, for: .disabled)
    self.setTitleColor(Color.label,     for: .normal)
    self.contentMode = .scaleAspectFit
    self.imageView?.contentMode = .scaleAspectFit
    self.titleLabel?.textAlignment = .center
    self.titleLabel?.numberOfLines = 0
  }
  
}
