//
//  ClientsTVC.swift
//  Project25
//
//  Created by Denis Andreev on 4/26/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ClientsTVC: UITableViewController {

    var peers = [MCPeerID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)

        cell.textLabel?.text = peers[indexPath.row].displayName
        cell.textLabel?.textColor = .white
        
        return cell
    }
 
}
