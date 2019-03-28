//
//  ViewController.swift
//  HangMan
//
//  Created by Denis Andreev on 3/27/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var answerVew: UIView!
    var imageViewBox: UIView!
    var keyBoradView: UIView!
    var answerTextLabel: UILabel!
    
    
    var head: UIImageView!
    var body: UIImageView!
    var lHand: UIImageView!
    var rHand: UIImageView!
    var lLeg: UIImageView!
    var rLeg: UIImageView!
    
    var answer = "_ _ _ _ _ _ _ _"
    var answerLettersArray = ["_", "_", "_", "_", "_", "_", "_", "_"]
    var words = ["APPLE", "CAR", "MACHINE", "PERSON", "PHONE", "COMPUTER"]
    var hiddenWord = [String]()
    var buttons = [UIButton]()
    
    var imageViewsArray = [UIImageView]()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        answerVew = UIView()
        answerVew.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(answerVew)
        
        imageViewBox = UIView()
        imageViewBox.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewBox)
        
        keyBoradView = UIView()
        keyBoradView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyBoradView)
        
        answerTextLabel = UILabel()
        answerTextLabel.translatesAutoresizingMaskIntoConstraints = false
        answerTextLabel.textAlignment = .center
        answerTextLabel.text = answer
        answerTextLabel.font = UIFont.systemFont(ofSize: 40)
        answerVew.addSubview(answerTextLabel)
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "hang")
        imageView.backgroundColor = .clear
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageViewBox.addSubview(imageView)
        
        head = UIImageView()
        head.translatesAutoresizingMaskIntoConstraints = false
        head.image = UIImage(named: "head")
        head.backgroundColor = .clear
        head.layer.masksToBounds = true
        head.contentMode = .scaleAspectFit
        imageViewBox.addSubview(head)
        
        body = UIImageView()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.image = UIImage(named: "body")
        body.backgroundColor = .clear
        body.layer.masksToBounds = true
        body.contentMode = .scaleAspectFit
        imageViewBox.addSubview(body)
        
        rHand = UIImageView()
        rHand.translatesAutoresizingMaskIntoConstraints = false
        rHand.image = UIImage(named: "hand")
        rHand.backgroundColor = .clear
        rHand.layer.masksToBounds = true
        rHand.contentMode = .scaleAspectFit
        imageViewBox.addSubview(rHand)
        
        lHand = UIImageView()
        lHand.translatesAutoresizingMaskIntoConstraints = false
        lHand.image = UIImage(named: "hand")
        lHand.backgroundColor = .clear
        lHand.transform = CGAffineTransform(scaleX: -1, y: 1)
        lHand.layer.masksToBounds = true
        lHand.contentMode = .scaleAspectFit
        imageViewBox.addSubview(lHand)
        
        rLeg = UIImageView()
        rLeg.translatesAutoresizingMaskIntoConstraints = false
        rLeg.image = UIImage(named: "leg")
        rLeg.backgroundColor = .clear
        rLeg.layer.masksToBounds = true
        rLeg.contentMode = .scaleAspectFit
        imageViewBox.addSubview(rLeg)
        
        lLeg = UIImageView()
        lLeg.translatesAutoresizingMaskIntoConstraints = false
        lLeg.image = UIImage(named: "leg")
        lLeg.backgroundColor = .clear
        lLeg.transform = CGAffineTransform(scaleX: -1, y: 1)
        lLeg.layer.masksToBounds = true
        lLeg.contentMode = .scaleAspectFit
        imageViewBox.addSubview(lLeg)
        
        
        NSLayoutConstraint.activate([
                answerVew.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                answerVew.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                answerVew.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                answerVew.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
                
                imageViewBox.topAnchor.constraint(equalTo: answerVew.bottomAnchor),
                imageViewBox.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                imageViewBox.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                imageViewBox.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
                
                keyBoradView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
                keyBoradView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                keyBoradView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                keyBoradView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                
                answerTextLabel.topAnchor.constraint(equalTo: answerVew.topAnchor),
                answerTextLabel.leadingAnchor.constraint(equalTo: answerVew.leadingAnchor),
                answerTextLabel.trailingAnchor.constraint(equalTo: answerVew.trailingAnchor),
                answerTextLabel.bottomAnchor.constraint(equalTo: answerVew.bottomAnchor, constant: -10),
                
                imageView.topAnchor.constraint(equalTo: imageViewBox.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: imageViewBox.leadingAnchor, constant: 10),
                imageView.widthAnchor.constraint(equalTo: imageViewBox.widthAnchor, multiplier: 0.5),
                imageView.bottomAnchor.constraint(equalTo: imageViewBox.bottomAnchor),
            
                head.topAnchor.constraint(equalTo: imageViewBox.topAnchor, constant: 85),
                head.leadingAnchor.constraint(equalTo: imageViewBox.centerXAnchor, constant: -40),
                
                body.topAnchor.constraint(equalTo: head.bottomAnchor, constant: -2),
                body.centerXAnchor.constraint(equalTo: head.centerXAnchor),
                
                rHand.topAnchor.constraint(equalTo: head.bottomAnchor),
                rHand.leadingAnchor.constraint(equalTo: body.trailingAnchor, constant: -2),
            
                lHand.topAnchor.constraint(equalTo: head.bottomAnchor),
                lHand.trailingAnchor.constraint(equalTo: body.leadingAnchor, constant: 2),
                
                rLeg.topAnchor.constraint(equalTo: body.bottomAnchor, constant: -2),
                rLeg.leadingAnchor.constraint(equalTo: body.trailingAnchor, constant: -5),
                
                lLeg.topAnchor.constraint(equalTo: body.bottomAnchor, constant: -3),
                lLeg.trailingAnchor.constraint(equalTo: body.leadingAnchor, constant: 5)
                
        ])
        
        
        
        //keyboard
        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T","U","V","W","X","Y","Z"]
        
        let width = (UIScreen.main.bounds.width-40)/6.0
        let height:CGFloat = 40.0
        var letterPosition = 0
        
        for row in 0..<4 {
            for column in 0..<6 {
                buttonsMaker(title: letters[letterPosition], x: CGFloat(column)*width, y: CGFloat(row)*height, width: width, height: height)
                letterPosition += 1
            }
        }
        buttonsMaker(title: letters[letterPosition], x: 2.0*width, y: 4.0*height, width: width, height: height)
        letterPosition += 1
        buttonsMaker(title: letters[letterPosition], x: 3.0*width, y: 4.0*height, width: width, height: height)
    }
    
    func buttonsMaker(title: String, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        button.frame = CGRect(x: x, y:y, width: width, height: height)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(letterTap), for: UIControl.Event.touchUpInside)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1.0
        keyBoradView.addSubview(button)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    
    func loadLevel() {
        if let str = words.randomElement() {
            hiddenWord = str.map({ character in
                return "\(character)"
            })
            
            answer = ""
            answerLettersArray.removeAll()
            for _ in 0..<hiddenWord.count {
                answer += "_ "
                answerLettersArray.append("_")
            }
            answerTextLabel.text = answer
        }
        
        imageViewsArray = [head, body, lHand, rHand, lLeg, rLeg];
        hideBody()
    }
    
    func hideBody() {
        head.isHidden = true
        body.isHidden = true
        lHand.isHidden = true
        rHand.isHidden = true
        lLeg.isHidden = true
        rLeg.isHidden = true
        for btn in buttons {
            btn.isHidden = false
        }
    }
    
    @objc func letterTap(_ sender: UIButton) {
        
        if let symbol = sender.titleLabel?.text {
            let indexes = hiddenWord.indexes(ofItemsNotEqualTo: symbol)
            
            if let ixs = indexes {
                if ixs.count > 0 {
                    for i in ixs {
                        answerLettersArray[i] = symbol
                    }
                    answer = ""
                    for letter in answerLettersArray {
                        answer += "\(letter) "
                    }
                    answerTextLabel.text = answer
                    
                    if !answerLettersArray.contains("_") {
                        let alert = UIAlertController(title: "You win!", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] action in
                            self?.loadLevel()
                        }))
                        present(alert, animated: true, completion: nil)
                    }
                }
            }  else {
                if let element = imageViewsArray.first {
                    element.isHidden = false;
                    imageViewsArray.remove(at: 0)
                }
                
                if imageViewsArray.count == 0 && answerLettersArray.contains("_") {
                    let alert = UIAlertController(title: "Game over", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] action in
                        self?.loadLevel()
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
        
        sender.isHidden = true
        buttons.append(sender)
    }
    
}

extension Array {
    
    func indexes<T: Equatable>(ofItemsNotEqualTo item: T) -> [Int]?  {
        var result = [Int]()
        for (n, elem) in self.enumerated() {
            if elem as? T == item {
                result.append(n)
            }
        }
        return result.isEmpty ? nil : result
    }
}
