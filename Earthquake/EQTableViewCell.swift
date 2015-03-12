//
//  EQTableViewCell.swift
//  Earthquake
//
//  Created by Humberto Morales on 3/11/15.
//  Copyright (c) 2015 Humberto Morales. All rights reserved.
//

import UIKit

class EQTableViewCell: UITableViewCell {

    @IBOutlet weak var labelMag: UILabel!
    @IBOutlet weak var labelPlace: UILabel!
    @IBOutlet weak var imgPin: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
