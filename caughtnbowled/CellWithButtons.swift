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
        btn1.backgroundColor = txtColor
        btn2.backgroundColor = txtColor
        btn3.backgroundColor = txtColor
        btn1.titleColor = mainColor
        btn2.titleColor = mainColor
        btn3.titleColor = mainColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
