//
//  CountryInfoTableViewCell.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 6. 16..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit

class CountryInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    @IBOutlet var flagImageViewHeight: NSLayoutConstraint!
    @IBOutlet var flagImageViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if ( UIDevice.current.userInterfaceIdiom == .phone ) {
            flagImageViewHeight.constant = 100
            flagImageViewWidth.constant = 150
        } else if ( UIDevice.current.userInterfaceIdiom == .pad ) {
            flagImageViewHeight.constant = 150
            flagImageViewWidth.constant = 300
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
