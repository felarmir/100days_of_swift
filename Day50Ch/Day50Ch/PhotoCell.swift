//
//  PhotoCell.swift
//  Day50Ch
//
//  Created by Denis Andreev on 4/2/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet var photoView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
