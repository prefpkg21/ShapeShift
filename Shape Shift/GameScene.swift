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
let CatcherCategoryName = "catcher"
let CatchBarCategoryName = "catchBar"
let ShapeCategoryName   = "shape"

// Contact bitmask setup
let ShapeCategory    : UInt32 = 0x1 << 0
let CatcherCategory  : UInt32 = 0x1 << 1
let BottomCategory   : UInt32 = 0x1 << 2

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  var score: Int = 0
  var caught     = false
  
  var scoreLabel: SKLabelNode!
  //
  var catcherNode = SKSpriteNode()
  var shape       = SKSpriteNode()
  
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
      super.didMoveToView(view)
      
      physicsWorld.contactDelegate = self
    
      //setup shape
     
      
      //Setup the Catcher
//      catcherNode      = SKSpriteNode(imageNamed: "CirCatch")
//      let placeSize    = view.frame.width / 2
//      catcherNode.size = CGSize(width: placeSize, height: placeSize)
//      catcherNode.position = CGPointMake(CGRectGetMidX(frame),frame.height / 8)
//      addChild(catcherNode)
      catcherNode = childNodeWithName(CatcherCategoryName) as! SKSpriteNode
      
      //Catcher Collider setup
      
//      let catcherRect = CGRectMake(0, 0, catcherNode.size.width, 1)
//      let catcherCollider = SKNode()
//      catcherCollider.physicsBody = SKPhysicsBody(edgeLoopFromRect: catcherRect)
//      catcherCollider.physicsBody?.categoryBitMask = CatcherCategory
//      catcherNode.addChild(catcherCollider)
      
      //Setup bottom contact (no Catch)
      let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
      let bottom = SKNode()
      bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
      bottom.physicsBody?.dynamic = false
      addChild(bottom)
      
      //Assign bitmasks
      bottom.physicsBody?.categoryBitMask      = BottomCategory
      //catcherNode.physicsBody?.categoryBitMask = CatcherCategory
      shape.physicsBody?.categoryBitMask       = ShapeCategory
      
      shape.physicsBody?.contactTestBitMask    = BottomCategory | CatcherCategory
    }
    
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {

    // Get touch location
    let touch            = touches.first!
    let touchLocation    = touch.locationInNode(self)
    let previousLocation = touch.previousLocationInNode(self)
    
    // Calculate Horizontal position
    var moveHorizontal = catcherNode.position.x + (touchLocation.x - previousLocation.x)
   
    //limit to onscreen
    moveHorizontal       = max(moveHorizontal, catcherNode.size.width / 2)
    moveHorizontal       = min(moveHorizontal, size.width - catcherNode.size.width/2)
    catcherNode.position = CGPointMake(moveHorizontal, catcherNode.position.y)
    
    // Calculate new size value
    var resizeValue  = catcherNode.size.width + (touchLocation.y - previousLocation.y)
    resizeValue      = max(resizeValue, minSpriteSize)
    resizeValue      = min(resizeValue, (view?.frame.width)! / 2)
    //catcherNode.size = CGSize(width: resizeValue, height: resizeValue)
    let resizeAction = SKAction.scaleBy(resizeValue/catcherNode.size.width, duration: 0)
    catcherNode.runAction(resizeAction)
  }
  
  func didBeginContact(contact: SKPhysicsContact) {
    var firstBody  : SKPhysicsBody
    var secondBody : SKPhysicsBody
    
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody  = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody  = contact.bodyB
      secondBody = contact.bodyA
    }
    
    if firstBody.categoryBitMask == ShapeCategory && secondBody.categoryBitMask == BottomCategory {
      print("Hit bottom")
      firstBody.node?.removeFromParent()
    }
    
    if firstBody.categoryBitMask == ShapeCategory && secondBody.categoryBitMask == CatcherCategory {
      print("Hit catcher")
      firstBody.node?.removeFromParent()
      ++score
    }

  }
  
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
