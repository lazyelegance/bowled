//
//  BowlerRecordCell.swift
//  Bowled
//
//  Created by Ezra Bathini on 21/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class BowlerRecordCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var overs: UILabel!
    @IBOutlet weak var maidens: UILabel!
    @IBOutlet weak var runsConceded: UILabel!
    @IBOutlet weak var wickets: UILabel!
    @IBOutlet weak var ecomony: UILabel!
    
    //    @IBOutlet weak var wides: UILabel!
    //    @IBOutlet weak var noBalls: UILabel!
    
    var bowler: Bowler? {
        didSet {
            if bowler != nil {
                name.text = bowler?.name
                overs.text = bowler?.overs
                maidens.text = bowler?.maidens
                wickets.text = bowler?.wickets
                runsConceded.text = bowler?.runsConceded
                ecomony.text = bowler?.ecomony
                

                
                name.textColor = txtColor
                overs.textColor = txtColor
                maidens.textColor = txtColor
                runsConceded.textColor = txtColor
                wickets.textColor = txtColor
                ecomony.textColor = txtColor
                
                
                
                name.font = RobotoFont.bold(with: 18)
                overs.font = RobotoFont.medium(with: 15)
                maidens.font = RobotoFont.medium(with: 15)
                runsConceded.font = RobotoFont.medium(with: 15)
                wickets.font = RobotoFont.bold(with: 15)
                ecomony.font = RobotoFont.medium(with: 15)
                
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
