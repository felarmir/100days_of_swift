//
//  GameScene.swift
//  Project17
//
//  Created by Denis Andreev on 4/7/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
     var possibleEnemies = ["r1", "r2", "r3"]
     var isGameOver = false
     var gameTimer: Timer?
     var startTime = 0.35
     
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starField = SKEmitterNode(fileNamed: "starfield")!
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        addChild(starField)
        starField.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
     
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
     
     @objc func createEnemy() {
          guard let enemy = possibleEnemies.randomElement() else { return }
          
          let sprite = SKSpriteNode(imageNamed: enemy)
          sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
          addChild(sprite)
          
          sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
          sprite.physicsBody?.categoryBitMask = 1
          sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
          sprite.physicsBody?.angularVelocity = 5
          sprite.physicsBody?.linearDamping = 0
          sprite.physicsBody?.angularDamping = 0
          
          if score % 20 == 0 {
               gameTimer?.invalidate()
               startTime -= 0.01
               gameTimer = Timer.scheduledTimer(timeInterval: startTime, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
          }
     }
     
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
          scene?.view?.isPaused = true
     }
    
     
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
          scene?.view?.isPaused = false
          guard let touch = touches.first else { return }
          var location = touch.location(in: self)
          
          if location.y < 100 {
               location.y = 100
          } else if location.y > 668 {
               location.y = 668
          }
          player.position = location
     }
     
     func didBegin(_ contact: SKPhysicsContact) {
          let exp = SKEmitterNode(fileNamed: "explosion")!
          exp.position = player.position
          addChild(exp)
          player.removeFromParent()
          isGameOver = true
          gameTimer?.invalidate()
          gameTimer = nil
          scene?.view?.isPaused = true
     }
     
    override func update(_ currentTime: TimeInterval) {
     for node in children {
          if node.position.x < -300 {
               node.removeFromParent()
          }
     }
     if !isGameOver {
          score += 1
     }
    }
}
