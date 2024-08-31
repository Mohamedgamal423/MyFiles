//
//  WebviewBrowserVC.swift
//  MyFiles
//
//  Created by Moh_Sawy on 11/08/2024.
//


import Foundation
import UIKit
import WebKit
import SwiftUI
import AVKit

class BrowserStep5: UIViewController {
    lazy var configuration: WKWebViewConfiguration! = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = .audio
        configuration.allowsPictureInPictureMediaPlayback = true
        return configuration
      }()
    var webView: WKWebView = WKWebView()
    var backButton: UIBarButtonItem?
    var forwardButton: UIBarButtonItem?
    var progressBar: UIProgressView?
    var urlStr = ""
    
    
    var isPlayingVideo: Bool = false // 2
      
      var playsVideoSupportingPiP: Bool { // 3
        do {
            let jsResult = try webView.evaluateJavaScriptSync("""
    Array.from(document.querySelectorAll('video'))
      .filter(video => video.readyState != 0)
      .length
    """)
            //print("#####videoURLS isssssss", videosUrls)
          guard let videosCount = jsResult as? Int else {
            return false
          }
          return videosCount > .zero
        } catch {
          return false
        }
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
//        var imgview = UIImageView()
//        imgview.tintColor = .red
//        imgview.image = UIImage(systemName: "xmark")!.withTintColor(.red, renderingMode: .alwaysTemplate)
//        self.view.addSubview(imgview)
//        imgview.translatesAutoresizingMaskIntoConstraints = false
//        imgview.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        imgview.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        imgview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
//        imgview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
//        imgview.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
//        imgview.addGestureRecognizer(tap)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        //self.webView.topAnchor.constraint(equalTo: imgview.bottomAnchor, constant: 20).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.webView.backgroundColor = .white
        self.webView.load(URLRequest(url: URL(string: "https://www.youtube.com")!))
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        self.webView.navigationDelegate = self
        self.navigationController?.setToolbarHidden(false, animated: true)
        let downButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.down")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(downloadUrl))
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
            style: .plain,
            target: self.webView,
            action: #selector(WKWebView.goBack))
        let forwardButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.right")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
            style: .plain,
            target: self.webView,
            action: #selector(WKWebView.goForward))
        let reloadButton = UIBarButtonItem(
                   image: UIImage(systemName: "arrow.counterclockwise")!.withTintColor(.blue, renderingMode: .alwaysTemplate),
                   style: .plain,
                   target: self.webView,
                   action: #selector(WKWebView.reload))
        
        self.toolbarItems = [backButton, forwardButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), downButton,
                             UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                             reloadButton
        ]
        self.backButton = backButton
        self.forwardButton = forwardButton
        self.backButton?.isEnabled = self.webView.canGoBack
        self.forwardButton?.isEnabled = self.webView.canGoForward
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
        
        let progressView = UIProgressView(progressViewStyle: .default)
        self.progressBar = progressView
        self.view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        
        if #available(iOS 11.0, *) {
            progressView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        }
        progressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        progressView.setProgress(0.0, animated: true)
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 4)
        progressView.backgroundColor = .gray
        progressView.tintColor = .blue
        
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.title) {
            self.navigationItem.title = self.webView.title
        }
        if let _ = object as? WKWebView {
            if keyPath == #keyPath(WKWebView.canGoBack) {
                self.backButton?.isEnabled = self.webView.canGoBack
            } else if keyPath == #keyPath(WKWebView.canGoForward) {
                self.forwardButton?.isEnabled = self.webView.canGoForward
            }
        }
        if let o = object as? WKWebView, o == self.webView {
//            if keyPath == #keyPath(WKWebView.estimatedProgress) {
//                progressBar?.setProgress(Float(self.webView.estimatedProgress), animated: true)
//            }
            if keyPath == #keyPath(WKWebView.estimatedProgress), let progressView = self.progressBar {
                let newProgress = self.webView.estimatedProgress
                if Float(newProgress) > progressView.progress {
                    progressView.setProgress(Float(newProgress), animated: true)
                } else {
                    progressView.setProgress(Float(newProgress), animated: false)
                }
                if newProgress >= 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                        progressView.isHidden = true
                    })
                } else {
                    progressView.isHidden = false
                }
            }
        }
    }
    @objc func close(){
        self.navigationController?.popViewController(animated: false)
    }
    func getAllUrls(){
        let docString = try! webView.evaluateJavaScriptSync("document.documentElement.outerHTML") as! String
        print(docString)
        let regex = try! NSRegularExpression(pattern: "<a[^>]+href=\"(.*?)\"[^>]*>")
        let range = NSMakeRange(0, docString.count)
        let matches = regex.matches(in: docString, range: range)
        for match in matches {
            let htmlLessString = (docString as NSString).substring(with: match.range(at: 1))
            //print("url issssss", htmlLessString)
        }
    }
//    override public func didChangeValue(forKey key: String) { // 4
//        if key == "_isPlayingAudio" { // 5
//            isPlayingVideo = playsVideoSupportingPiP
//        }
//      }

    
    @objc func downloadUrl(){
        //getAllUrls()
        //print("url str isss", urlStr)
        let jsResult = try! webView.evaluateJavaScriptSync("""
Array.from(document.querySelectorAll('video'))
  .filter(video => video.readyState != 0)[0].src
""")
        let jsResult2 = try! webView.evaluateJavaScriptSync("""
var yt=document.getElementById("movie_player"); 
yt.getPlayerState();
""")
//        let jsResult2 = try! webView.evaluateJavaScriptSync("""
//var yt=document.getElementById("movie_player");
//var data=yt.getVideoData();
//var text=data["title"] + " " + "https://youtu.be/"+data["video_id"]+"?t="+Math.floor(yt.getCurrentTime())
//""")
        print("jsonresult", jsResult2)
        let str = jsResult as! String
        urlStr = str.detectedFirstURL ?? ""
        print("is playing video:::: \(isPlayingVideo),,,, issplayvideopip::::: \(playsVideoSupportingPiP)")
        let st = UIStoryboard(name: "Main", bundle: nil)
        let optionvc = st.instantiateViewController(withIdentifier: "option") as! DownloadOptionVC
        optionvc.strUrl = urlStr
        optionvc.modalPresentationStyle = .overFullScreen
        present(optionvc, animated: true)
    }
}
extension BrowserStep5: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript(
            "document.title"
        ) { (result, error) -> Void in
            self.navigationItem.title = result as? String
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url?.absoluteString {
            print("@@@@@url", url)
            self.urlStr = url
        }

        decisionHandler(.allow)
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:#selector(playerItemBecameCurrent), name:NSNotification.Name(rawValue: "AVPlayerItemBecameCurrentNotification"), object:nil)
    }
    @objc func playerItemBecameCurrent(notification:NSNotification){
        let playerItem:AVPlayerItem = notification.object as! AVPlayerItem
        let asset:AVURLAsset=playerItem.asset as! AVURLAsset
        let url = asset.url
        let path = url.absoluteString
        print("&&&&&&&&&path", path)

    }
}

extension WKWebView {
  func evaluateJavaScriptSync(_ javaScriptString: String, inFrame frame: WKFrameInfo? = nil) throws -> Any? {
    var result: Any? = nil
    var error: Error? = nil

    var waiting = true

    self.evaluateJavaScript(javaScriptString, in: frame, in: .page) { r in
      switch r {
      case .success(let r): result = r
      case .failure(let e): error = e
      }
      waiting = false
    }

    while waiting {
      RunLoop.current.acceptInput(forMode: RunLoop.Mode.default, before: Date.distantFuture)
    }

    if let error = error {
      throw error
    }

    return result
  }
}

class DataDetector {

    private class func _find(all type: NSTextCheckingResult.CheckingType,
                             in string: String, iterationClosure: (String) -> Bool) {
        guard let detector = try? NSDataDetector(types: type.rawValue) else { return }
        let range = NSRange(string.startIndex ..< string.endIndex, in: string)
        let matches = detector.matches(in: string, options: [], range: range)
        loop: for match in matches {
            for i in 0 ..< match.numberOfRanges {
                let nsrange = match.range(at: i)
                let startIndex = string.index(string.startIndex, offsetBy: nsrange.lowerBound)
                let endIndex = string.index(string.startIndex, offsetBy: nsrange.upperBound)
                let range = startIndex..<endIndex
                guard iterationClosure(String(string[range])) else { break loop }
            }
        }
    }

    class func find(all type: NSTextCheckingResult.CheckingType, in string: String) -> [String] {
        var results = [String]()
        _find(all: type, in: string) {
            results.append($0)
            return true
        }
        return results
    }

    class func first(type: NSTextCheckingResult.CheckingType, in string: String) -> String? {
        var result: String?
        _find(all: type, in: string) {
            result = $0
            return false
        }
        return result
    }
}

// MARK: String extension

extension String {
    var detectedLinks: [String] { DataDetector.find(all: .link, in: self) }
    var detectedFirstLink: String? { DataDetector.first(type: .link, in: self) }
    var detectedURLs: [URL] { detectedLinks.compactMap { URL(string: $0) } }
    var detectedFirstURL: String? {
        guard let urlString = detectedFirstLink else { return nil }
        return urlString
        //return URL(string: urlString)
    }
}
