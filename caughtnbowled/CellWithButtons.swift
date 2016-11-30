//
//  CellWithButtons.swift
//  Bowled
//
//  Created by Ezra Bathini on 30/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material


class CellWithButtons: UITableViewCell {

    @IBOutlet weak var btn1: RaisedButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
