//
//  GameScene.swift
//  Alien Invasion
//
//  Created by Stanley Delacruz on 9/13/15.
//  Copyright (c) 2015 Delacruz Inc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let backgroundLayer = SKNode()
    var backgroundMovePointsPerSec: CGFloat = 400.0
    var dt: NSTimeInterval = 0
    var lastUpdateTime: NSTimeInterval = 0
    let maximunEnemies = 3
    let playableRect: CGRect
    var decreasing = 2.0
    let texture1 = SKTexture(imageNamed: "monster02_idle_left@2x")
    let texture2 = SKTexture(imageNamed: "monster02_idle@2x")
   
    override init(size: CGSize) {
        // Calculate playable margin
        let maxAspectRatio: CGFloat = 16.0/9.0 // iPhone 5"
        let maxAspectRatioWidth = size.height / maxAspectRatio
        let playableMargin = (size.width - maxAspectRatioWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0,
            width: size.width - playableMargin/2,
            height: size.height )
        
        super.init(size: size)
        
        // Setup the initial game state
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundLayer.zPosition = -1
        addChild(backgroundLayer)
        //enemy1
        for _ in 0...maximunEnemies {
            backgroundLayer.addChild(spawnGhost())
        }
        
        _ = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "faster", userInfo: nil, repeats: true)
        //background 
        
        for i in 0...2 {
            let background = backgroundNode()
            background.position = CGPoint(x: 0, y: CGFloat(i)*background.size.height)
            background.name = "background"
            addChild(background)
        }
        
        
    }
    
    func faster() {
        backgroundMovePointsPerSec += 70
    }
    

    
    func spawnGhost() -> SKSpriteNode {
        let ghost = SKSpriteNode(imageNamed: "monster02_idle_left@2x")
        
        ghost.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        ghost.physicsBody?.dynamic = false
        ghost.physicsBody?.allowsRotation = false
        ghost.physicsBody?.affectedByGravity = false
        ghost.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures([texture1,texture2], timePerFrame: 0.65)))
        ghost.setScale(1.2)
        ghost.zPosition = 50
        ghost.position = CGPoint(x: CGFloat.random(min: CGRectGetMinY(playableRect) + ghost.frame.size.height/2, max: CGRectGetMaxY(playableRect) - ghost.frame.size.height/2), y: size.height + ghost.frame.size.width/2)
        ghost.name = "ghost"
        //let actioMove = SKAction.moveToY(-ghost.size.height/2, duration: decreasing)
        //ghost.runAction(actioMove)
        return ghost
        
    }
    
   
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
     
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        moveBackground()
        moveEnemy()
        
        
    }
    
    
    func backgroundNode() ->SKSpriteNode {
        //1
        let backgroundNode = SKSpriteNode()
        backgroundNode.anchorPoint = CGPointZero
        backgroundNode.name = "background"
        
        let background1 = SKSpriteNode(imageNamed: "spaceship_bg_1@2x.png")
        background1.anchorPoint = CGPointZero
        background1.position = CGPoint(x: 0, y: 0)
        backgroundNode.addChild(background1)
        
        let background2 = SKSpriteNode(imageNamed: "spaceship_bg_2@2x.png")
        background2.anchorPoint = CGPointZero
        background2.position = CGPoint(x: 0, y: background1.size.height)
        backgroundNode.addChild(background2)
        
        let background3 = SKSpriteNode(imageNamed: "spaceship_bg_3@2x.png")
        background3.anchorPoint = CGPointZero
        background3.position = CGPoint(x: 0, y: background1.size.height + background2.size.height)
        backgroundNode.addChild(background3)
        
        
        backgroundNode.size = CGSize(width: background1.size.width, height: background1.size.height + background2.size.height + background3.size.height)
        return backgroundNode
    }
    
    func moveBackground() {
        enumerateChildNodesWithName("background") {node, _ in
        let background = node as! SKSpriteNode
            let backgroundVelocity = CGPoint(x: 0, y: -self.backgroundMovePointsPerSec)
            let amtTomove = backgroundVelocity * CGFloat(self.dt)
            background.position += amtTomove
            
            if background.position.y <= -background.size.height {
                background.position = CGPoint(x: background.position.x, y: background.position.y + background.frame.size.height*3)
            }
        }
    }
    
    func moveEnemy() {
        
        backgroundLayer.enumerateChildNodesWithName("ghost") {node, _ in
            let background = node as! SKSpriteNode
            let backgroundVelocity = CGPoint(x: 0, y: -self.backgroundMovePointsPerSec)
            let amtTomove = backgroundVelocity * CGFloat(self.dt)
            background.position += amtTomove
            
            if background.position.y <= -background.size.height {
                background.position = CGPoint(x: CGFloat.random(min: CGRectGetMinY(self.playableRect) + background.frame.size.height/2, max: CGRectGetMaxY(self.playableRect) - background.frame.size.height/2), y: self.size.height + background.frame.size.width/2)
                
            }
        }
    }
}
