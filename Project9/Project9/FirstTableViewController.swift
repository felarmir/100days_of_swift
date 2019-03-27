//
//  FirstTableViewController.swift
//  Project7
//
//  Created by Denis Andreev on 3/25/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class FirstTableViewController: UITableViewController {

    var petitions = [Petition]()
    var defaultPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterAlert))
        
        performSelector(inBackground: #selector(fetchData), with: nil)
    }
    
    @objc func fetchData() {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(data: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func parse(data: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: data) {
            petitions = jsonPetitions.results
            defaultPetitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = DetailViewController()
        dvc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(dvc, animated: true)
    }

    
    @objc func showError() {
        let alertController = UIAlertController(title: "Loading Error!", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func showCredits() {
        let alertController = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func filterAlert() {
        let alertController = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self, weak alertController] action in
           // self?.filter(by: (alertController?.textFields![0].text)!)
            self?.performSelector(inBackground: #selector(self?.filter(by:)), with: (alertController?.textFields![0].text)!)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func filter(by str: String) {
        petitions.removeAll()
        
        if str.count == 0 {
            petitions += defaultPetitions
        } else {
            for p in defaultPetitions {
                if p.title.contains(str) {
                    petitions.append(p)
                }
            }
        }
        
        if petitions.count == 0 {
            let ac = UIAlertController(title: "Result is empty", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: {[weak self] action in
                self?.petitions += (self?.defaultPetitions)!
               // self?.tableView.reloadData()
                self?.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            }))
            present(ac, animated: true, completion: nil)
        }
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
}
