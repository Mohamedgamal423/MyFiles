//
//  FirestoreService.swift
//  myfiles
//
//  Created by Moh_Sawy on 12/01/2024.
//

import Foundation
import FirebaseFirestore

class FirestoreService{
    static let shared = FirestoreService()
    private let config = Firestore.firestore().collection("config")
    var show_download = false
    var show_ads = false
    var api_Key = ""
    
    func getSettings(completion: @escaping(_ isSuccess: Bool) -> Void){
        config.getDocuments { [weak self]snapshot, error in
            guard let slf = self else{return}
            if let err = error{
                print("error in ssetting", err.localizedDescription)
                return
            }else{
                print("getting setting$$$$$$%%%%%")
                guard let document = snapshot?.documents.first else{return}
                print("doc isssss", document)
                let data = document.data()
                print(data)
                slf.show_download = data["show_download"] as! Bool
                slf.show_ads = data["show_ads"] as! Bool
                slf.api_Key = data["api_key"] as! String
                print("show download issss", slf.show_download)
                completion(true)
            }
        }
    }
}
