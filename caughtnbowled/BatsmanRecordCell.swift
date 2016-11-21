//
//  BatsmanRecordCell.swift
//  Bowled
//
//  Created by Ezra Bathini on 21/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit

class BatsmanRecordCell: UITableViewCell {
    
    

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var runsScored: UILabel!
    @IBOutlet weak var ballsFaced: UILabel!
    @IBOutlet weak var fours: UILabel!
    @IBOutlet weak var sixes: UILabel!
    @IBOutlet weak var strikeRate: UILabel!
    
    @IBOutlet weak var howOut: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
