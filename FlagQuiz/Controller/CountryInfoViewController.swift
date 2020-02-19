//
//  CountryInfoViewController.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/22.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class CountryInfoViewController: UIViewController, CountryInfoViewDelegate {
  
  // MARK: - Properties
  
  private let countryInfoView = CountryInfoView()
  private let countrySearchController = UISearchController()
  private var shownCountryList = Singleton.shared.countryInfo.sorted(by: { $0.name < $1.name })
  
  // MARK: - Life Cycle
  
  override func loadView() {
    super.loadView()
    
    countryInfoView.delegate = self
    
    view = countryInfoView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureCountrySearchController()
    configureNavigationController()
  }
  
  // MARK: - Configuration
  
  private func configureCountrySearchController() {
    countrySearchController.searchBar.delegate = self
    countrySearchController.obscuresBackgroundDuringPresentation = false
    countrySearchController.searchBar.autocapitalizationType = .none
  }
  
  private func configureNavigationController() {
    self.title = "Country"
    self.navigationItem.searchController = countrySearchController
    self.navigationItem.hidesSearchBarWhenScrolling = false
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  // MARK: - Function
  
  private func initShownCountryList() {
    shownCountryList = Singleton.shared.countryInfo.sorted(by: { $0.name < $1.name })
    countryInfoView.reloadCountryInfoTableViewData()
  }
  
}

// MARK: - Table View Data Source

extension CountryInfoViewController {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    shownCountryList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FlagInfoTableViewCell.identifier, for: indexPath) as! FlagInfoTableViewCell
    let country = shownCountryList[indexPath.row]
    let localizedCountryName = NSLocalizedString(country.name, comment: "Country Name")
    guard let flagImage = UIImage(named: country.flagImageName) else { return cell }
    
    cell.set(flagImage: flagImage, countryName: localizedCountryName)
    
    return cell
  }
  
}

// MARK: - Table View Delegate

extension CountryInfoViewController {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let countryDetailViewController = CountryDetailViewController()
    
    let country = shownCountryList[indexPath.row]
    
    countryDetailViewController.country = country
    
    navigationController?.pushViewController(countryDetailViewController, animated: true)
  }
}

// MARK: - Search Bar Delegate

extension CountryInfoViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard !searchText.isEmpty else {
        initShownCountryList()
        return
    }
    
    let searchingCountryList = searchBar.text!.split(separator: ",")
    
    var tempShownCountryList = [Country]()
    let countries = Singleton.shared.countryInfo
    
    shownCountryList.removeAll()
    for i in 0..<searchingCountryList.count {
        let countryName = searchingCountryList[i].trimmingCharacters(in: .whitespaces).lowercased()
        
        tempShownCountryList = countries.filter { $0.name.lowercased().contains(countryName) }
        
        if !tempShownCountryList.isEmpty {
            for j in 0..<tempShownCountryList.count {
                shownCountryList.append(tempShownCountryList[j])
            }
        }
    }
    
    let sortOrderList = shownCountryList
    
    shownCountryList = Array(Set(shownCountryList))
    shownCountryList = Array(NSOrderedSet(array: sortOrderList)) as! [Country]
    
    countryInfoView.reloadCountryInfoTableViewData()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    initShownCountryList()
  }
}
