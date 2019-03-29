//
//  CollectionViewController.swift
//  Project1
//
//  Created by Denis Andreev on 3/28/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit


class CollectionViewController: UICollectionViewController {

    private var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let fileManager = FileManager.default
        let items = try! fileManager.contentsOfDirectory(atPath: Bundle.main.resourcePath!)
        
        for item in items {
            if item.hasPrefix("nssl") {
                self.images.append(item)
            }
        }
        collectionView.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Flag", for: indexPath) as? CollectionViewCell else { fatalError("Error") }
        
       cell.image.image = UIImage(named: images[indexPath.row])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ImageDetailController") as? ImageDetailController {
            vc.selectedImage = images[indexPath.row]
            vc.selectedImageID = indexPath.row + 1
            vc.totalImagesCoint = images.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.bounds.width-30)/2, height: ((self.view.bounds.width-30)/2)*0.8)
    }
    
}
