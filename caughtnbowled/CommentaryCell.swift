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
                
                
                deliveryNumber.textColor = txtColor
                commentLabel.textColor = txtColor
                
                deliveryNumber.font = RobotoFont.medium(with: 15)
                commentLabel.font = RobotoFont.regular(with: 15)
                resultLabel.font = RobotoFont.medium
                
                self.contentView.backgroundColor = mainColor
                
                deliverNumberWidth.constant = 40
                resultWidth.constant = 40
                
                resultLabel.backgroundColor = mainColor
                resultLabel.textColor = txtColor
                resultLabel.layer.masksToBounds = true
                resultLabel.layer.cornerRadius = 5
                resultLabel.layer.borderWidth = 1
                
                
                if comment?.result == "W" {
                    resultLabel.textColor = UIColor.red
                } else if comment?.result == "6" || comment?.result == "4" {
                    resultLabel.textColor = UIColor.green
                }
                
                resultLabel.layer.borderColor = resultLabel.textColor.cgColor
                
                if comment?.ballType == "NonBallComment" {
                    commentLabel.font = RobotoFont.bold
                    deliverNumberWidth.constant = 0
                    resultWidth.constant = 0
                    self.contentView.backgroundColor = mainColor
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
