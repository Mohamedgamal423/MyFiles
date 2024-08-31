//
//  DownloadProgressVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 16/06/2024.
//

import UIKit
import Lottie

class DownloadProgressVC: UIViewController {
    
    @IBOutlet weak var progressView: LottieAnimationView!
    @IBOutlet weak var progressStatusLabel: UILabel!
    
    var model = DownloadViewModel()
    var delegate: FinishedDownload?
    var stateManager: StateManager!
    
    var googleAPIs: GoogleDriveAPI? {
        get { stateManager.googleAPIs }
    }
    var urlStr: String?
    var filetitle: String?
    var type = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.contentMode = .scaleAspectFit
        model.title = filetitle
        setupNotifications()
        progressStatusLabel.text = "Starting download...".localized
        startProgress()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("cancling downloaddddddd")
        model.cancelDownload()
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        startProgress()
//    }
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(setProgress(_:)), name: Notification.Name(notificationKey), object: nil)
    }
    @objc func setProgress(_ notification: NSNotification){
        if notification.object != nil{
            let progress = notification.object as! Float
            //print("@@@@@@reload progress data", progress)
            DispatchQueue.main.async {[weak self] in
                self?.setProgress(to: CGFloat(progress))
            }
        }else{
            print("no object stp downloadddddd")
            DispatchQueue.main.async {[weak self] in
                self?.endDownload()
            }
        }
        
    }
    private func setProgress(to progress: CGFloat) {

      // 1. We get the range of frames specific for the progress from 0-100%
      
      let progressRange = ProgressKeyFrames.end.rawValue - ProgressKeyFrames.start.rawValue
      
      // 2. Then, we get the exact frame for the current progress
      
      let progressFrame = progressRange * progress
      
      // 3. Then we add the start frame to the progress frame
      // Considering the example that we start in 140, and we moved 30 frames in the progress, we should show frame 170 (140+30)
      
      let currentFrame = progressFrame + ProgressKeyFrames.start.rawValue
      
      // 4. Manually setting the current animation frame
      
      progressView?.currentFrame = currentFrame
      
      print("Downloading \((progress*100).rounded())%")
        progressStatusLabel.text = "\("Downloading".localized) \((progress*100).rounded())%"
      
    }
    
    private func startProgress() {
        
        progressView.play(fromFrame: 0, toFrame: ProgressKeyFrames.start.rawValue, loopMode: .none) { [weak self] (_) in
            guard let slf = self else{return}
            guard let inurlstr = slf.urlStr else{return}
            let url = URL(string: inurlstr)!
            slf.model.downloadVideo(url: url, type: slf.type)
            //slf.model.downloadVideo(strUlr: inurlstr)
        }
        
    }
    
    // progress from 0 to 100%
    
    private func startDownload() {
        
        // play animation from start to end of download progress
        
        progressView.play(fromFrame: ProgressKeyFrames.start.rawValue, toFrame: ProgressKeyFrames.end.rawValue, loopMode: .none) { [weak self] (_) in
            
            self?.endDownload()
            
        }
        
    }
    
    // download is completed, we show the completion state
    
    private func endDownload() {
        
        // download is completed, we show the completion state
        progressStatusLabel.text = "Download finished".localized
        progressView?.play(fromFrame: ProgressKeyFrames.end.rawValue, toFrame: ProgressKeyFrames.complete.rawValue, loopMode: .none)
        dismiss(animated: false) {[weak self] in
            self?.delegate?.didFinished()
        }
    }
    
}
enum ProgressKeyFrames: CGFloat {
    
    case start = 140
    
    case end = 187
    
    case complete = 240
    
}

protocol FinishedDownload{
    func didFinished()
}
