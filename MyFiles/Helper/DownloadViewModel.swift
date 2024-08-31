//
//  DownloadViewModel.swift
//  MyFiles
//
//  Created by Moh_Sawy on 12/06/2024.
//

import Foundation
import Photos
import AVFoundation
import Alamofire

let notificationKey = "com.myfiles.key"

class DownloadViewModel: NSObject, ObservableObject, URLSessionDownloadDelegate {
    var task: URLSessionDataTask?
    var progress: Float = 0{
        didSet{
            DispatchQueue.main.async {[weak self] in
                NotificationCenter.default.post(name: Notification.Name(notificationKey), object: self?.progress)
            }
        }
    }
    var title: String?
    var type = 1
    
    func downloadVideo(url: URL, type: Int) {
        self.type = type
        print("&&&&&&download url isss??????????::::::::: \(url)")
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(100)
        config.timeoutIntervalForResource = TimeInterval(100)
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error fetching video", error?.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                let downloadTask = session.downloadTask(with: url)
                downloadTask.resume()
            }
            
        }
        task?.resume()
    }
    func downloadVideo(strUlr: String){
        print("ddddddddd", strUlr)
        AF.request(strUlr).downloadProgress(closure : { (progress) in
            print(progress.fractionCompleted)
            let progress = Float(progress.fractionCompleted)
            NotificationCenter.default.post(name: Notification.Name(notificationKey), object: progress)
            }).responseData{ [weak self](response) in
               guard let slf = self else{return}
               print("responseeeeee", response)
               print(response.value)
               print(response.description)
                if let data = response.value {

                    let destinationURL = createPath(name: slf.title ?? "")
                    print("desturl isss", destinationURL)
                    do {
                        try data.write(to: destinationURL)
                        if slf.type == 1{
                            if AuthService.instance.saveGallery ?? true{
                                slf.saveVideoToAlbum(videoURL: destinationURL, albumName: "Video Plant", completion: nil)
                            }
                        }else{
                            print("audio url isss", destinationURL)
                        }
                        DispatchQueue.main.async {
                            CoreDataManager.shared.saveFile(name: slf.title ?? "", type: slf.type)
                            NotificationCenter.default.post(name: Notification.Name(notificationKey), object: nil)
                        }
                    } catch {
                        print("Error saving file:", error)
                    }
                    print("there are dataa", data)
                }
            }
    }
    func cancelDownload(){
        task?.cancel()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("$$$$$type issssss", type)
        guard let data = try? Data(contentsOf: location) else {
            return
        }
        saveVideo(data: data)
//        let destinationURL = createPath(name: title ?? "")
//        print("desturl isss", destinationURL)
//        do {
//            try data.write(to: destinationURL)
//            if type == 1{
//                if AuthService.instance.saveGallery ?? true{
//                    saveVideoToAlbum(videoURL: destinationURL, albumName: "Video Plant", completion: nil)
//                }
//            }else{
//                print("audio url isss", destinationURL)
//            }
//            DispatchQueue.main.async {[weak self] in
//                CoreDataManager.shared.saveFile(name: self?.title ?? "", type: self?.type ?? 1)
//                NotificationCenter.default.post(name: Notification.Name(notificationKey), object: nil)
//            }
//        } catch {
//            print("Error saving file:", error)
//            if error.localizedDescription == "File name too long"{
//                
//            }
//        }
    }
    func saveVideo(data: Data){
        let destinationURL = createPath(name: title ?? "")
        print("desturl isss", destinationURL)
        do {
            try data.write(to: destinationURL)
            if type == 1{
                if AuthService.instance.saveGallery ?? true{
                    saveVideoToAlbum(videoURL: destinationURL, albumName: "Video Plant", completion: nil)
                }
            }else{
                print("audio url isss", destinationURL)
            }
            DispatchQueue.main.async {[weak self] in
                CoreDataManager.shared.saveFile(name: self?.title ?? "", type: self?.type ?? 1)
                NotificationCenter.default.post(name: Notification.Name(notificationKey), object: nil)
            }
        } catch let err {
            let erro = err as NSError
            if erro.code == 514{
                guard let tit = title else{return}
                let name = String(tit.split(separator: ".").first!)
                let exten = String(tit.split(separator: ".").last!)
                print("Error saving file:", err)
                title = String(tit.suffix(15))
                //+ exten
                //UUID().uuidString
                print("new video title isss", title)
                saveVideo(data: data)
            }
            
        }
    }
//    func createPath(name: String) -> URL{
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentsDirectory = paths[0]
//        let docURL = URL(fileURLWithPath: documentsDirectory)
//        //URL(string: documentsDirectory)!
//        let dataPath = docURL.appendingPathComponent("My Files")
//        if !FileManager.default.fileExists(atPath: dataPath.path) {
//            do {
//                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
//                print("created directory success")
//            } catch {
//                print("error create directory", error.localizedDescription)
//            }
//        }else{
//            print("path already exists")
//        }
//        return dataPath.appendingPathComponent(name)
//    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
        DispatchQueue.main.async {
            self.progress = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
        }
    }
    
    func saveVideoToAlbum(videoURL: URL, albumName: String, completion: ((_ success: Bool, _ errr: Error?) -> Void)?) {
        if albumExists(albumName: albumName) {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            if let album = collection.firstObject {
                self.saveVideo(videoURL: videoURL, to: album){success, error in
                    completion?(success, error)
                }
            }
        } else {
            var albumPlaceholder: PHObjectPlaceholder?
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { success, error in
                if success {
                    guard let albumPlaceholder = albumPlaceholder else { return }
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
                    guard let album = collectionFetchResult.firstObject else { return }
                    self.saveVideo(videoURL: videoURL, to: album){succcess, error in
                        completion?(success, error)
                    }
                } else {
                    print("Error creating album: \(error?.localizedDescription ?? "")")
                }
            })
        }
    }
    
    private func albumExists(albumName: String) -> Bool {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return collection.firstObject != nil
    }
    
    private func saveVideo(videoURL: URL, to album: PHAssetCollection, completion: @escaping(_ success: Bool, _ errr: Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            let enumeration: NSArray = [assetChangeRequest!.placeholderForCreatedAsset!]
            albumChangeRequest?.addAssets(enumeration)
        }, completionHandler: { success, error in
            if success {
                print("Successfully saved video to album")
                completion(true, nil)
            } else {
                print("Error saving video to album: \(error?.localizedDescription ?? "")")
                completion(false, error)
            }
        })
    }
    private func removeVideo(origUrl: URL, destUrl: URL, to album: PHAssetCollection) {
        var videos: [PHAsset] = []
        var delvideos: [PHAsset] = []
        
        let fetchResults = PHAsset.fetchAssets(in: album, options: nil)
        fetchResults.enumerateObjects({ [weak self] (object, count, stop) in
            let resource = PHAssetResource.assetResources(for: object)
            let filename = resource.first?.originalFilename ?? "unknown"
            if filename == origUrl.lastPathComponent{
                print("equl file name is", filename)
                delvideos.append(object)
            }
            videos.append(object)
        })
        PHPhotoLibrary.shared().performChanges({
            //let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destUrl)
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album, assets: fetchResults)
            //let enumeration: NSArray = [assetChangeRequest!.placeholderForCreatedAsset!]
            print("videos to deleted is", delvideos)
            print("all videos isss", videos)
            albumChangeRequest?.removeAssets(delvideos as NSFastEnumeration)
            //albumChangeRequest?.addAssets(enumeration)
            //albumChangeRequest?.replaceAssets(at: <#T##IndexSet#>, withAssets: <#T##NSFastEnumeration#>)
        }, completionHandler: { success, error in
            if success {
                print("Successfully removed from album")
            } else {
                print("Error saving video to album: \(error?.localizedDescription ?? "")")
            }
        })
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func replaceVideoAsset(origUrl: URL, destUrl: URL){
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", "MyAlbum")
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        if let album = collection.firstObject {
            PHPhotoLibrary.shared().performChanges({
                let desassetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destUrl)
                let origassetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: origUrl)
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                let enumeration: NSArray = [desassetChangeRequest!.placeholderForCreatedAsset!]
                //let delenum: NSArray = [origassetChangeRequest!.placeholderForCreatedAsset!]
                //albumChangeRequest?.removeAssets(delenum)
                albumChangeRequest?.addAssets(enumeration)
            }, completionHandler: { success, error in
                if success {
                    print("Successfully saved video to album")
                } else {
                    print("Error saving video to album: \(error?.localizedDescription ?? "")")
                }
            })
        }
    }
    func removeVideoFromAlbum(origUrl: URL, destUrl: URL, albumName: String) {
        if albumExists(albumName: albumName) {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            if let album = collection.firstObject {
                removeVideo(origUrl: origUrl, destUrl: destUrl, to: album)
            }
        } else {
            var albumPlaceholder: PHObjectPlaceholder?
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { success, error in
                if success {
                    guard let albumPlaceholder = albumPlaceholder else { return }
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
                    guard let album = collectionFetchResult.firstObject else { return }
                    self.removeVideo(origUrl: origUrl, destUrl: destUrl, to: album)
                } else {
                    print("Error creating album: \(error?.localizedDescription ?? "")")
                }
            })
        }
    }
    func getVideoIdentifier(videoUrl: URL) -> String? {
        var video: PHAsset?
        if albumExists(albumName: "Video Plant") {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", "Video Plant")
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            if let album = collection.firstObject {
                let fetchResults = PHAsset.fetchAssets(in: album, options: nil)
                fetchResults.enumerateObjects({ [weak self] (object, count, stop) in
                    let resource = PHAssetResource.assetResources(for: object)
                    let filename = resource.first?.originalFilename ?? "unknown"
                    if filename == videoUrl.lastPathComponent{
                        print("equl file name is", filename)
                        video = object
                    }
                })
            }
            return video?.localIdentifier
        }
        else{
            return nil
        }
    }
}

