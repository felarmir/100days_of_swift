//
//  GameScene.swift
//  Project26
//
//  Created by Denis Andreev on 4/27/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import SpriteKit
import CoreMotion

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case blachHole = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint? // for simulator
    var motionManager: CMMotionManager!
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    var isGameOver = false
    var levelNodes = [SKNode]()
    var isTeleport = false
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        loadLevel()
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        if level == 2 && isTeleport {
            player.position = CGPoint(x: 485, y: 96)
            isTeleport = false
        }

        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2.0)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
        levelNodes.append(player)
        lastTouchPosition = nil
    }
    
    func loadLevel() {
        lastTouchPosition = nil
        guard let levelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else { fatalError() }
        guard let levelString = try? String(contentsOf: levelURL) else { fatalError() }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == "x" {
                    let node = SKSpriteNode(imageNamed: "block")
                    node.position = position
                    
                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                    node.physicsBody?.isDynamic = false
                    addChild(node)
                    levelNodes.append(node)
                } else if letter == "v" {
                    createCircleNode(name: "vortex", bitMask: .vortex, position: position, action: SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                } else if letter == "b" {
                    createCircleNode(name: "bh", bitMask: .blachHole, position: position, action: SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                } else if letter == "s" {
                    createCircleNode(name: "star", bitMask: .star, position: position)
                } else if letter == "f" {
                    createCircleNode(name: "finish", bitMask: .finish, position: position)
                } else if letter == " " {
                    
                } else {
                    fatalError("Unknown letter: \(letter)")
                }
            }
        }
        createPlayer()
    }
    
    func createCircleNode(name: String, bitMask: CollisionTypes, position: CGPoint, action: SKAction? = nil) {
        let node = SKSpriteNode(imageNamed: name)
        node.name = name
        node.position = position
        
        if let action = action {
            node.run(action)
        }
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody?.categoryBitMask = bitMask.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = false
        addChild(node)
        levelNodes.append(node)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        #if targetEnvironment(simulator)
            if let currentTouch = lastTouchPosition {
                let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
                physicsWorld.gravity = CGVector(dx: diff.x/100, dy: diff.y/100)
            }
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        lastTouchPosition = nil
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            level += 1
            if level <= 2 {
                for n in levelNodes {
                    n.removeFromParent()
                }
                levelNodes.removeAll()
                loadLevel()
            }
        } else if node.name == "bh" {
            player.physicsBody?.isDynamic = false
            var newPosition =  CGPoint(x: 96, y: 672)
            if level == 2 {
               newPosition = CGPoint(x: 608, y: 96)
            }
            let move = SKAction.move(to: newPosition, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            isTeleport = true
            player.run(sequence) { [weak self] in
                self?.createPlayer()
            }
            
        }
        lastTouchPosition = nil
    }
    
}
