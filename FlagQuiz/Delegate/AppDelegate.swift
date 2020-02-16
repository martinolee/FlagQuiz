//
//  AppDelegate.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/20.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    
    initCountryInfo()
    
    setupRootViewController()
    
    return true
  }
  
  private func setupRootViewController() {
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let rootViewController = QuizTabBarController()
    
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
  }
  
  private func initCountryInfo() {
    let path = Bundle.main.path(forResource: "CountryList", ofType: "csv")
    let url = URL(fileURLWithPath: path!)
    let countryList = try! NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue)
    var lines = countryList.components(separatedBy: "\n")
    
    func removeHeadLine() { lines.remove(at: 0) }
    func removeLastLine() { lines.remove(at: lines.count - 1) }
    
    removeHeadLine()
    removeLastLine()
    
    for line in lines {
      let column = line.components(separatedBy: ",")
      let name = column[0]
      let flagImageName = column[1]
      let gdp = Double(column[3]) ?? -1.0
      let area = Double(column[4]) ?? -1.0
      let population = Double(column[5]) ?? -1.0
      let gdpPriority = 1.0
      let areaPriority = 0.2
      let populationPriority = 0.5
      let difficulty = gdp * gdpPriority + area * areaPriority + population * populationPriority
      
      Singleton.shared.countryInfo.append(
        Country(
          name: name,
          flagImageName: flagImageName,
          gdp: gdp,
          area: area,
          population: population,
          difficulty: difficulty
        )
      )
    }
    
    Singleton.shared.countryInfo.sort(by: { $0.difficulty > $1.difficulty })
  }
  
}

