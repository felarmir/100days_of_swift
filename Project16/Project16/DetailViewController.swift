//
//  DetailViewController.swift
//  Project16
//
//  Created by Denis Andreev on 4/7/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webKit: WKWebView!
    var wikipediaUrl: String!
    var placeName: String!
    
    override func loadView() {
        webKit = WKWebView()
        view = webKit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webKit.load(URLRequest(url: URL(string: wikipediaUrl)!))
        title = placeName
    }

}
