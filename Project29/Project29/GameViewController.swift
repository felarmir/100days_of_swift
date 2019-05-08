//
//  GameViewController.swift
//  Project29
//
//  Created by Denis Andreev on 5/8/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var currentGame: GameScene!
    
    @IBOutlet weak var angleSLider: UISlider!
    @IBOutlet weak var angleLabel: UILabel!
    @IBOutlet weak var velocitySlider: UISlider!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var playerNumber: UILabel!
    
    var player1Score = 0 {
        didSet {
            currentGame.player1ScoreLabel.text = "Score: \(player1Score)"
        }
    }
    
    var player2Score = 0 {
        didSet {
            currentGame.player2ScoreLabel.text = "Score: \(player2Score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        angleChange(self)
        velocityChange(self)
        
        currentGame.player1ScoreLabel.text = "Score: \(player1Score)"
        currentGame.player2ScoreLabel.text = "Score: \(player2Score)"
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChange(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSLider.value))°"
    }
    
    @IBAction func velocityChange(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func lunch(_ sender: Any) {
        angleSLider.isHidden = true
        angleLabel.isHidden = true
        
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        
        lunchButton.isHidden = true
        
        currentGame.launch(angle: Int(angleSLider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        
        angleSLider.isHidden = false
        angleLabel.isHidden = false
        
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        
        lunchButton.isHidden = false
    }
}
