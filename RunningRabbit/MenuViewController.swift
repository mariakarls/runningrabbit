//
//  ViewController.swift
//  RunningRabbit
//
//  Created by María Karlsdóttir on 11/10/2018.
//  Copyright © 2018 María Karlsdóttir. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    // Image as background
    // https://stackoverflow.com/questions/27197799/xcode-6-how-to-make-an-image-view-fill-the-screen-on-all-devices-auto-layout-n
    
    // Sprite Kit
    // https://developer.apple.com/spritekit/
    // https://www.raywenderlich.com/71-spritekit-tutorial-for-beginners
    
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 */

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

}

