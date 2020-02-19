//
//  QuizTabBarController.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/24.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class QuizTabBarController: UITabBarController {
  
  // MARK: - Properties
  
  let flagQuizViewController: QuizViewController = {
    let viewController = FlagQuizViewController()
    
    viewController.tabBarItem.title = "Flag Quiz"
    viewController.tabBarItem.image = UIImage(named: "quizIcon_28")
    
    return viewController
  }()
  
  let nameQuizViewController: QuizViewController = {
    let viewController = NameQuizViewController()
    
    viewController.tabBarItem.title = "Name Quiz"
    viewController.tabBarItem.image = UIImage(named: "quizIcon_28")
    
    return viewController
  }()
  
  let flagInfoViewController: UINavigationController = {
    let navigationController = UINavigationController(rootViewController: CountryInfoViewController())
    
    navigationController.viewControllers.first?.tabBarItem.title = "Search"
    navigationController.viewControllers.first?.tabBarItem.image = UIImage(named: "flagListIcon_28")
    
    return navigationController
  }()
  
  let animation = Animation()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTabBar()
    setAnimation()
  }
  
  // MARK: - Configuration
  
  private func configureTabBar() {
    viewControllers = [flagQuizViewController, nameQuizViewController, flagInfoViewController]
  }
  
  private func setAnimation() {
    self.delegate = animation
  }
  
}
