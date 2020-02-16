//
//  CountryInfoViewDelegate.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/22.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

protocol CountryInfoViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}
