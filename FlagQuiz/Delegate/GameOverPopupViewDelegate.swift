//
//  GameOverPopupViewDelegate.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/30.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

protocol GameOverPopupViewDelegate {
  func whenContinueButtonDidTouchUpInside(_ button: UIButton)
  
  func whenRestartButtonDidTouchUpInside(_ button: UIButton)
}
