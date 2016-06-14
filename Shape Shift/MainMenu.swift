//
//  MainMenu.swift
//  Shape Shift
//
//  Created by BLAKE IVY on 3/5/16.
//  Copyright © 2016 One9two. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let gameScene = GameScene(fileNamed: "GameScene")!
        gameScene.scaleMode = .AspectFill
        let transition = SKTransition.crossFadeWithDuration(1.0)
        self.view?.presentScene(gameScene, transition: transition)
    }
}
