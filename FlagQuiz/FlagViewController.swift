//
//  FlagViewController.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 5. 7..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit

class FlagViewController: UIViewController {
    @IBOutlet weak var searchFlagField: UITextField!
    @IBOutlet weak var searchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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

extension FlagViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flagCell") as! FlagTableViewCell
        cell.selectionStyle = .none
        let target = flagInfo[indexPath.row]
        
        cell.flagImage.image = UIImage(named: target.imageName)
        cell.countryNameLabel.text = target.name
        
        return cell
    }

}

extension FlagViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.1) {
            self.searchLabel.alpha = (self.searchFlagField.text ?? "").count > 0 ? 0.0 : 1.0
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.1) {
            self.searchLabel.alpha = (self.searchFlagField.text ?? "").count > 0 ? 0.0 : 1.0
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var finalText = searchFlagField.text ?? ""
        
        if string.count == 0 {
            finalText = String(finalText[..<finalText.index(before: finalText.endIndex)])
        } else {
            finalText = finalText.appending(string)
        }
        
        UIView.animate(withDuration: 0.1) {
            if finalText.count == 0 {
                self.searchLabel.alpha = 1.0
            } else {
                self.searchLabel.alpha = 0.0
            }
            
            self.view.layoutIfNeeded()
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
























