//
//  MyFilesVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 26/05/2024.
//

import UIKit
import Photos
import AVKit
import PhotosUI
import GoogleSignIn
import GoogleAPIClientForREST_Drive

let reloadKey = "com.myfilesreload.key"

class MyFilesVC: UIViewController {
    
    @IBOutlet weak var filesTable: UITableView!
    @IBOutlet weak var segmControl: UISegmentedControl!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var gView: UIView!
    @IBOutlet weak var dView: UIView!
    
    var stateManager: StateManager!
    var videos: [PHAsset] = []
    private static let bcf = ByteCountFormatter()
    
    var allFiles: [URL]?
    var video: [URL]?
    var image: [URL]?
    var audio: [URL]?
    var doc: [URL]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllFiles()
        setView()
        setTable()
        stateManager = StateManager()
        setupNotifications()
        //requestAcc()
    }
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: Notification.Name(reloadKey), object: nil)
    }
    @objc func reloadData(_ notification: NSNotification){
        print("#######reloading dataaaaaaa")
        getAllFiles()
    }
    func restoreSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if error != nil || user == nil {
                print("ERRRR: \(String(describing: error)), \(String(describing: error?.localizedDescription))")
            } else {
                // Post notification after user successfully sign in
                guard let user = user else { return }
                print("restore signIn state")
                self?.createGoogleDriveService(user: user)
            }
        }
    }
    func setView(){
        segmControl.setTitle("All".localized, forSegmentAt: 0)
        segmControl.setTitle("Video".localized, forSegmentAt: 1)
        segmControl.setTitle("Image".localized, forSegmentAt: 2)
        segmControl.setTitle("Audio".localized, forSegmentAt: 3)
        segmControl.setTitle("Documents".localized, forSegmentAt: 4)
        let appletap = UITapGestureRecognizer(target: self, action: #selector(appleTapped))
        appleView.addGestureRecognizer(appletap)
        let gtap = UITapGestureRecognizer(target: self, action: #selector(googleTapped))
        gView.addGestureRecognizer(gtap)
        let dtap = UITapGestureRecognizer(target: self, action: #selector(dTapped))
        dView.addGestureRecognizer(dtap)
    }
//    func requestAcc(){
//        // Request access to PhotosApp
//        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
//            
//            // Handle restricted or denied state
//            if status == .restricted || status == .denied
//            {
//                print("Status: Restricted or Denied")
//            }
//            
//            // Handle limited state
//            if status == .limited
//            {
//                self?.fetchVideos()
//                print("Status: Limited")
//            }
//            
//            // Handle authorized state
//            if status == .authorized
//            {
//                DispatchQueue.main.async {
//                    self?.fetchVideos()
//                    print("Status: Full access")
//                }
//                
//            }
//        }
//    }
//    
//    func fetchVideos()
//    {
//        videos = []
//        var type = PHAssetMediaType.video
//        switch self.segmControl.selectedSegmentIndex{
//        case 0:
//            type = .video
//        case 1:
//            type = .image
//        case 2:
//            type = .audio
//        default:
//            type = .video
//        }
//        //            DispatchQueue.main.async {
//        //                switch self.segmControl.selectedSegmentIndex {
//        //                case 0:
//        //                    type = .video
//        //                case 1:
//        //                    type = .image
//        //                case 2:
//        //                    type = .audio
//        //                default:
//        //                    type = .video
//        //                }
//        //            }
//        let fetchResults = PHAsset.fetchAssets(with: type, options: nil)
//        
//        // Loop through all fetched results
//        fetchResults.enumerateObjects({ [weak self] (object, count, stop) in
//            
//            // Add video object to our video array
//            self?.videos.append(object)
//        })
//        
//        // Reload the table view on the main thread
//        DispatchQueue.main.async {
//            self.filesTable.reloadData()
//        }
//    }
    func getAllFiles(){
        do {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("My Files")
            //print("documentDirectory", documentDirectory.path)
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: documentDirectory,
                includingPropertiesForKeys: [.creationDateKey]
            )
            //print("directoryContents:", directoryContents.map { $0 })
//            for /Users/moh/Desktop/last backup sonoma/MyFiles/MyFiles/Controllerurl in directoryContents {
//                //print(url.localizedName ?? url.lastPathComponent)
//
//            }
//            // if you would like to hide the file extension
//            for var url in directoryContents {
//                url.hasHiddenExtension = true
//            }
            //directoryContents.map{try! FileManager.default.removeItem(at: $0)}
            allFiles = directoryContents.sorted(by: { f1, f2 in
                return f1.creation ?? Date() > f2.creation ?? Date()
            })
//            allFiles?.forEach({ url in
//                print(url.creation ?? Date())
//            })
            // if you want to get all mp3 files located at the documents directory:
            let mp3s = directoryContents.filter {$0.pathExtension == "mp3"}.sorted(by: { f1, f2 in
                return f1.creation ?? Date() > f2.creation ?? Date()
            })
            //directoryContents.filter(\.isMP3).map { $0.localizedName ?? $0.lastPathComponent }
            //print("$$$$$$mp3skkkkkk:", mp3s)
            audio = mp3s
            let videos = directoryContents.filter {$0.pathExtension == "mp4" || $0.pathExtension == "mov"}.sorted(by: { f1, f2 in
                return f1.creation ?? Date() > f2.creation ?? Date()
            })
            video = videos
            let photos = directoryContents.filter {$0.pathExtension == "jpeg" || $0.pathExtension == "png"}.sorted(by: { f1, f2 in
                return f1.creation ?? Date() > f2.creation ?? Date()
            })
            image = photos
            let docs = directoryContents.filter {$0.pathExtension == "pdf" || $0.pathExtension == "doc"}.sorted(by: { f1, f2 in
                return f1.creation ?? Date() > f2.creation ?? Date()
            })
            doc = docs
            filesTable.reloadData()
            //print("#####videos isss:", videos.count)
            
        } catch {
            print(error)
        }
    }
    func setTable(){
        filesTable.register(UINib(nibName: String(describing: "Filecell"), bundle: nil), forCellReuseIdentifier: "filecell")
        filesTable.dataSource = self
        filesTable.delegate = self
    }
    func openPHPicker() {
           var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
           phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.videos])
           let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
           phPickerVC.delegate = self
           present(phPickerVC, animated: true)
       }
    @objc func appleTapped(){
        openPHPicker()
    }
    @objc func googleTapped(){
        //restoreSignIn()
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            
            guard let self = self else { return }
            
            if let error = error {
                print("SignIn failed, \(error), \(error.localizedDescription)")
            } else {
                print("Authenticate successfully")
                let driveScope = "https://www.googleapis.com/auth/drive.readonly"
                guard let user = result?.user else { return }
                
                let grantedScopes = user.grantedScopes
                print("scopes: \(String(describing: grantedScopes))")
                guard let scopes = grantedScopes else{return}
                if scopes.contains(driveScope) {
                 print("Scope added")
                 print(" NEW scopes: \(String(describing: scopes))")
                 self.createGoogleDriveService(user: user)
             }
                if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
                    // Request additional Drive scope if it doesn't exist in scope.
                    user.addScopes([driveScope], presenting: self) { [weak self] result, error in
                        if let error = error {
                            print("add scope failed, \(error), \(error.localizedDescription)")
                        }
                        
                        guard let user = result?.user else { return }
                        // Check if the user granted access to the scopes you requested.
                        if let scopes = user.grantedScopes,
                           scopes.contains(driveScope) {
                            print("Scope added")
                            print(" NEW scopes: \(String(describing: scopes))")
                            self?.createGoogleDriveService(user: user)
                        }
                    }
                }
            }
        }
    }
    func createGoogleDriveService(user: GIDGoogleUser) {
        // set service type to GoogleDrive
        let service = GTLRDriveService()
        service.authorizer = user.fetcherAuthorizer
        
        // dependency inject
        stateManager.googleAPIs = GoogleDriveAPI(service: service)
        let vc = storyboard?.instantiateViewController(withIdentifier: "drivevc") as! GoogleDriveVC
        vc.stateManager = self.stateManager
        present(vc, animated: true)
        //self?.navigationController?.pushViewController(vc, animated: true)
    }
    func loginUserUsingGoogle(){
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self]result, error in
            guard let slf = self else{return}
            if let err = error{
                showAlert(slf: slf, message: err.localizedDescription)
            }else{
                print("user iss", result?.user)
            }
        }
    }
    @objc func dTapped(){
        showAlert(slf: self, message: "coming soon".localized)
    }
    @IBAction func segmChanged(){
        filesTable.reloadData()
    }
}
extension MyFilesVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filecell") as! Filecell
        cell.delegate = self
        cell.index = indexPath.row
//        let videoAsset = videos[indexPath.row]
//        
//        let resource = PHAssetResource.assetResources(for: videoAsset)
//        let filename = resource.first?.originalFilename ?? "unknown"
//        // Display video creation date
//        print("file naamee", filename)
//        cell.namelbl.text = filename
//        //"Video from \(videoAsset.creationDate ?? Date())"
//        
//        // Load video thumbnail
//        PHCachingImageManager.default().requestImage(for: videoAsset,
//                                                     targetSize: CGSize(width: 100, height: 100),
//                                                     contentMode: .aspectFill,
//                                                     options: nil) { (photo, _) in
//            
//            cell.imgView.image = photo
//        }
//        cell.sizelbl.text = getSize(asset: videoAsset)
        var url: URL?
        switch segmControl.selectedSegmentIndex{
        case 0:
            //print("all")
            url = allFiles?[indexPath.row]
            switch url?.pathExtension ?? ""{
            case "mp4", "mov":
                cell.optImgview.isHidden = false
                createVideoThumbnail(url: url) { [weak self] (img) in
                    guard let strongSelf = self else { return }
                    if let image = img {
                        cell.imgView.image = image
                    }
                }
            case "mp3":
                cell.imgView.image = UIImage(systemName: "mic.fill")
                cell.optImgview.isHidden = true
            case "jpeg", "png":
                cell.imgView.image = UIImage(contentsOfFile: url?.path ?? "")
                cell.optImgview.isHidden = true
            case "pdf", "doc":
                cell.imgView.image = UIImage(systemName: "doc.fill")
                cell.optImgview.isHidden = true
            default:
                print("thiis is document")
            }
        case 1:
            url = video?[indexPath.row]
            cell.optImgview.isHidden = false
            createVideoThumbnail(url: url) { [weak self] (img) in
                guard let strongSelf = self else { return }
                if let image = img {
                    cell.imgView.image = image
                }
            }
        case 2:
            url = image?[indexPath.row]
            cell.imgView.image = UIImage(contentsOfFile: url?.path ?? "")
            cell.optImgview.isHidden = true
        case 3:
            url = audio?[indexPath.row]
            cell.imgView.image = UIImage(systemName: "mic.fill")
            cell.optImgview.isHidden = true
        case 4:
            url = doc?[indexPath.row]
            cell.imgView.image = UIImage(systemName: "doc.fill")
            cell.optImgview.isHidden = true
        default:
            print("no")
        }
        cell.imgView.tintColor = .main
        cell.namelbl.text = url?.localizedName ?? ""
        //cell.optImgview.isHidden = !(segmControl.selectedSegmentIndex == 0)
        cell.sizelbl.text = fileSize(fromPath: url?.path ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let assetItem = videos[indexPath.row]
//        if assetItem.mediaType == .video{
//            PHCachingImageManager().requestAVAsset(forVideo: assetItem, options: nil) { [weak self](assets, audioMix, info) in
//                if let asset = assets as? AVURLAsset{
//                    DispatchQueue.main.async {
//                        self?.openVideoPlayer(url: asset.url)
//                    }
//                }else{
//                    let asset = assets as! AVComposition
//                    self?.ConvertAvcompositionToAvasset(avComp: asset) { avasset in
//                        print("conv asset isss")
//                        let asset = avasset as! AVURLAsset
//                        self?.openVideoPlayer(url: asset.url)
//                    }
//                    print("asset is avccomp")
//                }
//            }
//        }else if assetItem.mediaType == .audio{
//            // audio
//        }else{
//            // image
//        }
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var url: URL?
        switch segmControl.selectedSegmentIndex{
        case 0:
            //print("all")
            url = allFiles?[indexPath.row]
            switch url?.pathExtension ?? ""{
            case "mp4", "mov":
                guard let url = url else{return}
                openVideoPlayer(url: url)
            case "mp3":
                //print("mp3333")
                guard let url = url else{return}
                openVideoPlayer(url: url)
                //playAudio(url: url)
            case "jpeg", "png":
                print("imageeee")
            default:
                print("thiis is document")
            }
            //return allFiles?[index]
        case 1:
            url = video?[indexPath.row]
            guard let url = url else{return}
            openVideoPlayer(url: url)
        case 2:
            url = image?[indexPath.row]
            let image = UIImage(contentsOfFile: url?.path ?? "")
        case 3:
            url = audio?[indexPath.row]
            guard let url = url else{return}
            //playAudio(url: url)
            openVideoPlayer(url: url)
        case 4:
            url = doc?[indexPath.row]
            openDocument(url: url)
        default:
            print("no")
        }
    }
    func numberOfRows() -> Int{
        switch segmControl.selectedSegmentIndex{
        case 0:
            return allFiles?.count ?? 0
        case 1:
            return video?.count ?? 0
        case 2:
            return image?.count ?? 0
        case 3:
            return audio?.count ?? 0
        case 4:
            return doc?.count ?? 0
        default:
            return 0
        }
    }
    func openDocument(url: URL?){
        guard let url = url else{return}
        var documentInteractionController: UIDocumentInteractionController!
        documentInteractionController = UIDocumentInteractionController.init(url: url)
        documentInteractionController?.delegate = self
        documentInteractionController?.presentPreview(animated: true)
    }
    func openVideoPlayer(url: URL){
        print(url)
        let player = AVPlayer(url: url)
        let viewController = AVPlayerViewController()
        viewController.delegate = self
        viewController.showsPlaybackControls = true
        //viewController.allowsPictureInPicturePlayback = true
        viewController.player = player
        player.play()
        present(viewController, animated: true)
    }
    func getSize(asset: PHAsset) -> String {
        
        let resources = PHAssetResource.assetResources(for: asset)
        
        guard let resource = resources.first,
              let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong else {
            return "Unknown"
        }
        
        let sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64))
        Self.bcf.allowedUnits = [.useMB]
        Self.bcf.countStyle = .file
        return Self.bcf.string(fromByteCount: sizeOnDisk)
    }
    func ConvertAvcompositionToAvasset(avComp: AVComposition, completion:@escaping (_ avasset: AVAsset) -> Void){
        let exporter = AVAssetExportSession(asset: avComp, presetName: AVAssetExportPresetHighestQuality)
        let randNum:Int = Int(arc4random())
        //Generating Export Path
        let exportPath: NSString = NSTemporaryDirectory().appendingFormat("\(randNum)"+"video.mov") as NSString
        let exportUrl: NSURL = NSURL.fileURL(withPath: exportPath as String) as NSURL
        //SettingUp Export Path as URL
        exporter?.outputURL = exportUrl as URL
        exporter?.outputFileType = AVFileType.mov
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.exportAsynchronously(completionHandler: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                if exporter?.status == .completed {
                    let URL: URL? = exporter?.outputURL
                    let Avasset:AVAsset = AVAsset(url: URL!)
                    completion(Avasset)
                }
                else if exporter?.status == .failed{
                    print("Failed")
                    
                }
            })
        }) }
    func getUrlofAssetVideo(asset: PHAsset) -> URL?{
        var url: URL?
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (assets, audioMix, info) in
            let asset = assets as! AVURLAsset
            url = asset.url
        }
        return url
    }
    
}
extension MyFilesVC: FilecelltoVC{
    func showEditVC(index: Int) {
        print("selected isssss", index)
        guard let url = allFiles?[index] else{return}
//        let videoAsset = videos[index]
//        let resource = PHAssetResource.assetResources(for: videoAsset)
//        let filename = resource.first?.originalFilename ?? "unknown"
        let editVC = storyboard?.instantiateViewController(withIdentifier: "editvc") as! EditVideoVC
        let name = url.lastPathComponent
        editVC.videoUrl = url
        //asset.url
        editVC.videoName = name
        print("url isssssss", url)
        print("$$$$$url path", url.path)
        //editVC.modalPresentationStyle = .fullScreen
        self.present(editVC, animated: true)
//        editVC.videoAssetId = videoAsset.localIdentifier
//        PHCachingImageManager().requestAVAsset(forVideo: videoAsset, options: nil) { (assets, audioMix, info) in
//            let asset = assets as! AVURLAsset
//            DispatchQueue.main.async {[weak self] in
//                let name = filename.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                let desUrl = getDocumentsDirectory().appendingPathComponent(filename)
//                editVC.videoUrl = desUrl
//                //asset.url
//                editVC.videoName = filename
//                print("url isssssss", asset.url)
//                //editVC.modalPresentationStyle = .fullScreen
//                self?.present(editVC, animated: true)
//            }
//        }
        //print("####url issss", getUrlofAssetVideo(asset: videos[index]))
        //editVC.videoUrl = getUrlofAssetVideo(asset: videos[index])
        
    }
}
extension MyFilesVC: AVPlayerViewControllerDelegate{
    func playerViewController(_ playerViewController: AVPlayerViewController,
                              restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        present(playerViewController, animated: false) {
            completionHandler(true)
        }
    }
    
}
extension MyFilesVC: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: .none)
        guard let result = results.first else{return}
        guard let typeIdentifier = result.itemProvider.registeredTypeIdentifiers.first else {
                    print("No type identifier, aborting")
                    return
                }
        result.itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { [weak self]url, error in
            if let err = error{
                print("there are error", err.localizedDescription)
            }else{
                guard let url = url else{return}
                print("file url isssssss")
                let destinationUrl = createPath(name: url.lastPathComponent)
                if FileManager.default.fileExists(atPath: destinationUrl.path){
                    DispatchQueue.main.async {
                        showAlert(slf: self!, message: "video already exist".localized)
                    }
                }else{
                    print("no video at path")
                    try! FileManager.default.copyItem(at: url, to: destinationUrl)
                    DispatchQueue.main.async {
                        self?.getAllFiles()
                    }
                }
            }
        }
    }
}


fileprivate var aView: UIView?

extension UIViewController {
    
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
    
    func setBackgroundImage(imageName: String) {
        let bgImage = UIImage(named: imageName)
        
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = bgImage
        imageView.center = self.view.center
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
}
extension MyFilesVC: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
            return self
        }
}

extension URL {
    /// The time at which the resource was created.
    /// This key corresponds to an Date value, or nil if the volume doesn't support creation dates.
    /// A resource’s creationDateKey value should be less than or equal to the resource’s contentModificationDateKey and contentAccessDateKey values. Otherwise, the file system may change the creationDateKey to the lesser of those values.
    var creation: Date? {
        get {
            return (try? resourceValues(forKeys: [.creationDateKey]))?.creationDate
        }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.creationDate = newValue
            try? setResourceValues(resourceValues)
        }
    }
    /// The time at which the resource was most recently modified.
    /// This key corresponds to an Date value, or nil if the volume doesn't support modification dates.
    var contentModification: Date? {
        get {
            return (try? resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate
        }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.contentModificationDate = newValue
            try? setResourceValues(resourceValues)
        }
    }
    /// The time at which the resource was most recently accessed.
    /// This key corresponds to an Date value, or nil if the volume doesn't support access dates.
    ///  When you set the contentAccessDateKey for a resource, also set contentModificationDateKey in the same call to the setResourceValues(_:) method. Otherwise, the file system may set the contentAccessDateKey value to the current contentModificationDateKey value.
    var contentAccess: Date? {
        get {
            return (try? resourceValues(forKeys: [.contentAccessDateKey]))?.contentAccessDate
        }
        // Beginning in macOS 10.13, iOS 11, watchOS 4, tvOS 11, and later, contentAccessDateKey is read-write. Attempts to set a value for this file resource property on earlier systems are ignored.
        set {
            var resourceValues = URLResourceValues()
            resourceValues.contentAccessDate = newValue
            try? setResourceValues(resourceValues)
        }
    }
}
