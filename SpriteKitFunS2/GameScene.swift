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
        addChild(spike)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
