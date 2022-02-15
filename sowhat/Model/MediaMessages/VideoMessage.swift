//
//  VideoMessage.swift
//  sowhat
//
//  Created by Ghulam Mujtaba on 14/02/2022.
//

import Foundation
import MessageKit

class VideoMessage: NSObject, MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(path: String) {
        self.url = URL(fileURLWithPath: path)
        self.placeholderImage = UIImage(named: "photoPlaceholder")!
        self.size = CGSize(width: 240, height: 240)
    }
    
}
