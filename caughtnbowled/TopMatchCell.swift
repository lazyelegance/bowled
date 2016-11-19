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
                teamOneScore.text = match?.homeScore
                
                teamTwoName.text = match?.awayteamName
                teamTwoScore.text = match?.awayScore
                
                series.text = match?.seriesName.uppercased()
                matchStatus.text = match?.matchSummaryText.uppercased()
                
                self.contentView.backgroundColor = Color.clear
                self.backgroundColor = Color.clear
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
