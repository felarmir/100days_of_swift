//
//  ImageListTableViewController.swift
//  ProjectM1-3
//
//  Created by Denis Andreev on 3/21/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class ImageListTableViewController: UITableViewController {

    var countries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        title = "Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if countries.count == 0 {
            return 0
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FLAGCELL", for: indexPath)
        cell.imageView?.image = UIImage(named: countries[indexPath.row])
        cell.textLabel?.text = countries[indexPath.row].uppercased()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailViewController.imageName = countries[indexPath.row]
            self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    }
}
