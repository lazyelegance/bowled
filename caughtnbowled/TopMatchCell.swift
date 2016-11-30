//
//  TopMatchCell.swift
//  Bowled
//
//  Created by Ezra Bathini on 18/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class TopMatchCell: UITableViewCell {
    
    
    @IBOutlet weak var pulseView: PulseView!
    @IBOutlet weak var series: UILabel!
    @IBOutlet weak var matchStatus: UILabel!
    

    @IBOutlet weak var teamOneName: UILabel!
    @IBOutlet weak var teamOneScore: UILabel!
    
    
    @IBOutlet weak var teamTwoName: UILabel!
    @IBOutlet weak var teamTwoScore: UILabel!
    
    var match: Match? {
        didSet {
            if match != nil {
                teamOneName.text = match?.hometeamName
                teamOneName.textColor = mainColor
                teamOneName.font = RobotoFont.bold
                
                
            
        
                teamOneScore.text = match?.homeScore
                teamOneScore.textColor = mainColor
                teamOneScore.font = RobotoFont.light
                
                teamTwoName.text = match?.awayteamName
                teamTwoName.textColor = mainColor
                teamTwoName.font = RobotoFont.bold
                
                teamTwoScore.text = match?.awayScore
                teamTwoScore.textColor = mainColor
                teamTwoScore.font = RobotoFont.light
                
                series.text = match?.seriesName.uppercased()
                matchStatus.text = match?.status == .upcoming ? match?.relStartDate.uppercased() : match?.matchSummaryText.uppercased()
                
                series.font = RobotoFont.light(with: 10)
                series.textColor = mainColor
                matchStatus.font = RobotoFont.light(with: 10)
                matchStatus.textColor = mainColor
                
                self.backgroundColor = Color.clear
                self.contentView.backgroundColor = mainColor
                pulseView.backgroundColor = secondaryColor
                
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
