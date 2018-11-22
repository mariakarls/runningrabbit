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
import AVFoundation
import CoreAudio

class GameViewController: UIViewController {

    
    
    // Bunny sprite
    // https://opengameart.org/content/bunny-rabbit-lpc-style-for-pixelfarm
    
    @IBOutlet weak var highScore: UIButton!
    
    var audioSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        //skView.showsPhysics = true
        scene.scaleMode = .resizeFill
        setupAudio()
        scene.gameViewController = self
        skView.presentScene(scene)
    }
    
    
    func setupAudio() {
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")
        
        let recordSettings: [String: Any] = [
            AVFormatIDKey:              kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      2,
            AVEncoderBitRateKey:        12800,
            AVLinearPCMBitDepthKey:     16,
            AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
        ]
        
        audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                do {
                    try self.audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.spokenAudio, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                    try self.audioSession.setActive(true)
                    try self.recorder = AVAudioRecorder(url:url, settings: recordSettings)
                } catch {
                    return
                }
                
                self.recorder.prepareToRecord()
                self.recorder.isMeteringEnabled = true
                self.recorder.record()
            }else{
                //println("not granted")
            }
        })
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
        
        if (self.isMovingFromParent) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeLeft.rawValue), forKey: "orientation")
        }
    }

    
}


