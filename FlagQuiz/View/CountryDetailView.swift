//
//  CountryDetailView.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/26.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit
import MapKit

class CountryDetailView: UIView {
  
  // MARK: - Properties
  
  let mapView: MKMapView = {
    let mapView = MKMapView()
    
    mapView.translatesAutoresizingMaskIntoConstraints = false
    
    return mapView
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView()
    addAllSubviews()
    setUpAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Configuration
  
  private func configureView() {
    self.backgroundColor = Color.tertiarySystemGroupedBackground
  }
  
  private func addAllSubviews() {
    self.addSubview(mapView)
  }
  
  private func setUpAutoLayout() {
    let safeArea = self.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
    ])
  }
  
}
