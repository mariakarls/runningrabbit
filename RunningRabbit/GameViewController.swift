//
//  GameViewController.swift
//  RunningRabbit
//
//  Created by María Karlsdóttir on 11/10/2018.
//  Copyright © 2018 María Karlsdóttir. All rights reserved.
//

import Foundation
import UIKit

class GameViewController: UIViewController {

    // Hide back button :
    // https://freakycoder.com/ios-notes-23-how-to-hide-back-button-on-navigationbar-17fb5dfb2b8
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}


