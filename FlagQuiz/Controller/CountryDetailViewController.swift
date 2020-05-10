//
//  CountryDetailViewController.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/26.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit
import MapKit

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
    guard let country = country else { return }
    
    configureNavigationController()
    move(to: country.name)
  }
  
  // MARK: - Initialization
  
  private func configureNavigationController() {
    guard let country = country else { return }
    
    self.title = country.name
    self.navigationItem.hidesSearchBarWhenScrolling = false
    self.navigationController?.navigationBar.prefersLargeTitles = false
    self.navigationController?.navigationBar.barTintColor = Color.tertiarySystemGroupedBackground
  }
  
  private func move(to country: String) {
    getCoordinateFrom(address: country) { [weak self] coordinate in
      guard let self = self else { return }
      
      self.countryDetialView.mapView.setCenter(coordinate, animated: false)
    }
  }
  
  private func getCoordinateFrom(address: String, complation: @escaping (CLLocationCoordinate2D) -> ()) {
    let geoCoder = CLGeocoder()
    
    geoCoder.geocodeAddressString(address) { (placemarks, error) in
      if error != nil {
        return print(error!.localizedDescription)
      }
      
      guard
        let placemarks = placemarks,
        let location = placemarks.first?.location
        else { return }
      
      complation(location.coordinate)
    }
  }
  
}
