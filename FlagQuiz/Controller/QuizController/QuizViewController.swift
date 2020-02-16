//
//  QuizViewController.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/20.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
  
  private func checkIsDuplicated(_ newCountry: Int, with previousCountries: [Int]) -> Bool {
    for previousCountry in previousCountries {
      if previousCountry == newCountry { return true }
    }
    
    return false
  }
  
  func checkIsCorrect(answerLocation: ButtonLocation, for viewController: QuizViewController.Type) -> Bool {
    var isCorrect: Bool!
    
    if viewController == FlagQuizViewController.self {
      guard let question = Singleton.shared.flagQuiz.questionList.last else { return false }
      
      isCorrect = question.correctAnswerLocation == answerLocation
    } else if viewController == NameQuizViewController.self {
      guard let question = Singleton.shared.nameQuiz.questionList.last else { return false }
      
      isCorrect = question.correctAnswerLocation == answerLocation
    }
    
    return isCorrect
  }
  
  private func makeAnswers(for viewController: QuizViewController.Type) -> [Int] {
    var answers = [Int]()
    var score: Int!
    var questionList = [Question]()
    var previousAnswers = [Int]()
    var previousCorrectAnswers = [Int]()
    
    if viewController == FlagQuizViewController.self {
      score = Singleton.shared.flagQuiz.score
      
      questionList = Singleton.shared.flagQuiz.questionList
      
      if let previousQuestion = questionList.last {
        previousAnswers = previousQuestion.answers
      }
    } else if viewController == NameQuizViewController.self {
      score = Singleton.shared.nameQuiz.score
      
      questionList = Singleton.shared.nameQuiz.questionList
      
      if let previousQuestion = questionList.last {
        previousAnswers = previousQuestion.answers
      }
    }
    
    for question in questionList {
      switch question.correctAnswerLocation {
      case .leftTop    : previousCorrectAnswers.append(question.answers[ButtonLocation.leftTop.key])
      case .rightTop   : previousCorrectAnswers.append(question.answers[ButtonLocation.rightTop.key])
      case .leftBottom : previousCorrectAnswers.append(question.answers[ButtonLocation.leftBottom.key])
      case .rightBottom: previousCorrectAnswers.append(question.answers[ButtonLocation.rightBottom.key])
      }
    }
    
    let maximumSelecting = Singleton.shared.quizDifficulty.getMaximumSelectingCountryCount(by: score)
    
    func selectCountry() -> Int { Int.random(in: 0...maximumSelecting) }
    
    for _ in 0...3 {
      var selectedCountry: Int
      
      var isDuplicatedWithOtherAnswersInCurrentQuestion: Bool
      var isDuplicatedWithPreviousAnswers: Bool
      var isDuplicatedWithPreviousCorrectAnswers: Bool
      
      repeat {
        repeat {
          repeat {
            selectedCountry = selectCountry()
            
            isDuplicatedWithPreviousCorrectAnswers = checkIsDuplicated(selectedCountry, with: previousCorrectAnswers)
          } while isDuplicatedWithPreviousCorrectAnswers
          isDuplicatedWithPreviousAnswers = checkIsDuplicated(selectedCountry, with: previousAnswers)
        } while isDuplicatedWithPreviousAnswers
        isDuplicatedWithOtherAnswersInCurrentQuestion = checkIsDuplicated(selectedCountry, with: answers)
      } while isDuplicatedWithOtherAnswersInCurrentQuestion
      
      answers.append(selectedCountry)
    }
    
    return answers
  }
  
  func makeQuestion(for viewController: QuizViewController.Type) {
    let answers = makeAnswers(for: viewController)
    let answerLocation = makeCorrectAnswerButtonLocation()
    let question = Question(answers: answers, correctAnswerLocation: answerLocation)
    
    if viewController == FlagQuizViewController.self {
      Singleton.shared.flagQuiz.questionList.append(question)
    } else if viewController == NameQuizViewController.self {
      Singleton.shared.nameQuiz.questionList.append(question)
    }
  }
  
  private func makeCorrectAnswerButtonLocation() -> ButtonLocation {
    var correctAnswerButtonLocation: ButtonLocation!
    let randomCorrectAnswerButtonLocation = Int.random(in: 0...3)
    
    if randomCorrectAnswerButtonLocation == 0 {
      correctAnswerButtonLocation = .leftTop
    } else if randomCorrectAnswerButtonLocation == 1 {
      correctAnswerButtonLocation = .rightTop
    } else if randomCorrectAnswerButtonLocation == 2 {
      correctAnswerButtonLocation = .leftBottom
    } else if randomCorrectAnswerButtonLocation == 3 {
      correctAnswerButtonLocation = .rightBottom
    }
    
    return correctAnswerButtonLocation
  }
  
}
