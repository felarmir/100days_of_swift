//
//  ViewController.swift
//  Project6b
//
//  Created by Denis Andreev on 3/23/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var labels = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = .red
        label1.text = "100"
        label1.textAlignment = NSTextAlignment.center
        label1.sizeToFit()
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = .green
        label2.text = "Days"
        label2.textAlignment = NSTextAlignment.center
        label2.sizeToFit()
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = .gray
        label3.text = "Of"
        label3.textAlignment = NSTextAlignment.center
        label3.sizeToFit()
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = .yellow
        label4.text = "Swift"
        label4.textAlignment = NSTextAlignment.center
        label4.sizeToFit()
    
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        
//        let viewDict = ["label1":label1, "label2":label2, "label3":label3, "label4":label4]
//
//        for viewName in viewDict.keys {
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(viewName)]|", options: [], metrics: nil, views: viewDict))
//        }
//
//        let heightMetrics = ["labelHeight": 88]
//
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-(>=10)-|", options: [], metrics: heightMetrics, views: viewDict))
        
        labels += [label1, label2, label3, label4]
        
        anchorCalculate()
    }
    
    override func viewDidLayoutSubviews() {
        anchorCalculate()
    }
    
    @objc func anchorCalculate() {
        var previous: UILabel?
        for label in labels {
            label.removeConstraints(label.constraints)
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: (view.frame.height/CGFloat(labels.count))-10).isActive = true
            
            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            }
            
            previous = label
        }
    }

}

