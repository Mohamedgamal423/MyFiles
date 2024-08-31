//
//  SceneDelegate.swift
//  MyFiles
//
//  Created by Moh_Sawy on 26/05/2024.
//

import UIKit
import TikTokOpenSDKCore
import GoogleMobileAds

class SceneDelegate: UIResponder, UIWindowSceneDelegate, GADFullScreenContentDelegate {

    var window: UIWindow?
    var appOpenAd: GADAppOpenAd?
    var loadTime = Date()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        getSetting()
        if let userActivity = connectionOptions.userActivities.first {
                debugPrint("userActivity: \(userActivity.webpageURL)")
                fatalError()
            }
    }
    func scene(_ scene: UIScene,
                   openURLContexts URLContexts: Set<UIOpenURLContext>) {
            if (TikTokURLHandler.handleOpenURL(URLContexts.first?.url)) {
                return
            }
        }
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
        debugPrint("userActivity: \(userActivity.webpageURL)")
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("show ads subscrip \(AuthService.instance.isSubsActive ?? false) and show_ads firebase \(FirestoreService.shared.show_ads)")
        if !(AuthService.instance.isSubsActive ?? false) && (FirestoreService.shared.show_ads){
            self.tryToPresentAd()
            print("👁️👁️👁️👁️will show ads")
        }else{
            print("🤡🤡🤡🤡🤡not show ads subscrip \(AuthService.instance.isSubsActive ?? false) and show_ads firebase \(FirestoreService.shared.show_ads)")
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    func getSetting(){
        FirestoreService.shared.getSettings { [weak self]isSuccess in
            let tab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tab") as! TabBarController
            self?.window?.rootViewController = tab
            self?.window?.makeKeyAndVisible()
        }
    }
    func validateAppPurchase(){
        let subscriptionDate = IAPManager.shared.expirationDateFor("spt_noads_499_monthly") ?? Date()
        let isActive = subscriptionDate > Date()
        print("expiration data is", subscriptionDate)
        AuthService.instance.isSubsActive = isActive
    }
    func requestAppOpenAd() {
        let request = GADRequest()
        GADAppOpenAd.load(withAdUnitID: "ca-app-pub-3233536447139983/9401520012",
                          request: request,
                          completionHandler: { (appOpenAdIn, _) in
            self.appOpenAd = appOpenAdIn
            self.appOpenAd?.fullScreenContentDelegate = self
            print("Ad is ready")
            
        })
    }
    func tryToPresentAd() {
        if let gOpenAd = self.appOpenAd, let rwc = UIApplication.shared.windows.last?.rootViewController {
                gOpenAd.present(fromRootViewController: rwc)
            } else {
                self.requestAppOpenAd()
            }
    }
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("error Admob", error.localizedDescription)
        if !(AuthService.instance.isSubsActive ?? false) && (FirestoreService.shared.show_ads){
            requestAppOpenAd()
        }
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if !(AuthService.instance.isSubsActive ?? false) && (FirestoreService.shared.show_ads){
            requestAppOpenAd()
        }
    }


}

