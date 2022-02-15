//
//  FileStorage.swift
//  sowhat
//
//  Created by a on 1/21/22.
//

import Foundation
import FirebaseStorage
import ProgressHUD
import UIKit


let storage = Storage.storage()

class FileStorage {
    
    //: MARK: Images
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ documentLink: String?) -> Void) {
        
        let storageRef = storage.reference(forURL: kFILEREFRENCE).child(directory)
        let imageData = image.jpegData(compressionQuality: 0.6)
        var task: StorageUploadTask!
        
        task = storageRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in

            task.removeAllObservers()
            ProgressHUD.dismiss()

            if error != nil {
                print("Error upload image \(error!.localizedDescription)")
                return
            }

            storageRef.downloadURL { (url, error) in

                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                completion(downloadURL.absoluteString)
            }
        })

        task.observe(StorageTaskStatus.progress) { (snapshot) in

            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.show("\(CGFloat(progress))")
        }
    }
    
    //: Download Image
    class func downloadImage(imageUrl: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        let imageFileName = fileNameFrom(fileUrl: imageUrl)
            
        if fileExistsAtPath(path: imageFileName) {
            //get it locally
            print("we have local image")
            
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {
                completion(contentsOfFile)
            } else {
                print("couldn't convert local image")
                completion(UIImage(named: "avatar"))
            }
            
        } else {
            //download from nib

            if imageUrl != "" {
                
                let documentUrl = URL(string: imageUrl)
                
                let downloadQueue =  DispatchQueue(label: "imageDownloadQueue")
                
                downloadQueue.async {

                    let data = NSData(contentsOf: documentUrl!)
                    
                    if data != nil {
                        
                        //save locally
                        FileStorage.saveFileLocally(fileData: data!, fileName: imageFileName)
                        
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }
                        
                    } else {
                        print("No document in database")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    //: MARK: Upload Video
    class func uploadVideo(_ video: NSData, directory: String, completion: @escaping (_ videoLink: String?) -> Void) {
        print("upload Video to firebase")
        
        let storageRef = storage.reference(forURL: kFILEREFRENCE).child(directory)
        
        var task: StorageUploadTask!
        
        task = storageRef.putData(video as Data, metadata: nil, completion: { (metaData, error) in
            
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil {
                print("error uploading image \(error?.localizedDescription)")
                return
            }
            
            storageRef.downloadURL {(url, error) in
                
                guard let downloadUrl = url else {
                    completion(nil)
                    return
                }
                
                completion(downloadUrl.absoluteString)
            }
        })
        
        task.observe(StorageTaskStatus.progress) { (snapshot) in
            
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.show("\(CGFloat(progress))")
            
        }
    }
    
    //: MARK: Download Video
    class func downloadVideo(videoLink: String, completion: @escaping (_ isReadyToPlay: Bool,_ videoFileName: String) -> Void) {
        print("download video from firebase")
        let imageFileName = fileNameFrom(fileUrl: imageUrl)
            
        if fileExistsAtPath(path: imageFileName) {
            //get it locally
            print("we have local image")
            
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {
                completion(contentsOfFile)
            } else {
                print("couldn't convert local image")
                completion(UIImage(named: "avatar"))
            }
            
        } else {
            //download from nib

            if imageUrl != "" {
                
                let documentUrl = URL(string: imageUrl)
                
                let downloadQueue =  DispatchQueue(label: "imageDownloadQueue")
                
                downloadQueue.async {

                    let data = NSData(contentsOf: documentUrl!)
                    
                    if data != nil {
                        
                        //save locally
                        FileStorage.saveFileLocally(fileData: data!, fileName: imageFileName)
                        
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }
                        
                    } else {
                        print("No document in database")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    //: MARK: - Save Locally
    class func saveFileLocally(fileData: NSData, fileName: String){
        let docUrl = getDocumentURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: docUrl, atomically: true)
    }
    
}

//Helpers
func fileInDocumentsDirectory(fileName: String) -> String {
    return getDocumentURL().appendingPathComponent(fileName).path
}

func getDocumentURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileExistsAtPath(path: String) -> Bool {
    return FileManager.default.fileExists(atPath: fileInDocumentsDirectory(fileName: path))
}
