//
//  ApiService.swift
//  MyFiles
//
//  Created by Moh_Sawy on 03/06/2024.
//

import Foundation

class ApiService{
    static let shared = ApiService()
    
    func downloadUrl(url: String, handler: @escaping(_ DownloadRes: DownloadRes?) -> ()){
        let strurl = "https://j2.io.vn/v1/social/autolink?apikey=\(FirestoreService.shared.api_Key)&url=\(url)"
        print("$$$$$$download url issss", strurl)
        let url = URL(string: strurl)!
        let request = URLRequest(url: url)
        let datatask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []){
                print("json is", json)
            }
                let res = try? JSONDecoder().decode(DownloadRes.self, from: data!)
                print(res)
                handler(res)
            }
            datatask.resume()
        }
    func downloadUrl2(url: String, handler: @escaping(_ DownloadRes: DownloadRes?) -> ()){
        let headers = [
            "x-rapidapi-key": FirestoreService.shared.api_Key,
            "x-rapidapi-host": "auto-download-all-in-one.p.rapidapi.com",
            "Content-Type": "application/json"
        ]
        let parameters = ["url": url] as [String : Any]

        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        let strurl = "https://auto-download-all-in-one.p.rapidapi.com/v1/social/autolink"
        print(parameters)
        let url = URL(string: strurl)!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        let datatask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []){
                print("json is", json)
            }
            let res = try? JSONDecoder().decode(DownloadRes.self, from: data!)
            print(res)
            handler(res)
        }
        datatask.resume()
    }
}

struct DownloadRes: Codable{
    let url, author, title, source, thumbnail, type: String?
    //let duration: Anyvalue?
    var medias: [Media]?
    let error: Bool?
}

struct Media: Codable{
    let url, quality, extensionType, type: String?
    //let duration: Anyvalue?
    enum CodingKeys: String, CodingKey {
        case url
        case quality
        case extensionType = "extension"
        case type
        //case duration
    }
}
enum Anyvalue: Codable {
    case int(Int), string(String) // Insert here the different type to encode/decode
    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        throw AnyError.missingValue
    }
    enum AnyError:Error {
        case missingValue
    }
}
