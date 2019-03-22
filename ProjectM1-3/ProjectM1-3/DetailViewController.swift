//
//  DetailViewController.swift
//  ProjectM1-3
//
//  Created by Denis Andreev on 3/22/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = imageName {
            imageView.image = UIImage(named: name)
        }

        title = imageName?.uppercased()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
    }

    
    @objc func shareImage() {
        let activity = UIActivityViewController(activityItems: [self.imageView.image!], applicationActivities: [])
        activity.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activity, animated: true, completion: nil)
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
