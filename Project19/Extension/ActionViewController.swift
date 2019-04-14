//
//  ActionViewController.swift
//  Extension
//
//  Created by Denis Andreev on 4/12/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDict = dict as? NSDictionary else { return }
                    guard let jsValues = itemDict[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageTitle = jsValues["title"] as? String ?? ""
                    self?.pageURL = jsValues["URL"] as? String ?? ""
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        let ac = UIAlertController(title: "Options", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Get Title", style: .default, handler: { [weak self] _ in
            self?.sendJS(str: "alert(document.title);")
        }))
        ac.addAction(UIAlertAction(title: "Get URL", style: .default, handler: { [weak self] _ in
            self?.sendJS(str: "alert(document.URL);")
        }))
        ac.addAction(UIAlertAction(title: "Custom", style: .default, handler: nil))
        present(ac, animated: true)
    }

    @objc func done() {
        sendJS(str: script.text!)
    }
    
    func sendJS(str: String) {
        let item = NSExtensionItem()
        let arg: NSDictionary = ["customJavaScript": str]
        let webDict: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: arg]
        let customJS = NSItemProvider(item: webDict, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJS]
        
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}
