//
//  PlayerProfileController.swift
//  Bowled
//
//  Created by Ezra Bathini on 14/12/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class PlayerProfileController: UIViewController {

    @IBOutlet weak var playerImage: AsyncImageView!
    
    var player: Player?

    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerBattingStyle: UILabel!
    @IBOutlet weak var playerBowlingStyle: UILabel!

    @IBOutlet weak var playerDidYouKnow: UITextView!

    @IBOutlet weak var playerBio: UITextView!
    
    @IBOutlet weak var menuPlaceHolder: UIView!
    
    var mainMenu: HMSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = mainColor
        
        //TEST
        
        
        playerImage.imageURL = player?.imageURL
        playerImage.backgroundColor = txtColor
        playerImage.layer.borderColor = txtColor.cgColor
        playerImage.layer.borderWidth = 3
        playerImage.layer.cornerRadius = 5
        
        
        
        playerName.text = player?.fullName
        playerBattingStyle.text = player?.battingStyle
        playerBowlingStyle.text = player?.bowlingStyle
        
        playerBio.isScrollEnabled = false
        playerBio.text = player?.bio
        playerBio.textColor = txtColor
        
        if player?.didYouKnow != nil {
            playerBio.text = playerBio.text + (player?.didYouKnow)! + "\n"
        }
        
        if player?.dateOfBirth != nil {
           
            playerBio.text = playerBio.text + "\nBorn: \((player?.dateOfBirth)!)".uppercased()
            
        }
        if player?.testDebutDate != nil {
            
            playerBio.text = playerBio.text + "\nTest Debut: \((player?.testDebutDate)!)".uppercased()
            
        }
        if player?.odiDebutDate != nil {
            playerBio.text = playerBio.text + "\nODI Debut: \((player?.odiDebutDate)!)".uppercased()
        }
        if player?.t20DebutDate != nil {
            playerBio.text = playerBio.text + "\nT20I Debut: \((player?.t20DebutDate)!)".uppercased()
        }
        
        let menuTitles = ["BIO"]
        mainMenu = HMSegmentedControl(sectionTitles: menuTitles)
        mainMenu.addTarget(self, action: #selector(mainMenuChangedValue(_:)), for: .valueChanged)
        mainMenu.frame = CGRect(x: 10, y: 0, width: menuPlaceHolder.frame.width - 20, height: menuPlaceHolder.frame.height)
        mainMenu.autoresizingMask =  UIViewAutoresizing()
        
        mainMenu.selectionIndicatorColor = txtColor
        mainMenu.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic
        mainMenu.layer.cornerRadius = 2
        
        
        mainMenu.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe
        mainMenu.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        
        mainMenu.backgroundColor = Color.clear
        
        mainMenu.titleTextAttributes = [NSAttributedStringKey.foregroundColor: txtColor, NSAttributedStringKey.font: RobotoFont.regular]
        mainMenu.selectedTitleTextAttributes = [NSAttributedStringKey.foregroundColor: txtColor, NSAttributedStringKey.font: RobotoFont.regular]
        mainMenu.selectedSegmentIndex = 0
        
        menuPlaceHolder.backgroundColor = Color.clear
        
        menuPlaceHolder.addSubview(mainMenu)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        playerBio.isScrollEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    @IBAction func backToMatchDetail(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func mainMenuChangedValue(_ mainMenu: HMSegmentedControl) {
        //DO SOMETHING
    }
}
