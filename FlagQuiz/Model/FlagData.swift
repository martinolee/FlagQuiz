//
//  FlagData.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/21.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import Foundation

struct Country: Hashable {
  let name: String
  let flagImageName: String
  let gdp: Double
  let area: Double
  let population: Double
  let difficulty: Double
}

enum ButtonLocation {
  case leftTop, rightTop, leftBottom, rightBottom
  
  var key: Int {
    get {
      switch self {
      case .leftTop    : return 0
      case .rightTop   : return 1
      case .leftBottom : return 2
      case .rightBottom: return 3
      }
    }
  }
}

enum QuizDifficulty {
  case easy, medium, hard
  
  struct CountrySelectingRange {
    let defaultRange: Int
    let increasingRange: Int
  }
  
  func getMaximumSelectingCountryCount(by score: Int) -> Int {
    let easyCountrySelectingRange = CountrySelectingRange(defaultRange: 30, increasingRange: 20)
    let mediumCountrySelectingRange = CountrySelectingRange(defaultRange: 40, increasingRange: 30)
    let hardCountrySelectingRange = CountrySelectingRange(defaultRange: 50, increasingRange: 40)
    let difficultyLevel = score / 10
    
    var maximumSelectingCountryCount: Int!
    
    switch self {
    case .easy:
      maximumSelectingCountryCount = easyCountrySelectingRange.defaultRange + easyCountrySelectingRange.increasingRange * difficultyLevel
    case .medium:
      maximumSelectingCountryCount = mediumCountrySelectingRange.defaultRange + mediumCountrySelectingRange.increasingRange * score / 10
    case .hard:
      maximumSelectingCountryCount = hardCountrySelectingRange.defaultRange + hardCountrySelectingRange.increasingRange * score / 10
    }
    
    if maximumSelectingCountryCount >= Singleton.shared.countryInfo.count {
      return Singleton.shared.countryInfo.count - 1
    }
    
    return maximumSelectingCountryCount
  }
}

struct Quiz {
  var questionList: [Question] {
    didSet {
      let maximumQuestionCount = 20
      
      if questionList.count > maximumQuestionCount {
        questionList.removeFirst()
      }
    }
  }
  
  var correctedAnswers: [Int]
  
  var life: Int
  var score: Int
  
  private let maximumLife = 5
  
  init() {
    self.questionList = []
    self.correctedAnswers = []
    self.score = 0
    self.life = maximumLife
  }
  
  mutating func initQuiz() {
    questionList.removeAll()
    correctedAnswers.removeAll()
    initLife()
    initScore()
  }
  
  private mutating func initLife() { life = maximumLife }
  
  private mutating func initScore(){ score = 0 }
}

struct Question {
  let answers: [Int]
  let correctAnswerLocation: ButtonLocation
}

enum QuizType {
  case flag, name
  
  var key: Int {
    get {
      switch self {
      case .flag: return 0
      case .name: return 1
      }
    }
  }
}
