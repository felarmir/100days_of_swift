//
//  WhackHole.swift
//  Project14
//
//  Created by Denis Andreev on 4/3/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import SpriteKit
import UIKit

class WhackHole: SKNode {
    
    var isVidible = false
    var isHit = false
    
    var characterNode: SKSpriteNode!

    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        characterNode = SKSpriteNode(imageNamed: "penguinGood")
        characterNode.position = CGPoint(x: 0, y: -90)
        characterNode.name = "character"
        cropNode.addChild(characterNode)
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVidible { return }
        characterNode.xScale = 1
        characterNode.yScale = 1
        characterNode.run(SKAction.moveBy(x: 0, y: 80,  duration: 0.05))
        isVidible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            characterNode.texture = SKTexture(imageNamed: "penguinGood")
            characterNode.name = "charFriend"
        } else {
            characterNode.texture = SKTexture(imageNamed: "penguinEvil")
            characterNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVidible { return }
        characterNode.run(SKAction.moveBy(x: 0, y: -90, duration: 0.05))
        isVidible = false
    }
    
    func hit() {
        isHit = true
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [unowned self] in self.isVidible = false }
        characterNode.run(SKAction.sequence([delay, hide, notVisible]))
        if let smoke = SKEmitterNode(fileNamed: "smoke") {
            smoke.position = characterNode.position
            addChild(smoke)
        }
    }
}
