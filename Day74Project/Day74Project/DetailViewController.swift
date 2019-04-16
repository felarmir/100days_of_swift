//
//  DetailViewController.swift
//  Day74Project
//
//  Created by Denis Andreev on 4/16/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var taskTitle: UITextField!
    @IBOutlet var doneButton: UIButton!
    
    var row = 0
    
    var saveHandler: ((Int, TaskModel) ->())?

    var dataModel: TaskModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let task = dataModel {
            textView.text = task.detail
            textView.becomeFirstResponder()
            taskTitle.text = task.title
            title = "Note: \(task.title)"
            if task.isDonde {
                doneButton.setTitle("Make Task", for: .normal)
            } else {
                doneButton.setTitle("Done", for: .normal)
            }
        }
    }
    
    @IBAction func done(_ sender: UIButton) {
        if var task = dataModel {
            task.detail = self.textView.text
            task.title = self.taskTitle.text!
            if sender.tag == 1 {
                task.isDonde = !task.isDonde
            }
            saveHandler?(row, task)
        }
        navigationController?.popViewController(animated: true)
    }

}
