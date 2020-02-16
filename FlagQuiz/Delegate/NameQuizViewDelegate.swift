//
//  NameQuizViewDelegate.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/24.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import Foundation

protocol NameQuizViewDelegate {
  func button(_ button: AnswerButton, didTouchUpInsideAt location: ButtonLocation)
}
