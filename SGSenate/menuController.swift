//
//  menuController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Foundation
import SideMenuController

class menuController: SideMenuController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        performSegue(withIdentifier: "embedInitialCenterController", sender: nil)
        performSegue(withIdentifier: "embedSideController", sender: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "Menu Filled-50")?.withRenderingMode(.alwaysTemplate)
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 300
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay

        super.init(coder: aDecoder)
    }
}
