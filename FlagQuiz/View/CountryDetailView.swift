//
//  CountryDetailView.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/26.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class CountryDetailView: UIView {
  
  // MARK: - Properties
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  
  private func configureView() {
    self.backgroundColor = Color.tertiarySystemGroupedBackground
  }
  
}
