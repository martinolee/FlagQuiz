//
//  CountryInfoView.swift
//  FlagQuiz
//
//  Created by Soohan Lee on 2020/01/22.
//  Copyright © 2020 Soohan Lee. All rights reserved.
//

import UIKit

class CountryInfoView: UIView {
  
  // MARK: - Properties
  
  var delegate: CountryInfoViewDelegate?
  
  private lazy var countryInfoTableView: UITableView = {
    let tableView = UITableView()
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    tableView.register(FlagInfoTableViewCell.self, forCellReuseIdentifier: FlagInfoTableViewCell.identifier)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.backgroundColor = Color.tertiarySystemGroupedBackground
    
    return tableView
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addAllView()
    setupFlagInfoTableViewAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup UI
  
  private func addAllView() {
    self.addSubview(countryInfoTableView)
  }
  
  private func setupFlagInfoTableViewAutoLayout() {
    NSLayoutConstraint.activate([
      countryInfoTableView.topAnchor     .constraint(equalTo: self.topAnchor),
      countryInfoTableView.leadingAnchor .constraint(equalTo: self.leadingAnchor),
      countryInfoTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      countryInfoTableView.bottomAnchor  .constraint(equalTo: self.bottomAnchor),
    ])
  }
  
  // MARK: - Element Control
  
  func reloadCountryInfoTableViewData() {
    countryInfoTableView.reloadData()
  }
}

extension CountryInfoView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    delegate?.tableView(tableView, numberOfRowsInSection: section) ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    delegate?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
  }
}

extension CountryInfoView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.tableView(tableView, didSelectRowAt: indexPath)
  }
}

