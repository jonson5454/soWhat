//
//  ChatViewController.swift
//  sowhat
//
//  Created by a on 2/10/22.
//

import UIKit
import MessageKit
import Gallery
import RealmSwift

class ChatViewController: MessagesViewController {

    //: MARK: Vars
    private var chatId = ""
    private var recipientName = ""
    private var recipientId = ""
    
    //: MARK: Init
    init(chatId: String, recipientId: String, recipientName: String) {
        super.init(nibName: nil, bundle: nil)
            
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipientName = recipientName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //: MARK: ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    

}
