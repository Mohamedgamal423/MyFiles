//
//  EditVideoVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 01/06/2024.
//

import UIKit
import AVKit
import SCSDKCreativeKit
import Lottie

class EditVideoVC: UIViewController {
    
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var optionsCV: UICollectionView!
    
    var editVideoData: [ResProfileData]!
    var videoUrl: URL?
    var videoName: String?
    var videoAssetId: String?
    var model = DownloadViewModel()
    var snapAPI: SCSDKSnapAPI?
    private var animView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setCV()
        setData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reloadData()
    }
    func setData(){
        editVideoData = [ResProfileData(name: "Rename".localized, subname: "", icon: "rename", handler: {[weak self] in
            self?.showRenameAlert()
        }),
                         ResProfileData(name: "Send to TikTok".localized, subname: "", icon: "tik", handler: {[weak self] in
            self?.uploadVideoTiktok()
            //showAlert(slf: self!, message: "coming soon".localized)
        }),
                         ResProfileData(name: "Send to Snapchat".localized, subname: "", icon: "snap", handler: {[weak self] in
            //self?.uploadVideoSnap()
            self?.shareSnap()
        }),
                         ResProfileData(name: "Remove Music".localized, subname: "", icon: "music", handler: {[weak self] in
            guard let slf = self else{return}
            //slf.animView = slf.addAnimation()
            //slf.animView?.play()
            slf.removeAudioFromVideo(slf.videoUrl!)
        }),
                         ResProfileData(name: "Change Video Speed".localized, subname: "", icon: "meter", handler: {[weak self] in
            self?.changeVideoSpeed()
        }),
//                         ResProfileData(name: "Disable Audio".localized, subname: "", icon: "mute", handler: {[weak self] in
//            //
//        }),
                         ResProfileData(name: "Type on Video".localized, subname: "", icon: "video", handler: {[weak self] in
            //self?.typeVideo()
            showAlert(slf: self!, message: "coming soon".localized)
        }),
                         ResProfileData(name: "Delete".localized, subname: "", icon: "delete", handler: {[weak self] in
            self?.delete()
        })]
    }
    func setView(){
        snapAPI = SCSDKSnapAPI()
        contView.applyCornerRadius(radius: 6)
    }
    func setCV(){
        optionsCV.dataSource = self
        optionsCV.delegate = self
        optionsCV.register(UINib(nibName: String(describing: "OptionCell"), bundle: nil), forCellWithReuseIdentifier: "optioncell")
        optionsCV.register(UINib(nibName: String(describing: "EditHeader"), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "editheader")
    }
    func delete(){
        let alert = UIAlertController(title: "", message: "are you sure about delete this file?".localized, preferredStyle: .alert)
        let delete = UIAlertAction(title: "delete".localized, style: .default) {[weak self] _ in
            guard let slf = self else{return}
            if FileManager.default.fileExists(atPath: slf.videoUrl?.path ?? "") {
                // delete file
                do {
                    try FileManager.default.removeItem(atPath: slf.videoUrl?.path ?? "")
                    CoreDataManager.shared.deleteFile(name: slf.videoName ?? "")
                    showAlert(slf: slf, message: "deleted file successfully".localized)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        slf.dismiss(animated: false)
                    }
                } catch let err {
                    showAlert(slf: slf, message: "can not delete this file".localized)
                }
            }
        }
        let cancel = UIAlertAction(title: "cancel".localized, style: .destructive)
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    func changeVideoSpeed(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "speedvc") as! SpeedChangeVC
        vc.videoUrl = videoUrl
        vc.videoName = videoName
        //vc.popoverPresentationController?.sourceView = vc.view
        //vc.modalPresentationStyle = .
        self.present(vc, animated: true)
    }
    func showRenameAlert(){

        guard let fileName = videoName else{return}
        let name = String(fileName.split(separator: ".").first!)
        let exten = String(fileName.split(separator: ".").last!)
        print("name issss \(name),,, ext issss \(exten)")
        let alert = UIAlertController(title: "type new name".localized, message: nil, preferredStyle: .alert)
        alert.addTextField()
        guard let txtfield = alert.textFields?.first else{return}
        txtfield.text = name
        let ok = UIAlertAction(title: "ok".localized, style: .default) { [weak self]_ in
            guard let slf = self else{return}
            guard let newName = txtfield.text, newName != "" else{
                showAlert(slf: slf, message: "please enter valid name".localized)
                return
            }
            let fname = "\(newName).\(exten)"
            self?.rename(name: fname)
        }
        let cancel = UIAlertAction(title: "cancel".localized, style: .destructive)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    func rename(name: String){
        renameFile(newName: name, oldName: videoName ?? "") { [weak self]success, error in
            guard let slf = self else{return}
            if success{
                CoreDataManager.shared.renameFile(newName: name, oldName: slf.videoName ?? "")
                showAlert(slf: slf, message: "renamed file successfully".localized)
            }else{
                showAlert(slf: slf, message: error?.localizedDescription)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                slf.dismiss(animated: false)
            }
        }
    }
    func reloadData(){
        NotificationCenter.default.post(name: Notification.Name(reloadKey), object: nil)
    }
    func uploadVideoSnap(){
        guard let url = videoUrl else{
            showAlert(slf: self, message: "no url video")
            return
        }
        print("snap url isssss", url)
        self.view.isUserInteractionEnabled = false
        SocialHelper.shared.uploadVideotoSnap(url: url){[weak self]err in
            print("error after completion", err)
            self?.view.isUserInteractionEnabled = true
        }
    }
    func shareSnap() {
        guard let url = videoUrl else{
            showAlert(slf: self, message: "no url video")
            return
        }
        //guard let stickerImage = UIImage.init(named: "sticker") else {return}
        //let sticker = SCSDKSnapSticker(stickerImage: stickerImage)
        let video = SCSDKSnapVideo(videoUrl: url)
        let videoContent = SCSDKVideoSnapContent(snapVideo: video)
        
        //videoContent.sticker = sticker
        //videoContent.caption = "Matrix Solution"
        //videoContent.attachmentUrl = "https://matrixsolution.xyz/"
        print("video url", url)
        //disable user interaction until the share is over.
        view.isUserInteractionEnabled = false
        snapAPI?.startSending(videoContent) { [weak self] (error: Error?) in
            print("error", error)
          self?.view.isUserInteractionEnabled = true
          // Handle response
        }
        }
    func uploadVideoTiktok(){
        guard let url = videoUrl else{
            showAlert(slf: self, message: "no url video")
            return
        }
        //SocialHelper.shared.uploadVideoTiktok(url: url, assetId: videoAssetId ?? "")
        dismiss(animated: true) {
            SocialHelper.shared.uploadVideoTiktok(url: url, assetId: self.videoAssetId ?? "")
        }
    }
    //var mutableVideoURL = NSURL()
    func removeAudioFromVideo(_ videoURL: URL) {
        animView = addAnimation()
        animView?.play()
        let inputVideoURL: URL = videoURL
        let sourceAsset = AVURLAsset(url: inputVideoURL)
        let sourceVideoTrack: AVAssetTrack? = sourceAsset.tracks(withMediaType: AVMediaType.video)[0]
        let composition : AVMutableComposition = AVMutableComposition()
        let compositionVideoTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let x: CMTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: sourceAsset.duration)
        _ = try? compositionVideoTrack!.insertTimeRange(x, of: sourceVideoTrack!, at: CMTime.zero)
        guard let fileName = videoName else{return}
        let name = String(fileName.split(separator: ".").first!)
        let exten = String(fileName.split(separator: ".").last!)
        
        let finalName = "\(name) \("removed Music").\(exten)"
        print("final name issssss", finalName)
        //let name = videoName?.replacingOccurrences(of: ".mp4", with: " speed (\(speed))")
        //let savePath = (documentDirectory as NSString).appendingPathComponent("\(name ?? "")-\(date).mp4")
        let pathUrl = createPath(name: finalName)
        print("save path is", pathUrl)
        //mutableVideoURL = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/\(videoName ?? "")removed Music.mp4")
        let exporter: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputFileType = AVFileType.mp4
        exporter.outputURL = pathUrl
        //mutableVideoURL as URL
        removeFileAtURLIfExists(url: pathUrl as NSURL)
        //removeFileAtURLIfExists(url: mutableVideoURL)
        //self.animView?.removeFromSuperview()
        exporter.exportAsynchronously(completionHandler:
                                        {[weak self] in
            guard let slf = self else{return}
            switch exporter.status
            {
            case AVAssetExportSession.Status.failed:
                print("failed \(exporter.error)")
            case AVAssetExportSession.Status.cancelled:
                print("cancelled \(exporter.error)")
            case AVAssetExportSession.Status.unknown:
                print("unknown\(exporter.error)")
            case AVAssetExportSession.Status.waiting:
                print("waiting\(exporter.error)")
            case AVAssetExportSession.Status.exporting:
                print("exporting\(exporter.error)")
            default:
                print("-----Mutable video exportation complete.")
                guard let url = exporter.outputURL else {
                    print("ERROR")
                    return
                }
                print("exported url issss", url)
                DispatchQueue.main.async {
                    slf.animView?.removeFromSuperview()
                    showAlert(slf: slf, message: "removed music success and saved".localized)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    slf.dismiss(animated: false)
                }
            }
        })
    }

        func removeFileAtURLIfExists(url: NSURL) {
            if let filePath = url.path {
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    do{
                        try fileManager.removeItem(atPath: filePath)
                    } catch let error as NSError {
                        print("Couldn't remove existing destination file: \(error)")
                    }
                }
            }
        }
    func typeVideo(){
        
            let composition = AVMutableComposition()
        let vidAsset = AVURLAsset(url: videoUrl!, options: nil)

            // get video track
            let vtrack =  vidAsset.tracks(withMediaType: AVMediaType.video)
            let videoTrack: AVAssetTrack = vtrack[0]
            let vid_timerange = CMTimeRangeMake(start: CMTime.zero, duration: vidAsset.duration)

            let tr: CMTimeRange = CMTimeRange(start: CMTime.zero, duration: CMTime(seconds: 10.0, preferredTimescale: 600))
            composition.insertEmptyTimeRange(tr)

            let trackID:CMPersistentTrackID = CMPersistentTrackID(kCMPersistentTrackID_Invalid)

            if let compositionvideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: trackID) {

                do {
                    try compositionvideoTrack.insertTimeRange(vid_timerange, of: videoTrack, at: CMTime.zero)
                } catch {
                    print("error")
                }

                compositionvideoTrack.preferredTransform = videoTrack.preferredTransform

            } else {
                print("unable to add video track")
                return
            }


            // Watermark Effect
            let size = videoTrack.naturalSize

            let imglogo = UIImage(named: "image.png")
            //let imglayer = CALayer()
            //imglayer.contents = imglogo?.cgImage
            //imglayer.frame = CGRect(x: 5, y: 5, width: 100, height: 100)
            //imglayer.opacity = 0.6

            // create text Layer
            let titleLayer = CATextLayer()
            titleLayer.backgroundColor = UIColor.white.cgColor
            titleLayer.string = "Dummy text"
            titleLayer.font = UIFont(name: "Helvetica", size: 28)
            titleLayer.shadowOpacity = 0.5
            titleLayer.alignmentMode = CATextLayerAlignmentMode.center
            titleLayer.frame = CGRect(x: 0, y: 50, width: size.width, height: size.height / 6)


            let videolayer = CALayer()
            videolayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            let parentlayer = CALayer()
            parentlayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            parentlayer.addSublayer(videolayer)
            //parentlayer.addSublayer(imglayer)
            parentlayer.addSublayer(titleLayer)

            let layercomposition = AVMutableVideoComposition()
            layercomposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
            layercomposition.renderSize = size
            layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videolayer, in: parentlayer)

            // instruction for watermark
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: composition.duration)
            let videotrack = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
            let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
            instruction.layerInstructions = NSArray(object: layerinstruction) as [AnyObject] as! [AVVideoCompositionLayerInstruction]
            layercomposition.instructions = NSArray(object: instruction) as [AnyObject] as! [AVVideoCompositionInstructionProtocol]

            //  create new file to receive data
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir = dirPaths[0] as NSString
            let movieFilePath = docsDir.appendingPathComponent("result.mp4")
            let movieDestinationUrl = NSURL(fileURLWithPath: movieFilePath)

            // use AVAssetExportSession to export video
            let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality)
            assetExport?.outputFileType = AVFileType.mov
            assetExport?.videoComposition = layercomposition

            // Check exist and remove old file
            //FileManager.default.removeItemIfExisted(movieDestinationUrl as URL)

            assetExport?.outputURL = movieDestinationUrl as URL
            assetExport?.exportAsynchronously(completionHandler: {
                switch assetExport!.status {
                case AVAssetExportSession.Status.failed:
                    print("failed")
                    print(assetExport?.error ?? "unknown error")
                case AVAssetExportSession.Status.cancelled:
                    print("cancelled")
                    print(assetExport?.error ?? "unknown error")
                default:
                    print("Movie complete")

                    let url = movieDestinationUrl as URL
                    self.model.saveVideoToAlbum(videoURL: url, albumName: "Video Plant") {succ, err in
                        if succ{
                            showAlert(slf: self, message: "removed music success and saved to gallery".localized)
                        }else{
                            showAlert(slf: self, message: "error saved to gallery with error:: \(err?.localizedDescription ?? "")")
                        }
                    }
                }
            })
    }
}
extension EditVideoVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editVideoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = optionsCV.dequeueReusableCell(withReuseIdentifier: "optioncell", for: indexPath) as! OptionCell
        cell.config(model: editVideoData[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 4) - 10, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = editVideoData[indexPath.row]
        model.handler()
    }
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "editheader", for: indexPath) as! EditHeader
//        return header
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 40)
//    }
}
