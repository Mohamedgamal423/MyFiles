//
//  TabBarController.swift
//  soccer world
//
//  Created by gamal on 16/01/2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabbar()
    }
    func setTabbar(){
        if FirestoreService.shared.show_download{
            let searchvc = storyboard?.instantiateViewController(withIdentifier: "search") as! SearchVC
            searchvc.tabBarItem = UITabBarItem(title: "search".localized, image: UIImage(systemName: "rectangle.and.text.magnifyingglass.rtl"), tag: 0)
            
            let downloadsvc = storyboard?.instantiateViewController(withIdentifier: "download") as! DownloadsVC
            downloadsvc.tabBarItem = UITabBarItem(title: "downloads".localized, image: UIImage(systemName: "square.and.arrow.down.on.square"), tag: 0)
            let filesvc = storyboard?.instantiateViewController(withIdentifier: "files") as! MyFilesVC
            filesvc.tabBarItem = UITabBarItem(title: "myfiles".localized, image: UIImage(systemName: "folder"), tag: 0)
            
            let settingvc = storyboard?.instantiateViewController(withIdentifier: "setting") as! SettingVC
            settingvc.tabBarItem = UITabBarItem(title: "setting".localized, image: UIImage(systemName: "gearshape.2"), tag: 0)
            self.viewControllers = [searchvc, downloadsvc, filesvc, settingvc]
        }else{
            let filesvc = storyboard?.instantiateViewController(withIdentifier: "files") as! MyFilesVC
            filesvc.tabBarItem = UITabBarItem(title: "myfiles".localized, image: UIImage(systemName: "folder"), tag: 0)
            
            let settingvc = storyboard?.instantiateViewController(withIdentifier: "setting") as! SettingVC
            settingvc.tabBarItem = UITabBarItem(title: "setting".localized, image: UIImage(systemName: "gearshape.2"), tag: 0)
            self.viewControllers = [filesvc, settingvc]
        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }
        
        let timeInterval: TimeInterval = 0.3
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }


}
