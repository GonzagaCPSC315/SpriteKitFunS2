//
//  GameScene.swift
//  SpriteKitFunS2
//
//  Created by Gina Sprint on 12/7/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // a SKScene can have a .sks file
    // when you open a .sks file you can edit your scene
    // with the Scene Editor

    var background = SKSpriteNode()
    var spike = SKSpriteNode()
    var floor = SKSpriteNode()
    var ceiling = SKSpriteNode()
    
    var scoreLabel = SKLabelNode()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var timer: Timer? = nil
    
    enum NodeCategory: UInt32 {
        // one category for each sprite that can come into contact/collide with other sprites
        // assign a unique power of two for each category
        // because these serves as "masks" for bitwise and-ing and or-ing later
        case spike = 1 // 0001
        case floorCeiling = 2 // 0010
        case basketball = 4 // 0100
        case football = 8 // 1000
    }
    
    override func didMove(to view: SKView) {
        // recall a SKView can show one or more SKScenes
        // this method is like viewDidLoad()
        // it is called when the "view moves to" this scene
        // put our init code here
        
        self.physicsWorld.contactDelegate = self
        
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
        spike.physicsBody?.categoryBitMask = NodeCategory.spike.rawValue
        // spike can contact with basketballs and footballs
        spike.physicsBody?.contactTestBitMask = NodeCategory.basketball.rawValue | NodeCategory.football.rawValue
        // spike still collides with the floor/ceiling
        spike.physicsBody?.collisionBitMask = NodeCategory.floorCeiling.rawValue
        addChild(spike)
        
        // we need to add a "floor" so that spike doesn't fall to oblivion
        floor = SKSpriteNode(color: .blue, size: CGSize(width: self.frame.width, height: 100.0))
        floor.position = CGPoint(x: self.frame.midX, y: self.frame.minY + floor.size.height / 2)
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        // we don't want our floor to fall according gravity
        floor.physicsBody?.isDynamic = false
        floor.physicsBody?.categoryBitMask = NodeCategory.floorCeiling.rawValue
        addChild(floor)
        
        ceiling = SKSpriteNode(color: .blue, size: CGSize(width: self.frame.width, height: 100.0))
        ceiling.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - ceiling.size.height / 2)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: ceiling.size)
        // we don't want our floor to fall according gravity
        ceiling.physicsBody?.isDynamic = false
        ceiling.physicsBody?.categoryBitMask = NodeCategory.floorCeiling.rawValue
        addChild(ceiling)
        
        // setup score label
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: ceiling.position.x, y: ceiling.position.y - 20)
        score = 0 // force an update of the label text
        addChild(scoreLabel)
        
        
        // task: add a timer that every 3 seconds has a basketball fly across the screen
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            self.addBall()
        })
    }
    
    func addBall() {
        // game plan
        // 1. create a ball sprite
        // 2. animate the ball so it flies from right to left across the screen
        // 3. animate the ball so it rotates as it flies
        // 4. set up contacts and collisions (e.g. spike contacts with a ball, spike collides with the floor/ceiling, etc.)
        // 5. add footballs
        
        // 1. create a ball sprite
        let ball = SKSpriteNode(imageNamed: "basketball")
        ball.size = CGSize(width: 125, height: 125)
        // position x: start off screen to the right, y: random value for y that does not overlap with floor or ceiling
        let minRandY = Int(self.frame.minY + floor.size.height + ball.size.height / 2)
        let maxRandY = Int(self.frame.maxY - ceiling.size.height - ball.size.height / 2)
        let randY = CGFloat(Int.random(in: minRandY...maxRandY))
        ball.position = CGPoint(x: self.frame.maxX + ball.size.width / 2, y: randY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = NodeCategory.basketball.rawValue
        ball.physicsBody?.contactTestBitMask = NodeCategory.spike.rawValue
        
        // 2. animate the ball so it flies from right to left across the screen
        // use a SKAction to setup an animation
        let moveLeft = SKAction.move(to: CGPoint(x: self.frame.minX - ball.size.width / 2, y: randY), duration: 2)
        // when the ball is off screen, we need to remove it from the scene
        let removeBall = SKAction.removeFromParent()
        // put 'em together
        let flyAnimation = SKAction.sequence([moveLeft, removeBall])
        ball.run(flyAnimation)
        
        // 3. animate the ball so it rotates as it flies
        let rotateBall = SKAction.rotate(byAngle: 2 * CGFloat.pi, duration: 1)
        let rotateBallForever = SKAction.repeatForever(rotateBall)
        ball.run(rotateBallForever)
        
        // 4. set up contacts and collisions (e.g. spike contacts with a ball, spike collides with the floor/ceiling, etc.)
        // contact: when two sprites touch, but no physics should occur
        // collision: when two sprites touch, but they should not intersect, meaning physics should take over
        // set up delegation for a callback to execute when the contact intersection occurs
        
        addChild(ball)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // called when two sprites contact
        // the two bodies, bodyA and bodyB, there is no guarantee on the order
        if contact.bodyA.categoryBitMask == NodeCategory.basketball.rawValue || contact.bodyB.categoryBitMask == NodeCategory.basketball.rawValue {
            print("spike has come into contact with a basketball")
            // remove the basketball from the scene
            contact.bodyA.categoryBitMask == NodeCategory.basketball.rawValue ? contact.bodyA.node?.removeFromParent() : contact.bodyB.node?.removeFromParent()
            // add a score label and one to the score for every caught basketball
            score += 1
            // (task 5) add footballs
            // when spike comes into contact with a football, its game over! add game over logic: pause the game, invalidate the timer, show the play again sprite
            // when the user taps to play again, remove/reset all the nodes, unpause the game, start the timer
            // add sound for when spike catches the balls
        }
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
