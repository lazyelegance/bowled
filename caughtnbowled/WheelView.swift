//
//  WheelView.swift
//  Bowled
//
//  Created by Ezra Bathini on 16/12/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class WheelView: UIView {

    @IBOutlet weak var wheel: View!
    
    @IBOutlet weak var ones: UILabel!
    @IBOutlet weak var twos: UILabel!
    @IBOutlet weak var threes: UILabel!
    @IBOutlet weak var fours: UILabel!
    @IBOutlet weak var fives: UILabel!
    @IBOutlet weak var sixes: UILabel!
    
    var battingWheel: BattingWheel? {
        didSet {
            if battingWheel != nil {
                //for now
//                ones.text = "90"
//                twos.text = "90"
//                threes.text = "90"
//                fours.text = "90"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
