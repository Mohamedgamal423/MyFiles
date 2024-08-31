//
//  SocialHelper.swift
//  MyFiles
//
//  Created by Moh_Sawy on 20/06/2024.
//

import Foundation
import SCSDKCreativeKit
import TikTokOpenShareSDK
import Photos

class SocialHelper{
    static let shared = SocialHelper()
    private var localVideoIdentifier: String?
    func uploadVideotoSnap(url: URL, completion: @escaping(_ err: Error?) -> ()){
        let snapAPI = SCSDKSnapAPI()
        let video = SCSDKSnapVideo(videoUrl: url)
        let content = SCSDKVideoSnapContent(snapVideo: video)
        print("video content issss", content)
//        snapAPI.startSending(content) { [weak self] (error: Error?) in
//            print("error is", error?.localizedDescription)
//        }
        snapAPI.startSending(content) { err in
            print("thre are error  snapchat uploading", err)
            completion(err)
        }
    }
    func uploadVideoTiktok(url: URL, assetId: String){
        if let videoId = DownloadViewModel().getVideoIdentifier(videoUrl: url){
            DispatchQueue.main.async {
                let shareRequest = TikTokShareRequest(localIdentifiers: [videoId],
                                                      mediaType: .video,
                                                      redirectURI: "https://videoplant.dynalinks.app/tiktok")
                shareRequest.send { response in
                    guard let shareRes = response as? TikTokShareResponse else{return}
                    if shareRes.errorCode == .noError {
                        print("Share succeeded!")
                    } else {
                        print("Share Failed! Error Code: \(shareRes.errorCode.rawValue) Error Message: \(shareRes.errorDescription ?? "") Share State: \(shareRes.shareState)")
                    }
                }
            }
        }else{
            print("@@@@@@2cn not find video")
        }
        
    }
}
