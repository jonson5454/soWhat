//
//  UsersTableViewController.swift
//  sowhat
//
//  Created by a on 1/22/22.
//

import UIKit

class UsersTableViewController: UITableViewController {

    //: MARK: VARS
    var allUsers: [User] = []
    var filteredUsers: [User] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //: MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
        
        self.tableView.tableFooterView = UIView()
//        createDummyUser()
        setupSearchController()
        downloadUsers()
    }

    // MARK: - Table view delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchController.isActive ? self.filteredUsers.count : self.allUsers.count
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell

        let user = self.searchController.isActive ? self.filteredUsers[indexPath.row] : self.allUsers[indexPath.row]
        cell.configure(user: user)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = self.searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        
        showUserProfile(user)
    }
    
    //: MARK: DOWNLOAD USERS
    func downloadUsers() {
        FirebaseUserListner.shared.downloadAllUsersFromFirebase { (allFirebaseUsers) in
            
            self.allUsers = allFirebaseUsers
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
    
    private func filteredContentFor(searchText: String) {
        
        filteredUsers = allUsers.filter({ (user) -> Bool in
            return user.userName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    //: MARK: UIScrolViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl!.isRefreshing {
            self.downloadUsers()
            self.refreshControl?.endRefreshing()
        }
    }
    
    //: MARK: - Navigation
    func showUserProfile(_ user: User) {
        
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileView") as! ProfileTableViewController
        
        profileView.user = user
        self.navigationController?.pushViewController(profileView, animated: true)
    }
}

extension UsersTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filteredContentFor(searchText: searchController.searchBar.text!)
    }
}


