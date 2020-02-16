//
//  CountryDetailViewController.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/26.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class CountryDetailViewController: UIViewController {
  
  // MARK: - Properties
  
  let countryDetialView = CountryDetailView()
  
  var country: Country?
  
  // MARK: - Life Cycle
  
  override func loadView() {
    view = countryDetialView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavigationController()
  }
  
  // MARK: - Initialization
  
  private func configureNavigationController() {
    guard let country = country else { return }
    
    self.title = country.name
    self.navigationItem.hidesSearchBarWhenScrolling = false
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }

}
