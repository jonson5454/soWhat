//
//  ChatsTableViewController.swift
//  sowhat
//
//  Created by a on 2/7/22.
//

import UIKit

class ChatsTableViewController: UITableViewController {

    //: MARK: VARS
    var allRecents: [RecentChat] = []
    var filteredRecents: [RecentChat] = []
    
    var searchController = UISearchController(searchResultsController: nil)
    
    //: MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        self.setupSearchController()
        self.downloadRecentChats()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchController.isActive ? filteredRecents.count : allRecents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecentTableViewCell
        
        let recent = searchController.isActive ? filteredRecents[indexPath.row] : allRecents[indexPath.row]
        
        cell.configure(recent: recent)
        
        return cell
    }

    //: MARK: Download Chats
    private func downloadRecentChats() {
        
        FirebaseRecentListner.shared.downloadRecentChatsFromFireStore { (allChats) in
            
            self.allRecents = allChats
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func filteredContentFor(searchText: String) {
        
        filteredRecents = allRecents.filter({ (recent) -> Bool in
            return recent.receiverName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    //: MARK: Search controller
    private func setupSearchController() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
    }
}


extension ChatsTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filteredContentFor(searchText: searchController.searchBar.text!)
    }
}
