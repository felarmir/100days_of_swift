//
//  GameScene.swift
//  Project14
//
//  Created by Denis Andreev on 4/3/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    var roundNum = 0
    
    var slots = [WhackHole]()
    var popupTime = 0.85
    
    override func didMove(to view: SKView) {
        let bg = SKSpriteNode(imageNamed: "whackBackground")
        bg.position = CGPoint(x: 512, y: 384)
        bg.blendMode = .replace
        bg.zPosition = -1
        addChild(bg)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tapedNodes = nodes(at: location)
        
        for node in tapedNodes {
            guard let wSlot = node.parent?.parent as? WhackHole else { continue }
            if !wSlot.isVidible { continue }
            if wSlot.isHit { continue }
            wSlot.hit()
            if node.name == "charFriend" {
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            } else if node.name == "charEnemy" {
                wSlot.characterNode.xScale = 0.85
                wSlot.characterNode.yScale = 0.85
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
 
    func createSlot(at position: CGPoint) {
        let slot = WhackHole()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        roundNum += 1
        
        if roundNum >= 30 {
            for slot in slots {
                slot.hide()
            }
            let gmo = SKSpriteNode(imageNamed: "gameOver")
            gmo.position = CGPoint(x: 512, y: 384)
            gmo.zPosition = 1
            addChild(gmo)
            run(SKAction.playSoundFileNamed("gover.m4a", waitForCompletion: false))
            
            let fScore = SKLabelNode()
            fScore.position = CGPoint(x: 512, y: 430)
            fScore.fontSize = 50
            fScore.text = "Your score: \(score)"
            fScore.fontName = "Chalkduster"
            addChild(fScore)
            return
        }
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime)}
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
}
