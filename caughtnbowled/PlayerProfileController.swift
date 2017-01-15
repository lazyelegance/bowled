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
    
    //Player(id: 3788, fullName: "Virat Kohli (c)", firstName: "Virat", lastName: "Kohli", imageURL: http://www.cricket.com.au/-/media/Players/Men/International/India/Virat-Kohli-Test.ashx, battingStyle: "Right Hand", bowlingStyle: "Right Arm Medium", playerType: "Batter", dateOfBirth: "1988-11-04T13:00:00Z", testDebutDate: "2011-06-19T14:00:00Z", odiDebutDate: "2008-08-17T14:00:00Z", t20DebutDate: "2010-06-11T14:00:00Z", bio: "HEIR APPARENT TO CAPTAIN MS DHONI, VIRAT KOHLI&RSQUO;S AGGRESSIVE AND CONSISTENT BATTING HAS SEEN HIM REMAIN CLOSE TO THE TOP OF THE ONE-DAY INTERNATIONAL BATTING RANKINGS SINCE EARLY 2010.\nKOHLI ALWAYS DREAMED OF REPRESENTING HIS COUNTRY IN CRICKET AND HAD HIS FIRST OPPORTUNITY AS A TEENAGER WHEN HE PLAYED FOR THE INDIA UNDER-19 TEAM IN 2006, GUIDING THE SAME TEAM TO A WORLD CUP WIN IN 2008.\n HIS SENIOR INTERNATIONAL CAREER TOOK OFF SOON AFTER WHEN KOHLI MADE HIS ONE-DAY INTERNATIONAL DEBUT AGAINST SRI LANKA IN AUGUST 2008.\n THE 26-YEAR-OLD NOW HAS MORE THAN 20 ONE-DAY HUNDREDS AND MORE THAN 30 FIFTIES TO HIS NAME. HIS HIGH-SCORE OF 183 CAME AGAINST PAKISTAN IN 2012 AND HAD SCORED THREE CENTURIES FOR 2014 BY THE START OF NOVEMBER.\n HE PLAYED A CRUCIAL ROLE WHEN INDIA TOPPLED SRI LANKA IN THE ICC CRICKET WORLD CUP 2011 FINAL, ARRIVING AT THE CREASE WHEN INDIA WAS 2-31 AND STEADYING THE SHIP WITH A CALM 35. \n KOHLI WAS HANDED THE ONE-DAY CAPTAINCY FOR INDIA&RSQUO;S SERIES AGAINST SRI LANKA IN NOVEMBER 2014 WHEN MS DHONI WAS RESTED.", didYouKnow: "HAS BEEN NAMED ONE OF GQ MAGAZINE&RSQUO;S BEST DRESSED INTERNATIONAL MEN.", height: "175", teamName: "India Men", teamId: 3, teamShortName: "IND", teamLogoURL: http://www.cricket.com.au/-/media/Logos/Teams/International/India.ashx)
    
    
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
        
        var vKohli = Player(id: 3788, name: "Virat Kohli (c)")
        vKohli.battingStyle = "Right Hand"
        vKohli.bowlingStyle = "Right Arm Medium"
        vKohli.imageURL = URL(string: "http://www.cricket.com.au/-/media/Players/Men/International/India/Virat-Kohli-Test.ashx")!
        vKohli.bio = "HEIR APPARENT TO CAPTAIN MS DHONI, VIRAT KOHLI&RSQUO;S AGGRESSIVE AND CONSISTENT BATTING HAS SEEN HIM REMAIN CLOSE TO THE TOP OF THE ONE-DAY INTERNATIONAL BATTING RANKINGS SINCE EARLY 2010.\nKOHLI ALWAYS DREAMED OF REPRESENTING HIS COUNTRY IN CRICKET AND HAD HIS FIRST OPPORTUNITY AS A TEENAGER WHEN HE PLAYED FOR THE INDIA UNDER-19 TEAM IN 2006, GUIDING THE SAME TEAM TO A WORLD CUP WIN IN 2008.\n HIS SENIOR INTERNATIONAL CAREER TOOK OFF SOON AFTER WHEN KOHLI MADE HIS ONE-DAY INTERNATIONAL DEBUT AGAINST SRI LANKA IN AUGUST 2008.\n THE 26-YEAR-OLD NOW HAS MORE THAN 20 ONE-DAY HUNDREDS AND MORE THAN 30 FIFTIES TO HIS NAME. HIS HIGH-SCORE OF 183 CAME AGAINST PAKISTAN IN 2012 AND HAD SCORED THREE CENTURIES FOR 2014 BY THE START OF NOVEMBER.\n HE PLAYED A CRUCIAL ROLE WHEN INDIA TOPPLED SRI LANKA IN THE ICC CRICKET WORLD CUP 2011 FINAL, ARRIVING AT THE CREASE WHEN INDIA WAS 2-31 AND STEADYING THE SHIP WITH A CALM 35. \n KOHLI WAS HANDED THE ONE-DAY CAPTAINCY FOR INDIA&RSQUO;S SERIES AGAINST SRI LANKA IN NOVEMBER 2014 WHEN MS DHONI WAS RESTED."
        vKohli.didYouKnow = "HAS BEEN NAMED ONE OF GQ MAGAZINE&RSQUO;S BEST DRESSED INTERNATIONAL MEN."
        
        
//        player = vKohli
        
        playerImage.imageURL = player?.imageURL
        playerImage.backgroundColor = secondaryColor
        playerImage.layer.borderColor = Color.white.cgColor
        playerImage.layer.borderWidth = 3
        playerImage.layer.cornerRadius = 5
        
        
        
        playerName.text = player?.fullName
        playerBattingStyle.text = player?.battingStyle
        playerBowlingStyle.text = player?.bowlingStyle
        
        playerBio.isScrollEnabled = false
        playerBio.text = player?.bio
        playerBio.textColor = mainColor
        
        if player?.didYouKnow != nil {
            playerBio.text = playerBio.text + " " + (player?.didYouKnow)!
        }
        
        let menuTitles = ["BIO"]
        mainMenu = HMSegmentedControl(sectionTitles: menuTitles)
        mainMenu.addTarget(self, action: #selector(mainMenuChangedValue(_:)), for: .valueChanged)
        mainMenu.frame = CGRect(x: 10, y: 0, width: menuPlaceHolder.frame.width - 20, height: menuPlaceHolder.frame.height)
        mainMenu.autoresizingMask =  UIViewAutoresizing()
        
        mainMenu.selectionIndicatorColor = mainColor
        mainMenu.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic
        mainMenu.layer.cornerRadius = 2
        
        
        mainMenu.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe
        mainMenu.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        
        mainMenu.backgroundColor = Color.clear
        
        mainMenu.titleTextAttributes = [NSForegroundColorAttributeName: mainColor, NSFontAttributeName: RobotoFont.regular]
        mainMenu.selectedTitleTextAttributes = [NSForegroundColorAttributeName: mainColor, NSFontAttributeName: RobotoFont.regular]
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

    func mainMenuChangedValue(_ mainMenu: HMSegmentedControl) {
        //DO SOMETHING
    }
}
