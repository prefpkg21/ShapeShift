//
//  GameViewController.swift
//  Shape Shift
//
//  Created by One9two on 11/15/15.
//  Copyright (c) 2015 One9two. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view.
        let skView = self.view as! SKView
        let defaults = NSUserDefaults.standardUserDefaults()
        let needsTutorial = defaults.valueForKey("TeachMe") as! Bool
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        if let scene = shouldDisplayTutorial(needsTutorial: needsTutorial){
            
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFit
        
        skView.presentScene(scene)
        }
        
    }
    func shouldDisplayTutorial (needsTutorial tutorial: Bool)->SKScene? {
      
        
        if tutorial {
            
            guard let scene = SwipeTutorial(fileNamed: "SwipeTutorial") else {
                print("Error Loading File")
                return nil
            }
            return scene
            
        } else {
            
            guard let scene = MainMenu(fileNamed:"MainMenu") else {
                return nil
            }
            return scene
        }

    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
