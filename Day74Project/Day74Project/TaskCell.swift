//
//  TaskCell.swift
//  Day74Project
//
//  Created by Denis Andreev on 4/16/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet var donebar: UIView!
    @IBOutlet var taskLabel: UILabel!

    func render(data: TaskModel) {
        taskLabel.text = data.title
        donebar.isHidden = !data.isDonde
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
