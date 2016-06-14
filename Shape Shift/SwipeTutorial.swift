//
//  SwipeTutorial.swift
//  Shape Shift
//
//  Created by BLAKE IVY on 3/8/16.
//  Copyright © 2016 One9two. All rights reserved.
//

import SpriteKit

class SwipeTutorial: SKScene {

    var swipedUp     = false
    var swipedAcross = false
    
    enum Entities: String {
        case Catcher, Shape, Touch
    }
    
    override func didMoveToView(view: SKView) {
        let catcher = childNodeWithName(Entities.Catcher.rawValue)
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "TeachMe")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .AspectFit
        self.view?.presentScene(gameScene!, transition: SKTransition.crossFadeWithDuration(1.0))
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch            = touches.first
        let touchLocation    = touch?.locationInNode(self)
        let previousLocation = touch?.previousLocationInNode(self)
        
        guard swipedUp     == true else {
            return
        }
        
        
        guard swipedAcross == true else {
            return
        }
    }
    
}
