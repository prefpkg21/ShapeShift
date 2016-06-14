//
//  GameScene.swift
//  Shape Shift
//
//  Created by One9two on 11/15/15.
//  Copyright (c) 2015 One9two. All rights reserved.
//

import SpriteKit

let minSpriteSize : CGFloat =  25


// Sprite names
let CatcherCategoryName  = "catcher"
let CatchBarCategoryName = "catchBar"
let ShapeCategoryName    = "shape"

// Contact bitmask setup
let ShapeCategory    : UInt32 = 0x1 << 0
let CatcherCategory  : UInt32 = 0x1 << 1
let BottomCategory   : UInt32 = 0x1 << 2

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score: Int = 0 {
        willSet{
            scoreLabel?.text = "\(newValue)"
        }
    }
    var scoreLabel: SKLabelNode!

    var catcherNode = SKSpriteNode()
    var shape       = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        super.didMoveToView(view)
        
        physicsWorld.contactDelegate = self
        scoreLabel = childNodeWithName("score") as! SKLabelNode
        /*Setup the Catcher */
        //Initialize
        catcherNode = childNodeWithName(CatcherCategoryName) as! SKSpriteNode
        
        //Physics body setup
        let catcherRect                = CGRectMake(0, 0, catcherNode.frame.width, 3)
        let catcherBody                = SKPhysicsBody(edgeLoopFromRect: catcherRect)
        catcherBody.categoryBitMask    = CatcherCategory
        catcherBody.collisionBitMask   = 0
        catcherNode.physicsBody        = catcherBody
        
        //Setup screen bottom contact (Catch failed)
        let bottomRect             = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom                 = SKNode()
        let bottomBody             = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        bottomBody.dynamic         = false
        bottomBody.categoryBitMask = BottomCategory
        bottom.physicsBody         = bottomBody
        addChild(bottom)
        
        /* Begin Game Loop */
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch          = touches.first!
        let touchLocation  = touch.locationInNode(self)
        if nodeAtPoint(touchLocation).name == "backButton" {
            returnToMenu()
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Get touch location
        let touch            = touches.first!
        let touchLocation    = touch.locationInNode(self)
        let previousLocation = touch.previousLocationInNode(self)
        
       
        // Calculate Horizontal position
        var moveHorizontal   = catcherNode.position.x + (touchLocation.x - previousLocation.x)
        
        //limit to onscreen
        moveHorizontal       = max(moveHorizontal, catcherNode.size.width / 2)
        moveHorizontal       = min(moveHorizontal, size.width - catcherNode.size.width/2)
        catcherNode.position = CGPointMake(moveHorizontal, catcherNode.position.y)
        
        // Calculate new size value
        var resizeValue      = catcherNode.size.width + (touchLocation.y - previousLocation.y)
        resizeValue          = max(resizeValue, minSpriteSize)
        resizeValue          = min(resizeValue, (view?.frame.width)! )
        
        let resizeAction     = SKAction.scaleBy(resizeValue/catcherNode.size.width, duration: 0)
        catcherNode.runAction(resizeAction)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody  : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        // Shapes will always be first body
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody  = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody  = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == ShapeCategory && secondBody.categoryBitMask == BottomCategory {
        
            returnToMenu()
            
        }
        
        if firstBody.categoryBitMask == ShapeCategory && secondBody.categoryBitMask == CatcherCategory {
            if let shapeWidth = firstBody.node?.frame.width,
                let catchWidth = secondBody.node?.frame.width{
            if abs(shapeWidth - catchWidth) < 20 {
                firstBody.node?.removeFromParent()
                // firstBody.node?.runAction(disappear)
                ++score
            }
            }
        }
    }
    
    func returnToMenu (){
        let menu = MainMenu(fileNamed: "MainMenu")
        menu?.scaleMode = .AspectFit
        self.view?.presentScene(menu)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
