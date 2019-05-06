//
//  ViewController.swift
//  Project28
//
//  Created by Denis Andreev on 5/6/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    var isFirstRun = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        isFirstRun = UserDefaults.standard.bool(forKey: "FirstRun")
        
        if !isFirstRun {
            createPassword()
        }
    }


    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    
    @IBAction func authenticateAction(_ sender: Any) {
        let ac = UIAlertController(title: "Choose method", message: "Authentication", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "FaceID", style: .default, handler: faceID))
        ac.addAction(UIAlertAction(title: "Password", style: .default, handler: password))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func password(action: UIAlertAction) {
        let ac = UIAlertController(title: "Password", message: nil, preferredStyle: .alert)
        ac.addTextField { tf in
            tf.isSecureTextEntry = true
        }
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self, weak ac] _ in
            guard let passwd = ac?.textFields![0].text else { return }
            let savedPass = KeychainWrapper.standard.string(forKey: "Password") ?? ""
            
            if passwd == savedPass {
                self?.unlockSecretMessage()
            } else {
                self?.errorAlert(title: "Wrong password")
            }
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    func faceID(_ action: UIAlertAction) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, authError) in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    
    func errorAlert(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    func createPassword() {
        let ac = UIAlertController(title: "New Password", message: nil, preferredStyle: .alert)
        ac.addTextField { tf in
            tf.isSecureTextEntry = true
        }
        ac.addTextField { (tf) in
            tf.isSecureTextEntry = true
        }
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self, weak ac] _ in
            guard let pass1 = ac?.textFields![0].text else { return }
            guard let pass2 = ac?.textFields![1].text else { return }
           
            if pass1 == pass2 {
                KeychainWrapper.standard.set(pass1, forKey: "Password")
                UserDefaults.standard.set(true, forKey: "FirstRun")
            } else {
                self?.errorAlert(title: "Password missmatch!")
            }
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
    }
    
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        navigationItem.leftBarButtonItem = nil
    }

}

