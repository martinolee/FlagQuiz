//
//  UI.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/24.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class UI {
  
  class Spacing {
    class Top {
      static let forFlagImageView: CGFloat = 52.0
      static let largeMargin: CGFloat = 32.0
      static let mediumMargin: CGFloat = 16.0
      static let smallMargin: CGFloat = 8.0
      static let forCorrectOrIncorrectView: CGFloat = 32
    }
    
    class Leading {
      static let toSafeArea: CGFloat = 8.0
      static let forFlagImageView: CGFloat = 32.0
    }
    
    class Trailing {
      static let toSafeArea: CGFloat = -8.0
      static let forFlagImageView: CGFloat = -32.0
    }
    
    class Bottom {
      static let forFlagImageView: CGFloat = -38.0
    }
  }
  
  class Size {
    class Width {
      
    }
    
    class Height {
      
    }
    
    static let quizStatusViewHeight: CGFloat = 50.0
    
    static let flagQuestionViewHeight: CGFloat = 150.0
    
    static let separatorHeight: CGFloat = 5.0
    
    static let bannerViewWidth: CGFloat = 320.0
    static let bannerViewHeight: CGFloat = 50.0
    
    static let popupViewWidth: CGFloat = 240.0
    static let popupViewHeight: CGFloat = 220.0
    
    static let correctOrIncorrectViewWidth: CGFloat = 120.0
    static let correctOrIncorrectViewHeight: CGFloat = 50.0
  }
  
  class CornerRadius {
    static let forCorrectOrIncorectView: CGFloat = 8.0
  }
  
}
