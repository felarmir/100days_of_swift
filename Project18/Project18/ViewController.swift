//
//  ViewController.swift
//  Project18
//
//  Created by Denis Andreev on 4/8/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("I'm inside the viewDidLoad()")
        print(1,2,3,4,5, separator: "-")
        print("I'm inside the viewDidLoad()", terminator: "")
        print(1,2,3,4,5, separator: "-")
        
        assert(1 == 1, "Math fail!")
        assert(1 == 2, "Math fail!")
    }


}

