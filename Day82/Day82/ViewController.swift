//
//  ViewController.swift
//  Day82
//
//  Created by Denis Andreev on 4/24/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var bounceButton: UIButton!
    @IBOutlet var bounceView: UIView!
    
    @IBOutlet var numberField: UITextField!
    @IBOutlet var timesButton: UIButton!
    
    @IBOutlet var itemField: UITextField!
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var itemsLabel: UILabel!
    
    var av: UIView?
    
    var strArray = ["apple", "banana", "milk", "egg"]
    
    var  isBounseOut = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bounceButton.layer.masksToBounds = true
        bounceButton.layer.cornerRadius = bounceButton.bounds.height/2.0
        
        timesButton.layer.masksToBounds = true
        timesButton.layer.cornerRadius = timesButton.bounds.height/2.0
        
        removeButton.layer.masksToBounds = true
        removeButton.layer.cornerRadius = removeButton.bounds.height/2.0
        
        reloadLabel()
    }
    
    

    @IBAction func bounceAction() {
        if !isBounseOut {
            bounceView.bounceOut(duration: 1.0)
        } else {
            bounceView.bounceIn(duration: 1.0)
        }
        isBounseOut = !isBounseOut
    }
    
    @IBAction func timesAction() {
        if let v = Int(numberField.text!) {
            var countText = ""
            v.times {
                countText += "Hello Swift! \n"
            }
           
            av = UIView()
            av?.backgroundColor = .white
            av?.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            
            
            let label = UILabel(frame: av!.frame)
            label.textAlignment = .center
            label.text = countText
            label.textColor = .black
            label.numberOfLines = 0
            av?.addSubview(label)
            let tap = UITapGestureRecognizer(target: self, action: #selector(closeview))
            av?.addGestureRecognizer(tap)
            self.view.addGestureRecognizer(tap)
            av?.center = view.center
            self.view.addSubview(av!)
            
        }
    }
    
    func reloadLabel() {
        var str = ""
        for itm in strArray {
            str += itm + "\n"
        }
        self.itemsLabel.text = str
    }
    
    @IBAction func rmEction() {
        let str = itemField.text!
        strArray.remove(str)
        reloadLabel()
        itemField.text = ""
    }
    
    @objc func closeview() {
        av?.removeFromSuperview()
        av = nil
    }

}

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }
    }
    func bounceIn(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}

extension Int {
    func times(_ clousure: () -> Void) {
        guard self > 0 else { return }
        for _ in 0..<self {
            clousure()
        }
    }
}

extension Array where Element: Comparable {
    mutating func remove(_ item: Element) {
        if let location = self.firstIndex(of: item) {
            self.remove(at: location)
        }
    }
}
