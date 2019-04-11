//
//  GameScene.swift
//  Day66
//
//  Created by Denis Andreev on 4/10/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var spaceShip: SKSpriteNode!
    let enemyNames = ["en1", "en2", "en3"]
    var starField: SKEmitterNode!
    var enemyTimer: Timer?
    var bulletTimer: Timer?
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        let bg = SKSpriteNode(imageNamed: "outer")
        bg.position = CGPoint(x: 512, y: 384)
        bg.blendMode = .replace
        bg.zPosition = -1
        addChild(bg)
        
        starField = SKEmitterNode(fileNamed: "starfield")!
        starField.position = CGPoint(x: 512, y: 768)
        starField.advanceSimulationTime(10)
        starField.zRotation = 1.55
        starField.zPosition = -1
        addChild(starField)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        
        spaceShip = SKSpriteNode(imageNamed: "spaceship")
        spaceShip.position = CGPoint(x: 512, y: 100)
        spaceShip.name = "player"
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size)
        spaceShip.physicsBody?.contactTestBitMask = 1
        spaceShip.physicsBody?.affectedByGravity = false
        spaceShip.physicsBody?.allowsRotation = false
        addChild(spaceShip)

        physicsWorld.contactDelegate = self
        
        enemyTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        if location.y > 200 {
            location.y = 200
        }
        spaceShip.position = location
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bulletTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(createBuulet), userInfo: nil, repeats: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bulletTimer?.invalidate()
        bulletTimer = nil
    }
    
    @objc func createBuulet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.position = CGPoint(x: spaceShip.position.x, y: spaceShip.position.y + 60)
        bullet.physicsBody = SKPhysicsBody(texture: bullet.texture!, size: bullet.size)
        bullet.physicsBody?.contactTestBitMask = 1
        bullet.physicsBody?.velocity = CGVector(dx: 0, dy: 3000)
        bullet.physicsBody?.affectedByGravity = false
        bullet.name = "bullet"
        addChild(bullet)
    }
    
    @objc func createEnemy() {
        guard let enemy = enemyNames.randomElement() else { return }
        let enemyNode = SKSpriteNode(imageNamed: enemy)
        enemyNode.position = CGPoint(x: Int.random(in: 100...900), y: 800)
        enemyNode.physicsBody = SKPhysicsBody(texture: enemyNode.texture!, size: enemyNode.size)
        enemyNode.physicsBody?.contactTestBitMask = 1
        enemyNode.physicsBody?.velocity = CGVector(dx: 0, dy: -300)
        enemyNode.physicsBody?.affectedByGravity = false
        enemyNode.name = "enemy"
        addChild(enemyNode)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == "enemy" {
            collision(between: nodeA, object: nodeB)
        }
        if nodeB.name == "enemy" {
            collision(between: nodeB, object: nodeA)
        }
        
    }
    
    func collision(between enemy: SKNode, object: SKNode) {
        if object.name == "player" {
            destroy(enemy: enemy, object: object)
        }
        if object.name == "bullet" {
            destroy(enemy: enemy, object: object)
        }
    }
    
    func destroy(enemy: SKNode, object: SKNode) {
        let exp = SKEmitterNode(fileNamed: "explosion")!
        exp.position = enemy.position
        addChild(exp)
        enemy.removeFromParent()
        
        if object.name == "player" {
            isGameOver = true
            let gmo = SKSpriteNode(imageNamed: "gameOver")
            gmo.position = CGPoint(x: 512, y: 384)
            gmo.zPosition = 1
            addChild(gmo)
            
            enemyTimer?.invalidate()
            enemyTimer = nil
            
            let exp = SKEmitterNode(fileNamed: "explosion")!
            exp.position = object.position
            addChild(exp)
            object.removeFromParent()
        } else {
            object.removeFromParent()
            score += 1
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.y < -120 {
                node.removeFromParent()
                if !isGameOver {
                    score -= 1
                }
            }
            if node.name == "bullet" && node.position.y > 800 {
                node.removeFromParent()
            }
        }
    }
}
