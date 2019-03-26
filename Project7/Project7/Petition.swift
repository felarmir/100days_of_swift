//
//  Petition.swift
//  Project7
//
//  Created by Denis Andreev on 3/25/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
