//
//  AllFilesVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 01/07/2024.
//

import UIKit
import AVFoundation
import AVKit
import Photos

class AllFilesVC: UIViewController {

    @IBOutlet weak var filesTable: UITableView!
    @IBOutlet weak var segmControl: UISegmentedControl!
    
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
    }
    func setView(){
        segmControl.setTitle("All".localized, forSegmentAt: 0)
        segmControl.setTitle("Video".localized, forSegmentAt: 1)
        segmControl.setTitle("Image".localized, forSegmentAt: 2)
        segmControl.setTitle("Audio".localized, forSegmentAt: 3)
        segmControl.setTitle("Documents".localized, forSegmentAt: 4)
    }
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
                includingPropertiesForKeys: nil
            )
            print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
//            for url in directoryContents {
//                //print(url.localizedName ?? url.lastPathComponent)
//
//            }
//            // if you would like to hide the file extension
//            for var url in directoryContents {
//                url.hasHiddenExtension = true
//            }
            //directoryContents.map{try! FileManager.default.removeItem(at: $0)}
            allFiles = directoryContents
            // if you want to get all mp3 files located at the documents directory:
            let mp3s = directoryContents.filter {$0.pathExtension == "mp3"}
            //directoryContents.filter(\.isMP3).map { $0.localizedName ?? $0.lastPathComponent }
            //print("$$$$$$mp3skkkkkk:", mp3s)
            audio = mp3s
            let videos = directoryContents.filter {$0.pathExtension == "mp4" || $0.pathExtension == "mov"}
            video = videos
            let photos = directoryContents.filter {$0.pathExtension == "jpeg" || $0.pathExtension == "png"}
            image = photos
            let docs = directoryContents.filter {$0.pathExtension == "pdf" || $0.pathExtension == "doc"}
            doc = docs
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
    @IBAction func segmChanged(){
        filesTable.reloadData()
    }
}
extension AllFilesVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filecell") as! Filecell
        //cell.delegate = self
        cell.index = indexPath.row
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
    func getRow(index: Int) -> (URL?, Int){
        let index = segmControl.selectedSegmentIndex
        switch index{
        case 0:
            return (allFiles?[index], index)
        case 1:
            return (video?[index], index)
        case 2:
            return (image?[index], index)
        case 3:
            return (audio?[index], index)
        case 4:
            return (doc?[index], index)
        default:
            return (nil, 0)
        }
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
    func playAudio(url: URL) {
        var player: AVAudioPlayer!
        do {
            //let item = AVPlayerItem(url: url)
            //let playerItem = AVPlayerItem(url: URL(string: url)!)
            //player = AVPlayer(playerItem: item)
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else{return}
            player.numberOfLoops = 0 // loop count, set -1 for infinite
            player.volume = 1
            player.prepareToPlay()
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            
            player.play()
        } catch let err {
            print("error is", err.localizedDescription)
        }
    }
    func openDocument(url: URL?){
        guard let url = url else{return}
        var documentInteractionController: UIDocumentInteractionController!
        documentInteractionController = UIDocumentInteractionController.init(url: url)
        documentInteractionController?.delegate = self
        documentInteractionController?.presentPreview(animated: true)
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
        })
    }
}

extension AllFilesVC: AVPlayerViewControllerDelegate{
    func playerViewController(_ playerViewController: AVPlayerViewController,
                              restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        present(playerViewController, animated: false) {
            completionHandler(true)
        }
    }
    
}
extension AllFilesVC: FilecelltoVC{
    func showEditVC(index: Int) {
//        print("selected isssss", index)
//        let videoAsset = videos[index]
//        let resource = PHAssetResource.assetResources(for: videoAsset)
//        let filename = resource.first?.originalFilename ?? "unknown"
//        let editVC = storyboard?.instantiateViewController(withIdentifier: "editvc") as! EditVideoVC
//        editVC.videoAssetId = videoAsset.localIdentifier
//        PHCachingImageManager().requestAVAsset(forVideo: videoAsset, options: nil) { (assets, audioMix, info) in
//            let asset = assets as! AVURLAsset
//            DispatchQueue.main.async {[weak self] in
//                editVC.videoUrl = asset.url
//                editVC.videoName = filename
//                print("url isssssss", asset.url)
//                self?.present(editVC, animated: true)
//            }
//        }
        //print("####url issss", getUrlofAssetVideo(asset: videos[index]))
        //editVC.videoUrl = getUrlofAssetVideo(asset: videos[index])
        
    }
}

extension AllFilesVC: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
            return self
        }
}

extension URL {
    var typeIdentifier: String? { (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier }
    var isMP3: Bool { typeIdentifier == "public.mp3" }
    var isVideo: Bool { typeIdentifier == "sdd.mp4" }
    var localizedName: String? { (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName }
    var hasHiddenExtension: Bool {
        get { (try? resourceValues(forKeys: [.hasHiddenExtensionKey]))?.hasHiddenExtension == true }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.hasHiddenExtension = newValue
            try? setResourceValues(resourceValues)
        }
    }
}

