//
//  GameViewController.swift
//  RunningRabbit
//
//  Created by María Karlsdóttir on 11/10/2018.
//  Copyright © 2018 María Karlsdóttir. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameViewController: UIViewController {

    
    
    // Bunny sprite
    // https://opengameart.org/content/bunny-rabbit-lpc-style-for-pixelfarm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    // Rotational functions
    
    @objc func cannotRotate() -> Void {}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cannotRotate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeLeft.rawValue), forKey: "orientation")
        }
    }

    
}


