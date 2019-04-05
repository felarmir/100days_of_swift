//
//  DetailViewController.swift
//  Day59_MST
//
//  Created by Denis Andreev on 4/5/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit
import WebKit
import SVGKit

class DetailViewController: UITableViewController {

    var contry: CountryData!
    var tableData = [String]()
    @IBOutlet weak var flagImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = contry.name
        
        let svg = SVGKImage(contentsOf: URL(string: contry.flag))
        flagImage.image = svg?.uiImage
        
        tableData.append("Capital: \(contry.capital)")
        tableData.append("Area: \(contry.area!) sq km")
        tableData.append("Native name: \(contry.nativeName)")
        tableData.append("Population: \(contry.population)")
        tableData.append("Numeric Code: \(contry.numericCode!)")
        tableData.append("Currency: \(contry.currencies[0].name!)")

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        super.viewWillDisappear(animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return tableData.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
}
