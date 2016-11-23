//
//  CommentaryCell.swift
//  Bowled
//
//  Created by Ezra Bathini on 23/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class CommentaryCell: UITableViewCell {
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var deliveryNumber: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var deliverNumberWidth: NSLayoutConstraint!
    
    @IBOutlet weak var resultWidth: NSLayoutConstraint!
    
    var comment: Comment? {
        didSet {
            if comment != nil {
                resultLabel.text = comment?.result
                deliveryNumber.text = comment?.deliveryNumRep
                commentLabel.text = comment?.text
                
                
                deliveryNumber.textColor = Color.white
                commentLabel.textColor = Color.white
                
                deliveryNumber.font = RobotoFont.medium(with: 15)
                commentLabel.font = RobotoFont.regular(with: 15)
                resultLabel.font = RobotoFont.bold(with: 15)
                
                self.contentView.backgroundColor = mainColor
                
                deliverNumberWidth.constant = 40
                resultWidth.constant = 40
                
                resultLabel.backgroundColor = Color.white
                resultLabel.textColor = mainColor
                resultLabel.layer.masksToBounds = true
                resultLabel.layer.cornerRadius = 5
                
                if comment?.result == "W" {
                    resultLabel.textColor = Color.red
                } else if comment?.result == "6" || comment?.result == "4" {
                    resultLabel.textColor = Color.green
                }
                
                if comment?.ballType == "NonBallComment" {
                    commentLabel.font = RobotoFont.bold(with: 15)
                    deliverNumberWidth.constant = 0
                    resultWidth.constant = 0
                    self.contentView.backgroundColor = Color.indigo.darken1
                }
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
