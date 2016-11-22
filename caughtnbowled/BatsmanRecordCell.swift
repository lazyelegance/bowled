//
//  BatsmanRecordCell.swift
//  Bowled
//
//  Created by Ezra Bathini on 21/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class BatsmanRecordCell: UITableViewCell {
    
    

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var runsScored: UILabel!
    @IBOutlet weak var ballsFaced: UILabel!
    @IBOutlet weak var fours: UILabel!
    @IBOutlet weak var sixes: UILabel!
    @IBOutlet weak var strikeRate: UILabel!
    
    @IBOutlet weak var howOut: UILabel!
    
    var batsman: Batsman? {
        didSet {
            
            if batsman != nil {
                name.text = batsman?.name
                runsScored.text = batsman?.runsScored
                ballsFaced.text = batsman?.ballsFaced
                fours.text = batsman?.foursHit
                sixes.text = batsman?.sixesHit
                strikeRate.text = batsman?.strikeRate
                howOut.text = batsman?.howOut
                
                
                name.textColor = Color.white
                runsScored.textColor = Color.white
                ballsFaced.textColor = Color.white
                fours.textColor = Color.white
                sixes.textColor = Color.white
                strikeRate.textColor = Color.white
                howOut.textColor = Color.white
                
                
                name.font = RobotoFont.bold(with: 18)
                runsScored.font = RobotoFont.bold(with: 15)
                strikeRate.font = RobotoFont.medium(with: 15)
                ballsFaced.font = RobotoFont.medium(with: 15)
                fours.font = RobotoFont.medium(with: 15)
                sixes.font = RobotoFont.medium(with: 15)
                howOut.font = RobotoFont.light(with: 15)
                
                
                
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
