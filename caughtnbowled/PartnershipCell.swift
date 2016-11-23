//
//  PartnershipCell.swift
//  Bowled
//
//  Created by Ezra Bathini on 24/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import  Material
class PartnershipCell: UITableViewCell {


    
    @IBOutlet weak var fbRunsScored: UILabel!
    @IBOutlet weak var fbBallsFaced: UILabel!
    @IBOutlet weak var fbName: UILabel!
    
    @IBOutlet weak var sbRunsScored: UILabel!
    @IBOutlet weak var sbBallsFaced: UILabel!
    @IBOutlet weak var sbName: UILabel!
    
    var partnership: Partnership? {
        didSet {
            if partnership != nil {
                fbName.text = partnership?.firstBatsman.name
                fbRunsScored.text = partnership?.firstBatsman.runsScored
                fbBallsFaced.text = partnership?.firstBatsman.ballsFaced
                
                sbName.text = partnership?.secondBatsman.name
                sbRunsScored.text = partnership?.secondBatsman.runsScored
                sbBallsFaced.text = partnership?.secondBatsman.ballsFaced
                
                self.contentView.backgroundColor = mainColor
                
                fbName.textColor = Color.white
                fbBallsFaced.textColor = Color.white
                fbRunsScored.textColor = Color.white
                
                sbName.textColor = Color.white
                sbBallsFaced.textColor = Color.white
                sbRunsScored.textColor = Color.white
                
                fbName.font = RobotoFont.medium(with: 15)
                fbRunsScored.font = RobotoFont.regular(with: 15)
                fbBallsFaced.font = RobotoFont.regular(with: 15)
                
                sbName.font = RobotoFont.medium(with: 15)
                sbRunsScored.font = RobotoFont.regular(with: 15)
                sbBallsFaced.font = RobotoFont.regular(with: 15)
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
