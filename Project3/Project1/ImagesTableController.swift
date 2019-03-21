//
//  ViewController.swift
//  Project1
//
//  Created by Denis Andreev on 3/20/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class ImagesTableController: UITableViewController {

    private var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fileManager = FileManager.default
        let items = try! fileManager.contentsOfDirectory(atPath: Bundle.main.resourcePath!)
        
        for item in items {
            if item.hasPrefix("nssl") {
                self.images.append(item)
            }
        }
        
    }

    // MARK: UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        if images.count > 0 {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IMAGENAME", for: indexPath)
        cell.textLabel?.text  = "Image \(indexPath.row+1)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ImageDetailController") as? ImageDetailController {
            vc.selectedImage = images[indexPath.row]
            vc.selectedImageID = indexPath.row + 1
            vc.totalImagesCoint = images.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

