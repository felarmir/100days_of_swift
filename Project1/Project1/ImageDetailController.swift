//
//  ImageDetailController.swift
//  Project1
//
//  Created by Denis Andreev on 3/20/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class ImageDetailController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var counterLabel: UILabel!

    var selectedImage: String?
    var selectedImageID: Int?
    var totalImagesCoint: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        if let imageName = selectedImage {
            self.imageView.image = UIImage (named: imageName)
            title = imageName
        }
        
        let df = UserDefaults.standard
        var count: Int = df.integer(forKey: selectedImage!)
        count += 1
        df.set(count, forKey: selectedImage!)
        
        counterLabel.text = "Showed \(count) \(count > 1 ? "times" : "time")"
        
        if let imageId = selectedImageID, let totalImages = totalImagesCoint {
            title = "This image is \(imageId) of \(totalImages)"
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
}
