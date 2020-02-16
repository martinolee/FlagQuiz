//
//  Color.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/20.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

enum Color {
  static var systemRed: UIColor {
    if #available(iOS 13, *) {
      return .systemRed
    }
    return UIColor(red: 255 / 255, green: 59 / 255, blue: 48 / 255, alpha: 1.0)
  }
  
  static var systemBlue: UIColor {
    if #available(iOS 13, *) {
      return .systemBlue
    }
    return UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1.0)
  }
  
  static var label: UIColor {
    if #available(iOS 13, *) {
        return .label
    }
    return UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1.0)
  }
  
  static var separator: UIColor {
    if #available(iOS 13, *) {
      return .separator
    }
    return UIColor(red: 60 / 255, green: 60 / 255, blue: 67 / 255, alpha: 0.29)
  }
  
  static var tertiarySystemGroupedBackground: UIColor {
    if #available(iOS 13, *) {
      return .tertiarySystemGroupedBackground
    }
    return UIColor(red: 244 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
  }
  
  static var systemBackground: UIColor {
    if #available(iOS 13, *) {
      return .systemBackground
    }
    return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
  }
  
  static var dim: UIColor {
    UIColor(white: 0.0, alpha: 0.3)
  }
  
  static var white: UIColor {
    .white
  }
  
}
