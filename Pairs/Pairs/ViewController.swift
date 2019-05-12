//
//  ViewController.swift
//  Pairs
//
//  Created by Denis Andreev on 5/12/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var selectedCells = [CardCell]()
    var openedCards = 0
    
    var names = ["chew", "ewok", "lea", "luke", "r2d2", "rey", "vader","yoda"]
    
    var cardsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardsArray += names + names
        cardsArray.shuffle()
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CardCell else { fatalError() }
        cell.hidenImageView.image = UIImage(named: cardsArray[indexPath.row])
        cell.name = cardsArray[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { return }
        cell.flip()
        selectedCells.append(cell)
        if selectedCells.count == 2 {
            if selectedCells[0].name != selectedCells[1].name {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
                    self?.selectedCells[0].flip()
                    self?.selectedCells[1].flip()
                    self?.selectedCells.removeAll()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
                    self?.selectedCells[0].flip()
                    self?.selectedCells[1].flip()
                    self?.selectedCells[0].removeFromSuperview()
                    self?.selectedCells[1].removeFromSuperview()
                    self?.selectedCells.removeAll()
                }
                openedCards += 2
            }
        }
        if openedCards == 16 {
            let ac = UIAlertController(title: "You win!", message: "Do you want start new game?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
                self?.cardsArray.removeAll()
                self?.collectionView.reloadData()
                self?.cardsArray += self!.names + self!.names
                self?.cardsArray.shuffle()
                self?.openedCards = 0
                self?.collectionView.reloadData()
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((UIScreen.main.bounds.width - 100) / 4.0) - 15
        let height = ((UIScreen.main.bounds.height - 100) / 4.0) - 15
        return CGSize(width: width, height: height)
    }
}


