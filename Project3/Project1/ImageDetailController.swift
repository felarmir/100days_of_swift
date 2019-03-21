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

    var selectedImage: String?
    var selectedImageID: Int?
    var totalImagesCoint: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        
        if let imageName = selectedImage {
            self.imageView.image = UIImage (named: imageName)
            title = imageName
        }
        
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
    
    @objc func shareAction() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: [])
        activity.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activity, animated: true, completion: nil)
    }
    
}
