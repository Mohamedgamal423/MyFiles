//
//  HudEX.swift
//  Grinta
//
//  Created by Moh_ios on 19/08/2022.
//

import UIKit
import AVFoundation
//import MBProgressHUD


//func showHud(view: UIView) {
//    DispatchQueue.main.async {
//       let hud = MBProgressHUD.showAdded(to: view, animated: true)
//        hud.label.text = "loading.."
//    }
//}
//func hideHud(view: UIView) {
//    DispatchQueue.main.async {
//        MBProgressHUD.hide(for: view, animated: true)
//    }
//}

func showAlert(slf:UIViewController, title: String? = "", message: String?, selfDismissing: Bool = true, time: TimeInterval = 2) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.view.alpha = 0.3
    
    if !selfDismissing {
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    }
    
    slf.present(alert, animated: true)
    
    if selfDismissing {
        Timer.scheduledTimer(withTimeInterval: time, repeats: false) { t in
            t.invalidate()
            alert.dismiss(animated: true)
        }
    }
}

func showAlertRestartApp(slf:UIViewController, title: String? = "", message: String?, selfDismissing: Bool = true, time: TimeInterval = 2) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.view.alpha = 0.3
    
    if !selfDismissing {
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    }
    
    slf.present(alert, animated: true)
    
    if selfDismissing {
        Timer.scheduledTimer(withTimeInterval: time, repeats: false) { t in
            t.invalidate()
            alert.dismiss(animated: true)
//                AuthService.instance.restartApp()
        }
    }
}

func showAlertWithDismiss(slf:UIViewController, title: String? = "", message: String?, selfDismissing: Bool = true, time: TimeInterval = 3) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.view.alpha = 0.3
    
    if !selfDismissing {
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    }
    
    slf.present(alert, animated: true)
    
    if selfDismissing {
        Timer.scheduledTimer(withTimeInterval: time, repeats: false) { t in
            t.invalidate()
            alert.dismiss(animated: true)
            slf.dismiss(animated: true)
        }
    }
}

func showAlertGoLog(slf:UIViewController, title: String? = "", message: String? = "من فضلك سجل دخول اولا", selfDismissing: Bool = true, time: TimeInterval = 2) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.view.alpha = 0.3
    
    if !selfDismissing {
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    }
    
    slf.present(alert, animated: true)
    
    if selfDismissing {
        Timer.scheduledTimer(withTimeInterval: time, repeats: false) { t in
            t.invalidate()
            alert.dismiss(animated: true)
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC")
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .flipHorizontal
            slf.present(vc, animated: true)
        }
    }
}
func showAlertLogoutAcc(slf:UIViewController, title: String = "Log Out".localized, message: String = "are you sure about log out from your Account".localized) {
    let alert = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)
    alert.view.tintColor = UIColor(named: "Primarycolor")!
    alert.view.alpha = 0.3
    let delaction = UIAlertAction(title: title.localized, style: .default) { act in

    }
    let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel) { action in
        alert.removeFromParent()
    }
    alert.addAction(delaction)
    alert.addAction(cancel)
    slf.present(alert, animated: true, completion: nil)
}

func showAlertLoginfirst(slf:UIViewController, title: String = "Login".localized, message: String = "Please login first".localized) {
    let alert = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)
    alert.view.tintColor = #colorLiteral(red: 0.5141925812, green: 0.5142051578, blue: 0.5141984224, alpha: 1)
    alert.view.alpha = 0.3
    let delaction = UIAlertAction(title: title.localized, style: .default) { act in
        AuthService.instance.removeUserDefaults()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "lognav") as! UINavigationController
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first else { fatalError() }
            //guard let window =  UIApplication.shared.keyWindow else { fatalError() }
            window.rootViewController = vc
            UIView.transition(with: window, duration: 1.0, options: .transitionFlipFromTop, animations: nil, completion: nil)
        }
        print("logout success")
    }
    let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel) { action in
        alert.removeFromParent()
    }
    alert.addAction(delaction)
    alert.addAction(cancel)
    slf.present(alert, animated: true, completion: nil)
}
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0].appendingPathComponent("My Files")
    return documentsDirectory
}
func fileSize(fromPath path: String) -> String? {
    guard let size = try? FileManager.default.attributesOfItem(atPath: path)[FileAttributeKey.size],
        let fileSize = size as? UInt64 else {
        return nil
    }

    // bytes
    if fileSize < 1023 {
        return String(format: "%lu bytes", CUnsignedLong(fileSize))
    }
    // KB
    var floatSize = Float(fileSize / 1024)
    if floatSize < 1023 {
        return String(format: "%.1f KB", floatSize)
    }
    // MB
    floatSize = floatSize / 1024
    if floatSize < 1023 {
        return String(format: "%.1f MB", floatSize)
    }
    // GB
    floatSize = floatSize / 1024
    return String(format: "%.1f GB", floatSize)
}
func createVideoThumbnail(url: URL?,  completion: @escaping ((_ image: UIImage?)->Void)) {
    
    guard let url = url else { return }
    DispatchQueue.global().async {
        
        let url = url as URL
        let request = URLRequest(url: url)
        let cache = URLCache.shared
        
        if
            let cachedResponse = cache.cachedResponse(for: request),
            let image = UIImage(data: cachedResponse.data)
        {
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        var image: UIImage?
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            image = UIImage(cgImage: cgImage)
        } catch { DispatchQueue.main.async {
            completion(nil)
        } }
        
        if
            let image = image,
            let data = image.pngData(),
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        {
            let cachedResponse = CachedURLResponse(response: response, data: data)
            
            cache.storeCachedResponse(cachedResponse, for: request)
        }
        
        DispatchQueue.main.async {
            completion(image)
        }
        
    }
    
}

func createPath(name: String) -> URL{
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    let docURL = URL(fileURLWithPath: documentsDirectory)
    //URL(string: documentsDirectory)!
    let dataPath = docURL.appendingPathComponent("My Files")
    if !FileManager.default.fileExists(atPath: dataPath.path) {
        do {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            print("created directory success")
        } catch {
            print("error create directory", error.localizedDescription)
        }
    }else{
        print("path already exists")
    }
    return dataPath.appendingPathComponent(name)
}
func renameFile(newName: String, oldName: String, completion: @escaping(_ success: Bool, _ error: Error?) -> ()){
    do {
        //let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //let documentDirectory = URL(fileURLWithPath: path).appendingPathComponent("My Files")
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentDirectory = doc.appendingPathComponent("My Files")
        let originPath = documentDirectory.appendingPathComponent(oldName)
        print("original path isssss", originPath.lastPathComponent)
        print("original path url isssss", originPath)
        
        let destinationPath = documentDirectory.appendingPathComponent(newName)
        print("dest path isssss", destinationPath.lastPathComponent)
        print("dest path url isssss", destinationPath)
        try FileManager.default.moveItem(at: originPath, to: destinationPath)
        completion(true, nil)
    } catch let err {
        print("error in move", err)
        completion(false, err)
    }
}


