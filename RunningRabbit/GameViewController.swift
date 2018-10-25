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

    @objc func cannotRotate() -> Void {}


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.enableAllOrientation = false
        
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cannotRotate()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.enableAllOrientation = true
        
        //let value = UIInterfaceOrientation.landscapeLeft.rawValue
        //UIDevice.current.setValue(value, forKey: "orientation")
        
        if (self.isMovingFromParentViewController) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeLeft.rawValue), forKey: "orientation")
        }
        
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    
}


