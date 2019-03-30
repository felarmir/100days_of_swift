//
//  MainTableController.swift
//  Project5
//
//  Created by Denis Andreev on 3/23/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit

class MainTableController: UITableViewController {

    var allWards = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(wordForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New game", style: .plain, target: self, action: #selector(startGame))
        

        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWards = startWords.components(separatedBy: "\n")
            }
        } else {
            allWards = ["silkworm"]
        }
    
        title = UserDefaults.standard.object(forKey: "currentWord") as? String ?? ""
        
        if let data = UserDefaults.standard.object(forKey: "words") as? Data {
            if let words = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String] ?? [String]() {
                usedWords = words
                if usedWords.count > 0 {
                    self.tableView .reloadData()
                }
            }
        } else {
            startGame()
        }
    }
    
    @objc func startGame() {
        title = allWards.randomElement()
        usedWords.removeAll()
        tableView.reloadData()
        
        UserDefaults.standard.set(title, forKey: "currentWord")
    }
    
    @objc func wordForAnswer() {
        let alert = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let sumbitionAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alert] action in
            guard let answer = alert?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        alert.addAction(sumbitionAction)
        present(alert, animated: true, completion: nil)
    }
    
    func submit(_ answer: String) {
        if answer.count < 3 {
            showErrorMessage(title: "Word is too short", message: "Add word that contain 3 or more characters!")
        } else {
            let lowerString = answer.lowercased()
            if isPossible(lowerString) {
                if isOriginal(lowerString) {
                    if isReal(lowerString) {
                        usedWords.insert(answer, at: 0)
                        save()
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
                        
                        return
                    } else {
                        showErrorMessage(title: "Word not recognised", message: "Be more original!")
                    }
                } else {
                    showErrorMessage(title: "Word used already", message: "You can't just make them up, you know!")
                }
            } else {
                guard let title = title?.lowercased() else { return }
                showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title)")
            }
        }
    }
    
    func showErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func isPossible(_ word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }

    func isOriginal(_ word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WORD", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    func save() {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: usedWords, requiringSecureCoding: false) {
            UserDefaults.standard.set(data, forKey: "words")
        }
    }

}
