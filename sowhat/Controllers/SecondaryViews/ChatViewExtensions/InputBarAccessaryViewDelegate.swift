//
//  InputBarAccessaryView.swift
//  sowhat
//
//  Created by Ghulam Mujtaba on 12/02/2022.
//

import Foundation
import InputBarAccessoryView

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
        if inputBar.inputTextView.text != "" {
            typingIndicatorUpdate()
        }
        
        updateMicButtonStatus(show: text == "")
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                
                messageSend(text: text, photo: nil, video: nil, audio: nil, location: nil)
                
            }
        }
        
        inputBar.inputTextView.text = ""
        inputBar.invalidatePlugins()
    }
    
}
