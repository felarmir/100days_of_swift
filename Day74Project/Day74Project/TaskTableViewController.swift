//
//  TaskTableViewController.swift
//  Day74Project
//
//  Created by Denis Andreev on 4/16/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

struct Note: Codable {
    
    var id: String
    var title: String
    var text: String
    var date: Date
    
}

class TaskTableViewController: UITableViewController {

    var tasks = [TaskModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
 
        if let savedData = UserDefaults.standard.object(forKey: "notes") as? Data{
            let jsonDec = JSONDecoder()
            do {
                tasks = try jsonDec.decode([TaskModel].self, from: savedData)
                tableView.reloadData()
            } catch {
                print("Fail to decode Data!")
            }
        }
    }
    
    @objc func addNewTask() {
        let alert = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self, weak alert] _ in
            guard let text = alert?.textFields?[0].text else {return}
            self?.tasks.insert(TaskModel(title: text, detail: "", isDonde: false), at: 0)
            self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self?.save()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil))
        present(alert, animated: true, completion: nil)
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasks.count == 0 {
            let label = UILabel(frame: tableView.frame)
            label.text = "There is no notes yet"
            label.textColor = .lightGray
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            tableView.backgroundView = label
        } else {
            let v = UIView(frame: tableView.frame)
            v.backgroundColor = .clear
            tableView.backgroundView = v
        }
        return tasks.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TASK", for: indexPath) as? TaskCell else { fatalError() }
        cell.render(data: tasks[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dvc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {return}
        dvc.dataModel = tasks[indexPath.row]
        dvc.row = indexPath.row
        dvc.saveHandler = { row, model in
            self.tasks[row] = model
//            if model.isDonde {
//                self.tableView.reloadData()
//            }
            self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            self.save()
        }
        navigationController?.pushViewController(dvc, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            save()
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let saveData = try? jsonEncoder.encode(tasks) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "notes")
        } else {
            print("Failed to save data!")
        }
    }
}
