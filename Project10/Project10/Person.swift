//
//  Person.swift
//  Project10
//
//  Created by Denis Andreev on 3/28/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
