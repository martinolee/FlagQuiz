//
//  CountryInfoViewController.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 6. 16..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit

class CountryInfoViewController: UIViewController {
    @IBOutlet weak var countryTableView: UITableView!
    
    var currentFlagInfo:Array<FlagInfo> = flagInfo
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.searchController?.searchBar.delegate = self
            searchBar = self.navigationItem.searchController?.searchBar
        } else {
            // Fallback on earlier versions
        }

    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CountryInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFlagInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryInfoTableViewCell
        let target = currentFlagInfo[indexPath.row]
        
        cell.flagImageView.image = UIImage(named: target.imageName)
        cell.countryNameLabel.text = target.name
        cell.flagImageNameLabel.text = target.imageName
        
        return cell
    }
    
}

extension CountryInfoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            currentFlagInfo = flagInfo
            countryTableView.reloadData()
            return
        }
        
        currentFlagInfo = flagInfo.filter({ (flag:FlagInfo) -> Bool in
            flag.name.contains(searchBar.text!) || flag.fullName.contains(searchBar.text!)
        })
        countryTableView.reloadData()
    }
    
}




















