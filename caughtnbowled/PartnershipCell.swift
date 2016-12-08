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


    @IBOutlet weak var totalRuns: UILabel!
    
    @IBOutlet weak var fbRunsScored: UILabel!
    @IBOutlet weak var fbBallsFaced: UILabel!
    @IBOutlet weak var fbName: UILabel!
    
    @IBOutlet weak var fbViewWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var fbAspectRatio: NSLayoutConstraint!
    
    
    @IBOutlet weak var sbRunsScored: UILabel!
    @IBOutlet weak var sbBallsFaced: UILabel!
    @IBOutlet weak var sbName: UILabel!
    
    @IBOutlet weak var sbViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var sbAspectRatio: NSLayoutConstraint!
    
    
    var partnership: Partnership? {
        didSet {
            if partnership != nil {
                totalRuns.text = "\(partnership!.totalRuns)"
                totalRuns.textColor = secondaryColor
                totalRuns.font = RobotoFont.bold(with: 35)
                
                fbName.text = partnership?.firstBatsman.name
                fbRunsScored.text = partnership?.firstBatsman.runsScored
                fbBallsFaced.text = "( " + (partnership?.firstBatsman.ballsFaced)! + " )"
                
                sbName.text = partnership?.secondBatsman.name
                sbRunsScored.text = partnership?.secondBatsman.runsScored
                sbBallsFaced.text = "( " + (partnership?.secondBatsman.ballsFaced)! + " )"
                
                self.contentView.backgroundColor = mainColor
                
                fbName.textColor = secondaryColor
                fbBallsFaced.textColor = secondaryColor
                fbRunsScored.textColor = secondaryColor
                
                sbName.textColor = secondaryColor
                sbBallsFaced.textColor = secondaryColor
                sbRunsScored.textColor = secondaryColor
                
                fbName.font = RobotoFont.medium(with: 15)
                fbRunsScored.font = RobotoFont.bold(with: 15)
                fbBallsFaced.font = RobotoFont.regular(with: 15)
                
                sbName.font = RobotoFont.medium(with: 15)
                sbRunsScored.font = RobotoFont.bold(with: 15)
                sbBallsFaced.font = RobotoFont.regular(with: 15)

                fbViewWidth.constant = (self.frame.size.width / 4) * CGFloat((partnership?.firstBatsmanContrib)!)
                sbViewWidth.constant = (self.frame.size.width / 4) * CGFloat((partnership?.secondBatsmanContrib)!)
                
                print(fbViewWidth.constant)
                
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
