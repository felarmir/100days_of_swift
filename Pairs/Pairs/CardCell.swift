//
//  CardCell.swift
//  Pairs
//
//  Created by Denis Andreev on 5/12/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var hidenImageView: UIImageView!
    var name: String?
    
    var isFliped = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 15.0
    }
 
    @objc func flip() {
        isFliped = !isFliped
        if isFliped {
            UIView.transition(with: self.contentView, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
                self.coverImageView.isHidden = true
                self.hidenImageView.isHidden = false
            }, completion: nil)
        } else {
            UIView.transition(with: self.contentView, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
                self.coverImageView.isHidden = false
                self.hidenImageView.isHidden = true
            }, completion: nil)
        }
    }
}
