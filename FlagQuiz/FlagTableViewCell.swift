//
//  FlagTableViewCell.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 5. 7..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit

class FlagTableViewCell: UITableViewCell {
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
