//
//  Singleton.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/22.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import Foundation

final class Singleton {
  static let shared = Singleton()
  private init() { }
  
  var countryInfo = [Country]()
  
  var quizDifficulty: QuizDifficulty = .easy
  
  var flagQuiz = Quiz()
  var nameQuiz = Quiz()
}
