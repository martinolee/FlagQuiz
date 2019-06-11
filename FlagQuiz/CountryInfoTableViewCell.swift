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
    
    @IBOutlet var flagImageViewHeight: NSLayoutConstraint!
    @IBOutlet var flagImageViewWidth: NSLayoutConstraint!
    
    @IBOutlet var flagImageViewLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var countryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if ( UIDevice.current.userInterfaceIdiom == .phone ) {
            flagImageViewHeight.constant = 100
            flagImageViewWidth.constant = 150
            
            countryNameLabel.font = countryNameLabel.font.withSize(17)
        } else if ( UIDevice.current.userInterfaceIdiom == .pad ) {
            flagImageViewHeight.constant = 200
            flagImageViewWidth.constant = 300
            
            flagImageViewLeftConstraint.constant = 50
            
            countryNameLabel.font = countryNameLabel.font.withSize(34)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
