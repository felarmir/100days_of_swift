//
//  Capital.swift
//  Project16
//
//  Created by Denis Andreev on 4/7/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var wikipedia: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, wikipedia: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.wikipedia = wikipedia
    }

}
