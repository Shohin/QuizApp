//
//  QuestionVC.swift
//  QuizApp
//
//  Created by Shohin Tagaev on 12/15/20.
//

import UIKit

class QuestionVC: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private(set) var question: String = ""
    private(set) var options: [String] = []
    private(set) var allowsMultipleSelection = false
    private var selection: (([String]) -> Void)?
    
    private let cellID = "Cell"
    
    convenience init(question: String,
                     options: [String],
                     allowsMultipleSelection: Bool,
                     selection: @escaping ([String]) -> Void) {
        self.init()
        self.question = question
        self.options = options
        self.allowsMultipleSelection = allowsMultipleSelection
        self.selection = selection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = allowsMultipleSelection
        headerLabel.text = question
    }
}

extension QuestionVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueCell(in: tableView)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) {
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: cellID)
    }
}

extension QuestionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection?(selectedOptions(in: tableView))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection {
            selection?(selectedOptions(in: tableView))
        }
    }
    
    private func selectedOptions(in tableView: UITableView) -> [String] {
        guard let indexPathes = tableView.indexPathsForSelectedRows else { return [] }
        return indexPathes.map {options[$0.row]}
    }
}
