//
//  GameScene.swift
//  SpriteKitFunS2
//
//  Created by Gina Sprint on 12/7/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // a SKScene can have a .sks file
    // when you open a .sks file you can edit your scene
    // with the Scene Editor

    var background = SKSpriteNode()
    var spike = SKSpriteNode()
    var floor = SKSpriteNode()
    var ceiling = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        // recall a SKView can show one or more SKScenes
        // this method is like viewDidLoad()
        // it is called when the "view moves to" this scene
        // put our init code here
        
        // explore our coordinate system
        print("Frame width: \(self.frame.width) height: \(self.frame.height)")
        print("minX: \(self.frame.minX) maxX: \(self.frame.maxX)")
        print("minY: \(self.frame.minY) maxY: \(self.frame.maxY)")
        print("midX: \(self.frame.midX) midY: \(self.frame.midY)")

        // let's add a background sprite that shows the "court" image texture
        background = SKSpriteNode(imageNamed: "court")
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        // we want our background be behind all of the other sprites
        background.zPosition = -1 // default 0
        // add background to the scene with addChild()
        addChild(background)
        
        // now lets add spike
        spike = SKSpriteNode(imageNamed: "spike")
        spike.size = CGSize(width: 225, height: 200)
        // we want spike to "fall" according to "gravity"
        // our scene already has a "physics world"
        // we need to add physics bodies to our sprites so they can interact with each other and their physics world
        spike.physicsBody = SKPhysicsBody(circleOfRadius: spike.size.height / 2)
        addChild(spike)
        
        // we need to add a "floor" so that spike doesn't fall to oblivion
        floor = SKSpriteNode(color: .blue, size: CGSize(width: self.frame.width, height: 100.0))
        floor.position = CGPoint(x: self.frame.midX, y: self.frame.minY + floor.size.height / 2)
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        // we don't want our floor to fall according gravity
        floor.physicsBody?.isDynamic = false
        addChild(floor)
        
        // task: add a timer that every 3 seconds has a basketball fly across the screen
        ceiling = SKSpriteNode(color: .blue, size: CGSize(width: self.frame.width, height: 100.0))
        ceiling.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - ceiling.size.height / 2)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: ceiling.size)
        // we don't want our floor to fall according gravity
        ceiling.physicsBody?.isDynamic = false
        addChild(ceiling)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // apply an impulse in the Y direction to spike when the user touches
        // the screen
        spike.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
        // task: add a ceiling so spike can't fly off the top of the screen
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
