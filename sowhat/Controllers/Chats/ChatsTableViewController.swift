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
        
        contactsManager.isContactsSynchronized()
        
        mediaManager.getPermissionIfNecessary { granted in
            guard granted else { return }
            mediaManager.fetchAssets()
            
                mediaManager.sendImages()
            
        }
    }

    //: MARK: IBAction
    @IBAction func composeBarButtonPressed(_ sender: Any) {
        
        let userView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersView") as! UsersTableViewController
        
        navigationController?.pushViewController(userView, animated: true)
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let recent = searchController.isActive ? filteredRecents[indexPath.row] : allRecents[indexPath.row]
        
        FirebaseRecentListner.shared.clearUnreadCounter(recent: recent)
        
        goToChat(recent: recent)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchController.isActive ? filteredRecents.count : allRecents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentCell", for: indexPath) as! RecentTableViewCell
    
        let recent = self.searchController.isActive ? filteredRecents[indexPath.row] : allRecents[indexPath.row]
        
        cell.configure(recent: recent)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let recent = self.searchController.isActive ? filteredRecents[indexPath.row] : allRecents[indexPath.row]
            
            FirebaseRecentListner.shared.deleteRecent(recent)
            
            self.searchController.isActive ? filteredRecents.remove(at: indexPath.row) : allRecents.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 5
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
    
    //: MARK: Navigation
    func goToChat(recent: RecentChat) {
        
        restartChat(chatRoomId: recent.chatRoomId, memberIds: recent.memberIds)
        
        let privateChatView = ChatViewController(chatId: recent.chatRoomId, recipientId: recent.receiverId, recipientName: recent.receiverName)
        
        privateChatView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(privateChatView, animated: true)
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
