//
//  PhotoModel.swift
//  Day50Ch
//
//  Created by Denis Andreev on 4/2/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class PhotoModel: NSObject, NSCoding {

    var name: String
    var image: String
    var date: String
    
    init(name: String, image: String, date: String) {
        self.name = name
        self.image = image
        self.date = date
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.image, forKey: "image")
        aCoder.encode(self.date, forKey: "date")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
        self.date = aDecoder.decodeObject(forKey: "date") as? String ?? ""
    }
    

}
