//
//  CountryListTableVC.swift
//  Day59_MST
//
//  Created by Denis Andreev on 4/5/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class CountryListTableVC: UITableViewController {

    var countryes = [CountryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Countries Facts"
        
        guard let dataUrl = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            fatalError("Error to get data url")
        }
        
        guard let data = try? Data(contentsOf: dataUrl) else {
            fatalError("Error  to load data")
        }
        
        guard let jsData = try? JSONDecoder().decode([CountryData].self, from: data) else {
            fatalError("Error  to decode data")
        }
        
        countryes = jsData
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.text = countryes[indexPath.row].name
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        dc.contry = countryes[indexPath.row]
        navigationController?.pushViewController(dc, animated: true)
    }

}
