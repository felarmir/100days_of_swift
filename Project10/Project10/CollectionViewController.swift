//
//  CollectionViewController.swift
//  Project10
//
//  Created by Denis Andreev on 3/28/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
        
        
    }
    
    @objc func addPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.9) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else { fatalError("Error") }
        
        let person = people[indexPath.row]
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.nameLabel.text = person.name
        
        cell.layer.cornerRadius = 15.0
        cell.layer.masksToBounds = true
        
        cell.imageView.layer.cornerRadius = 5.0
        cell.imageView.layer.masksToBounds = true
        
        cell.imageView.layer.borderWidth = 2.0
        cell.imageView.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        
        let alertController = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self, weak alertController] _ in
            guard let newName = alertController?.textFields?[0].text else { return }
            person.name = newName
            
            self?.collectionView.reloadData()
        }))
        
        let ask = UIAlertController(title: "Do you want rename or delete this photo?", message: nil, preferredStyle: .alert)
        ask.addAction(UIAlertAction(title: "Delete", style: .default, handler: {[weak self] _ in
            self?.people.remove(at: indexPath.row)
            self?.collectionView.reloadData()
        }))
        ask.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [weak self] _ in
            self?.present(alertController, animated: true, completion: nil)
        }))
        present(ask, animated: true, completion: nil)
        
        
        
    }

}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.bounds.width-30)/2, height: ((self.view.bounds.width-30)/2)*1.2)
    }
    
}
