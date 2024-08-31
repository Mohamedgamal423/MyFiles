//
//  SpeedChangeVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 17/06/2024.
//

import UIKit
import AVFoundation
import Lottie

class SpeedChangeVC: UIViewController {

    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var speedTable: UITableView!
    @IBOutlet weak var changelbl: UILabel!
    @IBOutlet weak var hintlbl: UILabel!
    
    var speedData = [SpeedChangeData]()
    var videoUrl: URL?
    var videoName: String?
    var model = DownloadViewModel()
    private var animView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        setData()
        videoUrl?.hasHiddenExtension = true
        print("video url speedddddd", videoUrl)
        print(videoName)
    }
    func setTable(){
        speedTable.dataSource = self
        speedTable.delegate = self
        contView.applyCornerRadius(radius: 10)
    }
    func setData(){
        speedData = [
            SpeedChangeData(name: "\("Fast".localized)(1.5)", handler: {[weak self] in
                guard let slf = self else{return}
                print("old url issss", slf.videoUrl)
                slf.speedUpVideo(url: slf.videoUrl!, speed: 1.5)
            }),
            SpeedChangeData(name: "\("Fast".localized)(1.25)", handler: {[weak self] in
                guard let slf = self else{return}
                slf.speedUpVideo(url: slf.videoUrl!, speed: 1.25)
            }),
            SpeedChangeData(name: "Custom".localized, handler: {[weak self] in
                guard let slf = self else{return}
                print("old url issss", slf.videoUrl)
                slf.showAlertTxt()
            }),
            SpeedChangeData(name: "\("Slow".localized)(0.8)", handler: {[weak self] in
                guard let slf = self else{return}
                print("old url issss", slf.videoUrl)
                slf.speedUpVideo(url: slf.videoUrl!, speed: 0.8)
            }),
            SpeedChangeData(name: "\("Slow".localized)(0.6)", handler: {[weak self] in
                guard let slf = self else{return}
                print("old url issss", slf.videoUrl)
                slf.speedUpVideo(url: slf.videoUrl!, speed: 0.6)
            })
        ]
    }
    private func speedUpVideo(url: URL, speed: Float) {
        animView = addAnimation()
        animView?.play()
            do {
                let asset = AVAsset(url: url)
                
                guard let videoTrack = asset.tracks(withMediaType: .video).first else { return }
                guard let audioTrack = asset.tracks(withMediaType: .audio).first else { return }
                
                let speedComposition = AVMutableComposition()
                let speedVideoTrack = speedComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
                let speedAudioTrack = speedComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
                
                speedVideoTrack?.preferredTransform = videoTrack.preferredTransform
                
                let assetTimeRange = CMTimeRange(start: .zero, duration: asset.duration)
                
                try speedVideoTrack?.insertTimeRange(assetTimeRange, of: videoTrack, at: .zero)
                try speedAudioTrack?.insertTimeRange(assetTimeRange, of: audioTrack, at: .zero)
                let rate: Float64 = Float64(1 / speed)
                //let str = String(format: "%.1f", rate)
                print("rate issssss", rate)
                print("speed issssss", speed)
                //print("str issssss", str)
                //let frate = Float64(Float(str) ?? 0)
                //print("frate issssss", frate)
                let newDuration = CMTimeMultiplyByFloat64(assetTimeRange.duration, multiplier: rate)
                
                speedVideoTrack?.scaleTimeRange(assetTimeRange, toDuration: newDuration)
                speedAudioTrack?.scaleTimeRange(assetTimeRange, toDuration: newDuration)
                
                //let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateStyle = .long
//                dateFormatter.timeStyle = .long
//                let date = dateFormatter.string(from: NSDate() as Date)
                
                guard let fileName = videoName else{return}
                let name = String(fileName.split(separator: ".").first!)
                let exten = String(fileName.split(separator: ".").last!)
                
                let finalName = "\(name) \("speed") \(speed).\(exten)"
                print("final name issssss", finalName)
                //let name = videoName?.replacingOccurrences(of: ".mp4", with: " speed (\(speed))")
                //let savePath = (documentDirectory as NSString).appendingPathComponent("\(name ?? "")-\(date).mp4")
                let pathUrl = createPath(name: finalName)
                print("save path is", pathUrl)
                //let url = NSURL(fileURLWithPath: savePath)
                
                guard let exporter = AVAssetExportSession(asset: speedComposition, presetName: AVAssetExportPreset1920x1080) else { return }
                exporter.outputURL = pathUrl
                exporter.outputFileType = .mp4
                exporter.shouldOptimizeForNetworkUse = true
                exporter.exportAsynchronously {[weak self] in
                    guard let slf = self else{return}
                    guard let url = exporter.outputURL else {
                        print("ERROR")
                        return
                    }
                    print("exported url issss", url)
                    DispatchQueue.main.async {
                        slf.animView?.removeFromSuperview()
                        showAlert(slf: slf, message: "speed changed success and saved".localized)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        slf.dismiss(animated: false)
                    }
                }
            } catch let err {
                showAlert(slf: self, message: err.localizedDescription)
                print("ERRRRROOORRRR")
            }
        }
    func showAlertTxt(){
        let ac = UIAlertController(title: "Enter Custom speed".localized, message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "submit".localized, style: .default) {[unowned ac] _ in
            let speedtxt = ac.textFields![0]
            guard let speed = speedtxt.text, speed != "" else{
                showAlert(slf: self, message: "please enter speed ratio".localized)
                return
            }
            if let speednum = Double(speed){
                self.speedUpVideo(url: self.videoUrl!, speed: Float(speednum))
            }else{
                showAlert(slf: self, message: "please enter valid number".localized)
                return
            }
            
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }

}
extension SpeedChangeVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return speedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = speedData[indexPath.row].name
        cell.textLabel?.textAlignment = .center
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = speedData[indexPath.row]
        model.handler()
    }
    
}
struct SpeedChangeData{
    let name: String
    let handler: () ->()
}
