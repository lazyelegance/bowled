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

    @IBOutlet weak var btn1: FlatButton!
    @IBOutlet weak var btn2: FlatButton!
    @IBOutlet weak var btn3: FlatButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code


        btn1.titleColor = txtColor
        btn2.titleColor = txtColor
        btn3.titleColor = txtColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
