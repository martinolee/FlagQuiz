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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentFlagInfo:Array<FlagInfo> = flagInfo
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = UISearchController(searchResultsController: searchController)
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }

        searchBar.placeholder = "Search Flag by Country Name"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView = segue.destination as? DetailCountryViewController
        let indexPath = countryTableView.indexPathForSelectedRow
        let currentCell = countryTableView.cellForRow(at: indexPath!) as! CountryInfoTableViewCell
        let imageName = currentCell.flagImageNameLabel.text
        print(currentCell.flagImageView.description)
        
        detailView?.imageName = imageName
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
        cell.flagImageNameLabel.text = target.fullName
        
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




















