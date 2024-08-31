//
//  GoogleDriveVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 18/07/2024.
//

import UIKit
import GoogleAPIClientForREST_Drive

class GoogleDriveVC: UIViewController {

    @IBOutlet weak var driveTable: UITableView!
    
    var filesAndFolders: [GTLRDrive_File]?
    var folderID: String?
    var stateManager: StateManager!
    
    var googleAPIs: GoogleDriveAPI? {
        get { stateManager.googleAPIs }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listAudioFilesAndFolders()
        print("new rive vc")
        setTable()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name(reloadKey), object: nil)
    }
    func listAudioFilesAndFolders() {
        showSpinner()
        // for root folder
        var id = "root"
        if let folderID = self.folderID {
            id = folderID
        }
        DispatchQueue.global().async { [weak self] in
            self?.googleAPIs?.listFiles(id, onCompleted: { files, error in
                guard error == nil, files != nil else {
                    print("Error: \(String(describing: error))")
                    return
                }
                //self?.filesAndFolders = files
                self?.filesAndFolders = files?.filter {
                    let name = ($0.name ?? "") as NSString
                    print("@@@@path", name.pathExtension)
                    return name.pathExtension == "mp4"
                }
                print("load data in google drive's current level complete")
                DispatchQueue.main.async {
                    print("reoading ddata with count", self?.filesAndFolders?.count ?? 0)
                    self?.driveTable.reloadData()
                    self?.removeSpinner()
                }
            })
        }
    }
    func setTable(){
        driveTable.estimatedRowHeight = 300
        driveTable.rowHeight = UITableView.automaticDimension
        driveTable.register(UINib(nibName: "GoogleDrivecell", bundle: nil), forCellReuseIdentifier: "googlecell")
        driveTable.dataSource = self
        driveTable.delegate = self
    }
    func downloadButtonTapped(_ index: IndexPath) {
        guard let files = filesAndFolders else { return }
        let fileItem = files[index.row]
        
        // implement your download method
        
        DispatchQueue.global().async { [weak self] in
//            self?.googleAPIs?.download(fileItem, onCompleted: { data, error in
//                guard error == nil, data != nil else {
//                    print("Err: \(String(describing: error))")
//                    return
//                }
//
//                // put code about where to save the downloaded file.
//
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            })
            self?.googleAPIs?.downloadProgress(file: fileItem)
        }
        let st = UIStoryboard(name: "Main", bundle: nil)
        let progVC = st.instantiateViewController(withIdentifier: "progVC") as! DownloadProgressVC
        //progVC.urlStr = media?.url
        //progVC.type = media?.type ?? "" == "video" ? 1 : 2
        //let fileName = "\(downloadRes?.title ?? "").\(media?.extensionType ?? "")"
        //progVC.filetitle = fileName
        progVC.delegate = self
        //guard let present = self.presentingViewController else{return}
        present(progVC, animated: true)
    }

}
extension GoogleDriveVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = filesAndFolders?.count ?? 0
        print("count isssssss", count)
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "googlecell") as! GoogleDrivecell
        guard let audioFilesAndFolders = filesAndFolders else{return cell}
        let file = audioFilesAndFolders[indexPath.row]
        // remove sufix, eg. Taylor Swift.mp3 -> Taylor Swift
        let filename: NSString = file.name as NSString? ?? ""
        print("file name issssss", filename)
        let pathPrefix = filename.deletingPathExtension
        cell.namelbl.text = pathPrefix
        cell.tapAction = { [weak self] (cell) in
            guard let index = self?.driveTable.indexPath(for: cell) else { return }
            self?.downloadButtonTapped(index)
        }
        
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
}
extension GoogleDriveVC: FinishedDownload{
    func didFinished() {
        showAlert(slf: self, message: "downloaded successfully")
    }
}

