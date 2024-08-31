//
//  GDriveService.swift
//  MyFiles
//
//  Created by Moh_Sawy on 17/07/2024.
//

import Foundation
import GoogleAPIClientForREST_Drive

class StateManager {
    // set your client id here
    //let signInConfig = GIDConfiguration.init(clientID: "873930974221-5jaqv1qpmfegdk7bf96eaeeep2sn5o0m.apps.googleusercontent.com")
    var googleAPIs: GoogleDriveAPI? = nil
}
class GoogleDriveAPI {
    private let service: GTLRDriveService
    let model = DownloadViewModel()
    var type = 1
    init(service: GTLRDriveService) {
        self.service = service
    }
    
    public func search(onCompleted: @escaping ([GTLRDrive_File]?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 100
        // query.q = "mimeType ='\(mimeType)' or mimeType = 'application/vnd.google-apps.folder'"
        query.q = "'root' in parents"
        self.service.executeQuery(query) { (ticket, results, error) in
            onCompleted((results as? GTLRDrive_FileList)?.files, error)
        }
    }
    
    public func listFiles(_ folderID: String, onCompleted: @escaping ([GTLRDrive_File]?, Error?) -> ()) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 100
        query.q = "'\(folderID)' in parents"
        //        self.service.shouldFetchNextPages = true
        self.service.executeQuery(query) { (ticket, results, error) in
            onCompleted((results as? GTLRDrive_FileList)?.files, error)
        }
    }
    
    public func download(_ fileItem: GTLRDrive_File, onCompleted: @escaping (Data?, Error?) -> ()) {
        guard let fileID = fileItem.identifier else {
            return onCompleted(nil, nil)
        }
        self.service.executeQuery(GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileID)) { (ticket, file, error) in
            if let error = error {
                return onCompleted(nil, error)
            }
            
            guard let data = (file as? GTLRDataObject)?.data else {
                return onCompleted(nil, nil)
            }
            
            onCompleted(data, nil)
        }
    }
    func downloadProgress(file: GTLRDrive_File) {

        let url = "https://www.googleapis.com/drive/v3/files/\(file.identifier!)?alt=media"
        let fetcher = service.fetcherService.fetcher(withURLString: url)
        fetcher.beginFetch(completionHandler: { [weak self]fileData, error in
            guard let slf = self else{return}
            if error == nil {
                print("finished downloading file Data...")
                print(fileData as Any)
                guard let data = fileData else{return}
                let destinationURL = createPath(name: file.name ?? "")
                print("desturl isss", destinationURL)
                //try! data.write(to: destinationURL)
                do {
                    try data.write(to: destinationURL)
                    if slf.type == 1{
                        if AuthService.instance.saveGallery ?? true{
                            slf.model.saveVideoToAlbum(videoURL: destinationURL, albumName: "Video Plant", completion: nil)
                        }
                    }else{
                        print("audio url isss", destinationURL)
                    }
                    DispatchQueue.main.async {[weak self] in
                        CoreDataManager.shared.saveFile(name: (file.name ?? ""), type: slf.type)
                        NotificationCenter.default.post(name: Notification.Name(notificationKey), object: nil)
                    }
                } catch {
                    print("Error saving file:", error)
                }
                // do anything with data here
            
            } else {
                
                print("Error: \(error?.localizedDescription)")
            }
        })
        
        
        fetcher.receivedProgressBlock = { _, totalBytesReceived in
            print("totalBytesReceived: \(totalBytesReceived)")
            print("size: \(fetcher.response?.expectedContentLength)")
            
            if let fileSize = fetcher.response?.expectedContentLength {
                
                let progress: Float = Float(totalBytesReceived) / Float(fileSize)
                print(progress)
                DispatchQueue.main.async {[weak self] in
                    NotificationCenter.default.post(name: Notification.Name(notificationKey), object: progress)
                }
                // Update progress bar here
            }
        }

    }
}

