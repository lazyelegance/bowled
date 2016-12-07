//
//  SideMenuController.swift
//  Bowled
//
//  Created by Ezra Bathini on 16/11/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material

class SideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mainMenu: HMSegmentedControl!
    
    @IBOutlet weak var headerView: View!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var intOnlyLabel: UILabel!

    @IBOutlet weak var intOnlyView: View!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mainColor
        

        // Do any additional setup after loading the view.
        
        var menuTitles = ["Team", "Series", "Type"]
        mainMenu = HMSegmentedControl(sectionTitles: menuTitles)
        
        mainMenu.addTarget(self, action: #selector(SideMenuController.mainMenuChangedValue(_:)), for: UIControlEvents.valueChanged)
        mainMenu.frame = CGRect(x: 10, y: 0, width: headerView.frame.width - 20, height: 40)
        mainMenu.autoresizingMask =  UIViewAutoresizing()
        
        mainMenu.selectionIndicatorColor = Color.blue.base
        mainMenu.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic
        
        
        mainMenu.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe
        mainMenu.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        
        mainMenu.backgroundColor = secondaryColor
       
        mainMenu.titleTextAttributes = [NSForegroundColorAttributeName: mainColor, NSFontAttributeName: RobotoFont.medium]
        mainMenu.selectedTitleTextAttributes = [NSForegroundColorAttributeName: Color.blue.base, NSFontAttributeName: RobotoFont.medium]
        
        headerView.backgroundColor = Color.white
        

        headerView.addSubview(mainMenu)
        
        
        intOnlyLabel.text = "Show International Matches Only?"
        intOnlyLabel.textColor = mainColor
        intOnlyLabel.font = RobotoFont.medium
        
        let intOnlySwitch = Switch(state: .on, style: .dark, size: .medium)
        intOnlySwitch.buttonOnColor = mainColor
        
        intOnlyView.layout.center(intOnlySwitch)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mainMenuChangedValue(_ mainMenu: HMSegmentedControl) {
        
//        if let selectedMenuTypeIndex = menuTypes[mainMenu.selectedSegmentIndex].to_Index() as? Int {
//            defaults?.set(selectedMenuTypeIndex, forKey: "selectedMenuTypeIndex")
//        }
        
        
//        tableView.reloadData()
    }
    
 

    
    // MARK: - tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        return tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
    }
}
