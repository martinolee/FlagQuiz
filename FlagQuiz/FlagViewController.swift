//
//  FlagViewController.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 5. 7..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit

class FlagViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

extension FlagViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flagCell") as! FlagTableViewCell
        let target = flagInfo[indexPath.row]
        
        cell.flagImage.image = UIImage(named: target.imageName)
        cell.countryNameLabel.text = target.name
        
        return cell
    }
    
    
}
