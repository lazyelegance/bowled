//
//  ContainerViewController.swift
//  caughtnbowled
//
//  Created by Ezra Bathini on 16/10/15.
//  Copyright © 2015 Ezra Bathini. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case bothCollapsed
    case leftPanelExpanded
    case topPanelExpanded
    case leftPanelCollapsed
    case topPanelCollapsed
}

class ContainerViewController: UIViewController, MainViewControllerDelegate {
    
    
    
    
    var centerVC: MainViewController!
    //var centerVC: LiveMainViewController!
    var centerNVC: UINavigationController!
    
    
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var leftPanelState: SlideOutState = .leftPanelCollapsed
    var topPanelState: SlideOutState = .topPanelCollapsed
    
    
    
    var leftViewController: SideMenuController?
    var rightViewController: FilterMenuController?
    let centerPanelExpandedOffset: CGFloat = kMatchListHeaderHeight - 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        centerVC = UIStoryboard.centerViewController()
        centerVC.delegate = self
        
        
        centerNVC = UINavigationController(rootViewController: centerVC)
        view.addSubview(centerNVC.view)
        addChildViewController(centerNVC)
        centerNVC.didMove(toParentViewController: self)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func toggleLeftPanel(_ seriesList: [MenuItem], teamsList: [MenuItem], matchTypesList: [MenuItem]) {

    
        
        let topPanelExpanded = (topPanelState == .topPanelExpanded)
        
        let leftPanelNotExpanded = (leftPanelState != .leftPanelExpanded)
        
        if leftPanelNotExpanded {

            if (leftViewController == nil) {
                leftViewController = UIStoryboard.leftViewController()
                //*TODO
//                leftViewController?.teamsList = teamsList
//                leftViewController?.seriesList = seriesList
//                leftViewController?.matchTypesList = matchTypesList
                
//                addChildSidePanelController(leftViewController!)
            }
        }
        
        animateLeftPanel(shouldExpand: leftPanelNotExpanded)
        if (topPanelExpanded) {
            toggleRightPanel([], teamsList: [])

        }
        
        
    }
    
    func toggleRightPanel(_ seriesList: [String], teamsList: [String]) {
        

        let topPanelNotExpanded = (topPanelState != .topPanelExpanded)
        
        if topPanelNotExpanded {
            if (rightViewController == nil) {
                rightViewController = UIStoryboard.rightViewController()
                //*TODO
//                rightViewController?.teamsList = teamsList
//                rightViewController?.seriesList = seriesList
//                addChildTopPanelController(rightViewController!)
            }

        }
        
        animateRightPanel(shouldExpand: topPanelNotExpanded)
    }
    
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addRightPanelViewController() {
        if (rightViewController == nil) {
            rightViewController = UIStoryboard.rightViewController()
            addChildTopPanelController(rightViewController!)
        }
    }
    
    
    func addChildSidePanelController(_ sidePanelController: SideMenuController) {
        
        //*TODO
//        sidePanelController.delegate = centerVC
        
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
        
        
    }
    
    func addChildTopPanelController(_ filterMenuController: FilterMenuController) {
        
        //filterMenuController.delegate = centerVC
        
        view.insertSubview(filterMenuController.view, at: 0)
        
        addChildViewController(filterMenuController)
        filterMenuController.didMove(toParentViewController: self)
        
    }
    
    
    
    func animateLeftPanel(shouldExpand: Bool) {

        
        if (shouldExpand) {
            
            leftPanelState = .leftPanelExpanded
            
            //animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNVC.view.frame) - centerPanelExpandedOffset)
            animateCenterPanelYPosition(targetPosition: centerNVC.view.frame.height - centerPanelExpandedOffset)
        } else {
            //animateCenterPanelXPosition(targetPosition: 0) { finished in
            animateCenterPanelYPosition(targetPosition: 1) { finished in
                self.leftPanelState = .leftPanelCollapsed
                
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
        

    }
    
    func animateRightPanel(shouldExpand: Bool) {

        if (shouldExpand) {
            topPanelState = .topPanelExpanded
            
            animateCenterPanelYPosition(targetPosition: centerNVC.view.frame.height - centerPanelExpandedOffset)
        } else {
            animateCenterPanelYPosition(targetPosition: 0) { finished in
                self.topPanelState = .topPanelCollapsed
                
                self.rightViewController!.view.removeFromSuperview()
                self.rightViewController = nil;
            }
        }

    }
    
    func animateCenterPanelYPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            self.centerNVC.view.frame.origin.y = targetPosition
            }, completion: completion)
    }
    
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            self.centerNVC.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNVC.view.layer.shadowOpacity = 0.0
        } else {
            centerNVC.view.layer.shadowOpacity = 0.0
        }
    }
    
    func collapseSidePanels() {
        
        if leftPanelState == .leftPanelExpanded {
            toggleLeftPanel([], teamsList: [], matchTypesList: [])
        }
        
        if topPanelState == .topPanelExpanded {
            toggleRightPanel([], teamsList: [])

        }
    }
    
    
   
    
    
    // MARK: - ToggleRight
    /*
    func toggleRightPanel() {
    let notAlreadyExpanded = (currentState != .RightPanelExpanded)
    
    if notAlreadyExpanded {
    addRightPanelViewController()
    }
    
    animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addRightPanelViewController() {
    if (rightViewController == nil) {
    rightViewController = UIStoryboard.rightViewController()
    //rightViewController!.animals = Animal.allDogs()
    
    addRightChildSidePanelController(rightViewController!)
    }
    }
    func animateRightPanel(#shouldExpand: Bool) {
    if (shouldExpand) {
    currentState = .RightPanelExpanded
    
    animateCenterPanelXPosition(targetPosition: -CGRectGetWidth(centerNVC.view.frame) + centerPanelExpandedOffset)
    } else {
    animateCenterPanelXPosition(targetPosition: 0) { _ in
    self.currentState = .BothCollapsed
    
    self.rightViewController!.view.removeFromSuperview()
    self.rightViewController = nil;
    }
    }
    }
    
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    class func leftViewController() -> SideMenuController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController
    }
    
    class func rightViewController() -> FilterMenuController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "FilterMenuController") as? FilterMenuController
    }
    
    
    
    class func centerViewController() -> MainViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
    }
}
