//
//  SearchViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-10-01.
//

import UIKit

class SearchViewController: UITableViewController {
    
    var searchHistory: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        searchHistory = PersistenceManager.shared.retriveHistory() ?? ["Demo"]
        configureNavigationBar()
        configureSearchBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureSearchBar() {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search in dictionary"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

}

extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let history = searchHistory[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "historyCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "historyCell")
            cell?.textLabel?.textColor = .systemBlue
            cell?.textLabel?.font = .preferredFont(forTextStyle: .title2)
            cell?.accessoryType = .disclosureIndicator
        }
        
        cell!.textLabel?.text = history
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        searchHistory.remove(at: indexPath.row)
        PersistenceManager.shared.saveHistory(searchHistory)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let history = searchHistory[indexPath.row]
        let searchResultController = SearchResultViewController()
        searchResultController.title = history
        searchResultController.learningWord = LearningWord(history)
        
        navigationController?.pushViewController(searchResultController, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchResultController = SearchResultViewController()
        searchResultController.title = searchBar.text
        searchResultController.learningWord = LearningWord(searchBar.text ?? "")
        
        if let searchLiteral = searchBar.text {
            searchHistory.append(searchLiteral)
            PersistenceManager.shared.saveHistory(searchHistory)
        }
        
        navigationController?.pushViewController(searchResultController, animated: true)
    }
}
