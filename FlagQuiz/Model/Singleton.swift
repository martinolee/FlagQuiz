//
//  Singleton.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/22.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import Foundation
import GoogleMobileAds

final class Singleton {
  static let shared = Singleton()
  private init() { }
  
  var countryInfo = [Country]()
  
  var quizDifficulty: QuizDifficulty = .easy
  
  var flagQuiz = Quiz()
  var nameQuiz = Quiz()
  
  var flagRewardedAD: GADRewardedAd = {
    let ad = GADRewardedAd(adUnitID: AdvertisingIdentifier.flagRewardedADUnitId)      
    
    ad.load(GADRequest()) { error in
      if let error = error {
        print("Loading failed: \(error)")
      } else {
        print("Loading Succeeded")
      }
    }
    
    return ad
    }()
  
  var nameRewardedAD: GADRewardedAd = {
    let ad = GADRewardedAd(adUnitID: AdvertisingIdentifier.nameRewardedADUnitId)
    
    ad.load(GADRequest()) { error in
      if let error = error {
        print("Loading failed: \(error)")
      } else {
        print("Loading Succeeded")
      }
    }
    
    return ad
  }()
}

