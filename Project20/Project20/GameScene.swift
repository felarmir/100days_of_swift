//
//  GameScene.swift
//  Project20
//
//  Created by Denis Andreev on 4/14/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1046
    var runCounter = 0
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var newGame: SKLabelNode!
    var endGameShow: SKLabelNode!
    
    override func didMove(to view: SKView) {
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x: 512, y: 384)
        bg.blendMode = .replace
        bg.zPosition = -1
        addChild(bg)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    @objc func launchFireworks() {
        if runCounter >= 7 {
            gameTimer?.invalidate()
            gameTimer = nil
            
            endGameShow = SKLabelNode(fontNamed: "Chalkduster")
            endGameShow.position = CGPoint(x: 340, y: 384)
            endGameShow.horizontalAlignmentMode = .left
            endGameShow.text = "Your Score: \(score)"
            addChild(endGameShow)
            
            newGame = SKLabelNode(fontNamed: "Chalkduster")
            newGame.position = CGPoint(x: 340, y: 330)
            newGame.horizontalAlignmentMode = .left
            newGame.text = "Start New Game"
            newGame.name = "newgame"
            addChild(newGame)
        } else {
            let movementAmount: CGFloat = 1200
            
            switch Int.random(in: 0...3) {
            case 0:
                createFirework(xMovement: 0, x: 512, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
                createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
                
            case 1:
                createFirework(xMovement: 0, x: 512, y: bottomEdge)
                createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
                createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
                createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
                createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
                
                
            case 2:
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
                
                
            case 3:
                createFirework(xMovement: -movementAmount, x: leftEdge, y: bottomEdge + 400)
                createFirework(xMovement: -movementAmount, x: leftEdge, y: bottomEdge + 300)
                createFirework(xMovement: -movementAmount, x: leftEdge, y: bottomEdge + 200)
                createFirework(xMovement: -movementAmount, x: leftEdge, y: bottomEdge + 100)
                createFirework(xMovement: -movementAmount, x: leftEdge, y: bottomEdge)
            default:
                break
            }
        }
        runCounter += 1
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        case 2:
            firework.color = .red
        default:
            break
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = nodes(at: location).first
        if node?.name == "newgame" {
            score = 0
            newGame.removeFromParent()
            endGameShow.removeFromParent()
            gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
        }
        
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explore(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
        }
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first else { return }
            if firework.name == "selected" {
                explore(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}
