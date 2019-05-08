//
//  GameScene.swift
//  Project29
//
//  Created by Denis Andreev on 5/8/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var buildings = [BuildingNode]()
    weak var viewController: GameViewController!
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var currentPlayer = 1
    
    var player1ScoreLabel: SKLabelNode!
    var player2ScoreLabel: SKLabelNode!
    var wonPlayerLabel: SKLabelNode!
    
    var windLabel: SKLabelNode!
    var windSpeed = 0 {
        didSet {
            if windSpeed > 0 {
                windLabel.text = "Wind:  \(windSpeed) m/s to right "
            } else if windSpeed < 0 {
                windLabel.text = "Wind:  \(abs(windSpeed)) m/s to left "
            } else {
                windLabel.text = "Wind:  0 m/s"
            }
        }
    }
    
    var isGameEnd = false
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        physicsWorld.contactDelegate = self
        createBuildings()
        createPlayers()
        
        
        player1ScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        player1ScoreLabel.horizontalAlignmentMode = .left
        player1ScoreLabel.position = CGPoint(x: 16, y: 670)
        player1ScoreLabel.zPosition = 2
        addChild(player1ScoreLabel)
        
        player2ScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        player2ScoreLabel.horizontalAlignmentMode = .left
        player2ScoreLabel.position = CGPoint(x: 848, y: 670)
        player2ScoreLabel.zPosition = 2
        addChild(player2ScoreLabel)
        
        windLabel = SKLabelNode(fontNamed: "Chalkduster")
        windLabel.horizontalAlignmentMode = .center
        windLabel.fontSize = 20
        windLabel.position = CGPoint(x: 512, y: 650)
        windLabel.zPosition = 2
        addChild(windLabel)
        
        if viewController != nil {
            player1ScoreLabel.text = "Score: \(viewController.player1Score)"
            player2ScoreLabel.text = "Score: \(viewController.player2Score)"
        }
        
        wonPlayerLabel = SKLabelNode(fontNamed: "Chalkduster")
        wonPlayerLabel.fontSize = 50
        wonPlayerLabel.horizontalAlignmentMode = .center
        wonPlayerLabel.position = CGPoint(x: 512, y: 384)
        wonPlayerLabel.zPosition = 2
        
        windSpeed = Int.random(in: -20...20)
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...3)*40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            let building = BuildingNode(color: UIColor.red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }
    
    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * Double.pi / 180
    }
    
    func launch(angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10.0

        let radians = deg2rad(degrees: angle)

        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.run(sequence)
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
            banana.physicsBody?.applyForce(CGVector(dx: windSpeed, dy: 0))
        } else {
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player2.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
            banana.physicsBody?.applyForce(CGVector(dx: windSpeed, dy: 0))
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }
        
        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player1" {
            viewController.player2Score += 1
            if viewController.player2Score == 3 {
                wonPlayerLabel.text = "Player TWO WIN!"
                addChild(wonPlayerLabel)
                endGame()
            }
            destroy(player: player1)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2" {
            viewController.player1Score += 1
            if viewController.player1Score == 3 {
                wonPlayerLabel.text = "Player ONE WIN!"
                addChild(wonPlayerLabel)
                endGame()
            }
             destroy(player: player2)
        }
    }
    
    func endGame() {
        isGameEnd = true
        for b in buildings {
            b.removeFromParent()
        }
        buildings.removeAll()
        player1.removeFromParent()
        player2.removeFromParent()
    }
    
    func destroy(player: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        
        if !isGameEnd {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let newGame = GameScene(size: self.size)
                newGame.viewController = self.viewController
                self.viewController.currentGame = newGame
                
                self.changePlayer()
                newGame.currentPlayer = self.currentPlayer
                
                let transition = SKTransition.doorway(withDuration: 1.5)
                self.view?.presentScene(newGame, transition: transition)
            }
        }
    }
    
    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        
        viewController.activatePlayer(number: currentPlayer)
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        changePlayer()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
    
}
