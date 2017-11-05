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
                
                teamOneName.textColor = txtColor
                teamOneName.font = RobotoFont.bold
                
                
                teamTwoName.textColor = txtColor
                teamTwoName.font = RobotoFont.bold
                
                teamOneName.text = match?.hometeamName
                teamTwoName.text = match?.awayteamName
                
                if match?.status == .live || match?.status == .completed {
                    
                    if match?.hometeamIsBatting == true {
                        teamOneName.text = match?.hometeamName
                        teamOneScore.text = match?.homeScore
                        teamTwoName.text = match?.awayteamName
                        teamTwoScore.text = match?.awayScore == "0/0 (0)" ? " " : match?.awayScore
                    } else {
                        teamOneName.text = match?.awayteamName
                        teamOneScore.text = match?.awayScore
                        teamTwoName.text = match?.hometeamName
                        teamTwoScore.text = match?.homeScore == "0/0 (0)" ? " " : match?.homeScore
                    }
                    teamTwoScore.textColor = txtColor
                    teamTwoScore.font = RobotoFont.light
                    teamOneScore.textColor = txtColor
                    teamOneScore.font = RobotoFont.light
                }
                
                series.text = (match?.seriesName.uppercased())! + " | " + (match?.matchName.uppercased())!
                matchStatus.text = match?.status == .upcoming ? match?.relStartDate.uppercased() : match?.matchSummaryText.uppercased()
                
                series.font = RobotoFont.light(with: 10)
                series.textColor = txtColor
                matchStatus.font = RobotoFont.light(with: 10)
                matchStatus.textColor = txtColor
                
                if match?.status == .upcoming {
                    matchStatus.font = RobotoFont.medium(with: 10)
                    matchStatus.textColor = txtColor
                }
                
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
