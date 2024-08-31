//
//  GoogleDriveViewController.swift
//  MyFiles
//
//  Created by Moh_Sawy on 17/07/2024.
//

import Foundation
import GoogleAPIClientForREST_Drive

class GoogleDriveViewController: UIViewController {
    var filesAndFolders: [GTLRDrive_File]?
    var folderID: String?
    var stateManager: StateManager!
    
    var googleAPIs: GoogleDriveAPI? {
        get { stateManager.googleAPIs }
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        //tableView.register(UINib(nibName: "GoogleDrivecell", bundle: nil), forCellReuseIdentifier: "googlecell")
        table.register(GoogleDriveTableViewCell.self, forCellReuseIdentifier: GoogleDriveTableViewCell.cell_ID)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 400
        tableView.frame = view.bounds
        
        if title == nil { title = "Google Drive" }
        
        print("google drive files viewdidload")
        loadData()
        
    }
    
    func loadData() {
        listAudioFilesAndFolders()
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
                
                self?.filesAndFolders = files?.filter {
                    let name = ($0.name ?? "") as NSString
                    print("@@@@path", name.pathExtension)
                    return name.pathExtension == "mp4"
                }
                
                print("load data in google drive's current level complete")
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.removeSpinner()
                }
            })
        }
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
        //progVC.delegate = self
        //guard let present = self.presentingViewController else{return}
        present(progVC, animated: true)
    }
}



extension GoogleDriveViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let files = filesAndFolders else { return 0 }
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "googlecell") as! GoogleDrivecell
        guard let audioFilesAndFolders = filesAndFolders else
        {
            return cell
        }
        
        let file = audioFilesAndFolders[indexPath.row]
        // remove sufix, eg. Taylor Swift.mp3 -> Taylor Swift
        let filename: NSString = file.name as NSString? ?? ""
        print("file name issssss", filename)
        let pathPrefix = filename.deletingPathExtension
        cell.namelbl.text = pathPrefix
        cell.tapAction = { [weak self] (cell) in
            guard let index = self?.tableView.indexPath(for: cell) else { return }
            self?.downloadButtonTapped(index)
        }
        
        return cell
    }
}

extension GoogleDriveViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //downloadButtonTapped(indexPath)
        guard let files = self.filesAndFolders else { return }
        let file = files[indexPath.row]
        // open a new VC when file type is 'folder'
        if file.mimeType == "application/vnd.google-apps.folder" {
            let vc = GoogleDriveViewController()
            vc.folderID = file.identifier
            vc.title = file.name
            vc.stateManager = self.stateManager
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class GoogleDriveTableViewCell: UITableViewCell {
    static var cell_ID = "GoogleDriveTableViewCell"
    var tapAction: ((UITableViewCell) -> Void)?
    
    // set UI elements
    var cellImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 6
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: GoogleDriveTableViewCell.cell_ID)
        
        setViews()
    }
    
    func setViews() {
        let g = contentView
        g.addSubview(cellImageView)
        g.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: g.topAnchor, constant: 10),
            cellImageView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20),
            cellImageView.widthAnchor.constraint(equalToConstant: 44),
            nameLabel.topAnchor.constraint(equalTo: g.topAnchor, constant: 10),
            //nameLabel.centerYAnchor.constraint(equalTo: g.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 20),
            //nameLabel.widthAnchor.constraint(equalTo: g.widthAnchor, multiplier: 0.6),
            nameLabel.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 10)
            
            //            downloadButton.topAnchor.constraint(equalTo: g.topAnchor, constant: 10),
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // this is for custom animation
        // Configure the view for the selected state
    }
    
    @objc func downloadButtonTapped(_ sender: Any) {
        tapAction?(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

