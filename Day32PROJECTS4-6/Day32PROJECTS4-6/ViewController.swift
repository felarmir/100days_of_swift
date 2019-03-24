//
//  ViewController.swift
//  Day32PROJECTS4-6
//
//  Created by Denis Andreev on 3/24/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemAlert))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Shopping List"
        
    }
    
    @objc func addItemAlert() {
        let alert = UIAlertController(title: "Add to shopping list", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self, weak alert] action in
            let str = alert?.textFields?[0].text
            self?.addToList(str!)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func addToList(_ item: String) {
        shoppingList.insert(item, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    @objc func shareAction() {
        let shareAction = UIActivityViewController(activityItems: [shoppingList.joined(separator: "\n")], applicationActivities: [])
        present(shareAction, animated: true, completion: nil)
    
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LIST", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    
}

