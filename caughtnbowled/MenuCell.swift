//
//  MenuCell.swift
//  Bowled
//
//  Created by Ezra Bathini on 8/12/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class MenuCell: UITableViewCell {

    @IBOutlet weak var menuLabel: UILabel!
    
    var menuItem: String? {
        didSet {
            if menuItem != nil {
                menuLabel.text = menuItem
                menuLabel.textColor = secondaryColor
                menuLabel.font = RobotoFont.medium
                self.contentView.backgroundColor = Color.clear
                self.backgroundColor = Color.clear
                self.selectionStyle = .none
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
