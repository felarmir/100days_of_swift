//
//  FlagSelector.swift
//  Project2
//
//  Created by Denis Andreev on 3/20/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class FlagSelectorViewController: UIViewController {
    
    @IBOutlet var firstFlag: UIButton!
    @IBOutlet var secondFlag: UIButton!
    @IBOutlet var thirdFlag: UIButton!
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!

    private var countries = [String]()
    
    var score = 0
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy",
                      "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        self.firstFlag.layer.borderWidth = 1.0
        self.secondFlag.layer.borderWidth = 1.0
        self.thirdFlag.layer.borderWidth = 1.0
        
        self.firstFlag.layer.borderColor = UIColor.lightGray.cgColor
        self.secondFlag.layer.borderColor = UIColor.lightGray.cgColor
        self.thirdFlag.layer.borderColor = UIColor.lightGray.cgColor

        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction? = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        self.countryLabel.text = countries[correctAnswer].uppercased()
        self.firstFlag.setImage(UIImage(named: countries[0]), for: .normal)
        self.secondFlag.setImage(UIImage(named: countries[1]), for: .normal)
        self.thirdFlag.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    @IBAction func buttonsTapAction(_ sender: UIButton) {
        if sender.tag == correctAnswer {
            score += 1
        } else {
            score -= 1
            let alert = UIAlertController(title: "Wrong", message:nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Continue", style: .default, handler: askQuestion);
            alert.addAction(action)
            let imageView = UIImageView(frame: CGRect(x: 200, y:10, width:60, height: 40))
            imageView.image = UIImage(named: countries[correctAnswer])
            
            alert.view.addSubview(imageView)
            
            present(alert, animated: true, completion: nil)
        }
        
        askQuestion()
        if score == 10 {
            let alert = UIAlertController(title: "You win", message:nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(alert, animated: true, completion: nil)
            score = 0
        }
        self.scoreLabel.text = "Your score is \(score)"
    }
    
}

