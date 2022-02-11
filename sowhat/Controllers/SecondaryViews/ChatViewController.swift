//
//  ChatViewController.swift
//  sowhat
//
//  Created by a on 2/10/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Gallery
import RealmSwift

class ChatViewController: MessagesViewController {

    //: MARK: Vars
    private var chatId = ""
    private var recipientName = ""
    private var recipientId = ""
    
    let currentUser = MKSender(senderId: User.currentId, displayName: User.currentUser!.userName)
    
    var mkMessages: [MKMessage] = []
    
    let refreshControl = UIRefreshControl()
    
    let micButton = InputBarButtonItem()
    
    
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

        configureMessageCollectionView()
        if #available(iOS 13.0, *) {
            configureMessageInputBar()
        } else {
            // Fallback on earlier versions
        }
    }
    
    //: MARK: Configuration
    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        messagesCollectionView.refreshControl = refreshControl
        
    }
    
    @available(iOS 13.0, *)
    func configureMessageInputBar() {
        
        messageInputBar.delegate = self
        
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "plus")
        
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside {item in
            print("attach button pressed")
        }
    
        micButton.image = UIImage(systemName: "mic.fill")
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        //add gesture recognizer
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
        
        
    }

    
    
}
