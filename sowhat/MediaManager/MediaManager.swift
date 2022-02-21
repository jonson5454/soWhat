//
//  MediaManager.swift
//  sowhat
//
//  Created by a on 2/21/22.
//

import Foundation
import Photos
import UIKit

final class MediaManager: NSObject {
    
    //MARK: - Vars
    public static var shared = MediaManager()
    
    //MARK: Photos Veriables
    var sections: [AlbumCollectionSectionType] = [.all, .smartAlbums, .userCollections]
    var allPhotos = PHFetchResult<PHAsset>()
    var smartAlbums = PHFetchResult<PHAssetCollection>()
    var userCollections = PHFetchResult<PHAssetCollection>()
    var profileImage = UIImageView(image: UIImage(named: "DefaultUserImage"))
    
    //MARK: Methods for Image Processing
    //Send Image
    func sendImages () {
        
        let assets: PHFetchResult<PHAsset>
        assets = allPhotos
        
        for i in 0..<assets.count {
            
            let asset = assets[i]
            
            let fileName = PHAssetResource.assetResources(for: asset).first?.originalFilename
            
            self.checkFileType(fileName: fileName!, asset: asset)
            
        }
    }
    
    //Check File Type
    func checkFileType (fileName:String, asset:PHAsset) {
        switch asset.mediaType {
        case .video:
            print("MediaType = Video ")
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    self.uploadVideo(fileName: fileName, localVideoUrl: localVideoUrl)
                }
            })
        case .image:
            print("MediaType = image ")
            uploadImage(fileName: fileName, asset: asset)
        case .audio:
            print("MediaType = audio ")
        case .unknown:
            print("MediaType = unknown ")
        @unknown default:
            print("MediaType = unknown default ")
        }
    }
    
    //Upload Video
    func uploadVideo ( fileName: String, localVideoUrl: URL) {
        
//        self.authNetworking.uploadVideoFile(fileName ,localVideoUrl) { (url, error) in
//            if let error = error { return print(error.localizedDescription) }
//            guard let url = url else { return }
//            print(url.absoluteString)
//        }
    }
    
    
    func uploadImage (fileName: String, asset:PHAsset) {
        
        let imageToSend = self.PHAssetToImage(asset: asset)
        
//        self.authNetworking.uploadImagesToStorage(fileName , imageToSend) { (url, error) in
//            if let error = error { return print(error.localizedDescription) }
//            guard let url = url else { return }
//            print(url.absoluteString)
//        }
        
    }
    
    //MARK: GET PERMISSIONS
    func getPermissionIfNecessary(completionHandler: @escaping (Bool) -> Void) {
        // 1
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completionHandler(true)
            return
        }
        // 2
        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized ? true : false)
        }
    }
    
    func fetchAssets() {// 1
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false)
        ]
        // 2
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        // 3
        smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .albumRegular,
            options: nil)
        // 4
        userCollections = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: nil)
    }
    
    //MARK: PHAsset To UIImage
    func PHAssetToImage(asset:PHAsset) -> UIImage{
        var image = UIImage()
        
        // Create a new default type of image manager imageManager
        let imageManager = PHImageManager.default()
        
        // Create a new PHImageRequestOptions object
        let imageRequestOption = PHImageRequestOptions()
        
        // Is PHImageRequestOptions valid
        imageRequestOption.isSynchronous = true
        
        // The compression mode of the thumbnail is set to none
        imageRequestOption.resizeMode = .none
        
        // The quality of the thumbnail is high quality, no matter how much time it takes to load
        imageRequestOption.deliveryMode = .highQualityFormat
        
        // Take out the picture according to the rules specified by PHImageRequestOptions
        imageManager.requestImage(for: asset, targetSize: CGSize.init(width: 1080, height: 1920), contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            image = result!
        })
        return image
        
    }
    
}
