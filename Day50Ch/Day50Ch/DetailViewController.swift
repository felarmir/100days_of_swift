//
//  DetailViewController.swift
//  Day50Ch
//
//  Created by Denis Andreev on 4/2/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var imagePath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(contentsOfFile: imagePath)
    }
}
