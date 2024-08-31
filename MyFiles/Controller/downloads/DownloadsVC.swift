//
//  DownloadsVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 26/05/2024.
//

import UIKit
import AVFAudio
import AVFoundation
import AVKit
import SCSDKCreativeKit

class DownloadsVC: UIViewController {

    @IBOutlet weak var downloadsTable: UITableView!
    var files = [DownloadedFile]()
    
    var player: AVAudioPlayer!
    var snapAPI: SCSDKSnapAPI?
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        snapAPI = SCSDKSnapAPI()
        //didPressVideoShareButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    func didPressVideoShareButton(url: URL) {
            if let videoUrl = Bundle.main.url(forResource: "video", withExtension: "mp4") {
                
                //guard let stickerImage = UIImage.init(named: "sticker") else {return}
                //let sticker = SCSDKSnapSticker(stickerImage: stickerImage)
                let video = SCSDKSnapVideo(videoUrl: url)
                let videoContent = SCSDKVideoSnapContent(snapVideo: video)
                
                //videoContent.sticker = sticker
                //videoContent.caption = "Matrix Solution"
                //videoContent.attachmentUrl = "https://matrixsolution.xyz/"
                print("locl video url", videoUrl)
                print("video url", url)
                //disable user interaction until the share is over.
                view.isUserInteractionEnabled = false
                snapAPI?.startSending(videoContent) { [weak self] (error: Error?) in
                    print("error", error)
                  self?.view.isUserInteractionEnabled = true
                  // Handle response
                }
            }else{
                print("no video with this name")
            }
        }
    func setTable(){
        downloadsTable.register(UINib(nibName: String(describing: "Downloadcell"), bundle: nil), forCellReuseIdentifier: "downloadcell")
        downloadsTable.dataSource = self
        downloadsTable.delegate = self
    }
    func getData(){
        files = CoreDataManager.shared.getAllFiles().reversed()
        downloadsTable.reloadData()
    }

}
extension DownloadsVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "downloadcell") as! Downloadcell
        let file = files[indexPath.row]
        let desUrl = getDocumentsDirectory().appendingPathComponent(file.name ?? "")
        print("des url cell", desUrl)
        cell.namelbl.text = file.name ?? ""
        cell.sizelbl.text = fileSize(fromPath: desUrl.path) ?? ""
        cell.datelbl.text = (file.date ?? Date()).getStrFromDatae()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = files[indexPath.row]
        let name = file.name?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let desUrl = getDocumentsDirectory().appendingPathComponent(file.name ?? "")
        openVideoPlayer(url: desUrl)
        //didPressVideoShareButton(url: desUrl)
//        if Int(file.type) == 1{
//            openVideoPlayer(url: desUrl)
//        }else{
//            print("audio desUrl issssss", desUrl)
//            playAudio(url: desUrl)
//        }
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
//    func fileSize(fromPath path: String) -> String? {
//        guard let size = try? FileManager.default.attributesOfItem(atPath: path)[FileAttributeKey.size],
//            let fileSize = size as? UInt64 else {
//            return nil
//        }
//
//        // bytes
//        if fileSize < 1023 {
//            return String(format: "%lu bytes", CUnsignedLong(fileSize))
//        }
//        // KB
//        var floatSize = Float(fileSize / 1024)
//        if floatSize < 1023 {
//            return String(format: "%.1f KB", floatSize)
//        }
//        // MB
//        floatSize = floatSize / 1024
//        if floatSize < 1023 {
//            return String(format: "%.1f MB", floatSize)
//        }
//        // GB
//        floatSize = floatSize / 1024
//        return String(format: "%.1f GB", floatSize)
//    }

    
}
extension DownloadsVC: AVPlayerViewControllerDelegate{
    func playerViewController(_ playerViewController: AVPlayerViewController,
                              restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        present(playerViewController, animated: false) {
            completionHandler(true)
        }
    }
    
}
