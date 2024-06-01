//
//  BaseApi.swift
//  Asfrt
//
//  Created by Moh_ios on 24/10/2022.
//

import UIKit
import Alamofire
//import MBProgressHUD

class BaseApi<T: TargetType> {
    
    func fetchData<M: Codable>(target: T, response: M.Type, completion: @escaping(Result<M?, NSError>) -> ()) {

        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.header ?? [:])
        let params = buildpara(task: target.request)
        print("url is \(target.baseUrl + target.path) with method \(method) and parameters \(params.0)")
        AF.request(target.baseUrl + target.path, method: method, parameters: params.0, encoding: params.1, headers: headers ).responseDecodable(of: response){ respon in

            print("response is", respon.result)
            guard let statuscode = respon.response?.statusCode else {
                let error = NSError(domain: target.baseUrl, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.genericError])
                completion(.failure(error))
                return
            }
            if statuscode == 200 {
                // success
                switch respon.result{
                case let .success(result):
                    completion(.success(result))
                case .failure(let err):
                    print("there are error in alamo", err.localizedDescription)
                    let error = NSError(domain: target.baseUrl, code: 0, userInfo: [NSLocalizedDescriptionKey: err.localizedDescription])
                    completion(.failure(error))
                }
            }
            else if statuscode == 401{
                AuthService.instance.removeUserDefaults()
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "lognav") as! UINavigationController
                DispatchQueue.main.async {
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as? UIWindowScene
                    guard let window = windowScene?.windows.first else { fatalError() }
                    window.rootViewController = vc
                    UIView.transition(with: window, duration: 1.0, options: .transitionFlipFromTop, animations: nil, completion: nil)
                }
            }
            else {
                switch respon.result{
                case let .success(result):
                    completion(.success(result))
                case .failure(let err):
                    print("there are error in alamo base api", err.localizedDescription)
                    let error = NSError(domain: target.baseUrl, code: 0, userInfo: [NSLocalizedDescriptionKey: err.localizedDescription])
                    completion(.failure(error))
                }
                let mes = "error message from backend"
                let error = NSError(domain: target.baseUrl, code: statuscode, userInfo: [NSLocalizedDescriptionKey: mes])
                completion(.failure(error))
            }

        }
    }
//    func uploadImage<M: Codable>(data: UploadData, target: T, response: M.Type, completion: @escaping(Result<M?, NSError>) -> ()){
//        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
//        //let para = buildpara(task: target.request).0
//        let url = target.baseUrl + target.path
//        //print(url)
//        //print("method", method)
//        //print("data is in uploadimage", data)
//        AF.upload(multipartFormData: { multipart in
//            multipart.append(data.data, withName: data.name, fileName: "file.jpg", mimeType: data.mimeType)
//            //, headers: ["Content-type": "multipart/form-data"]
//        }, to: url, method: method).responseDecodable(of: response) { respon in
//            //print("response is", respon.result)
//            guard let statuscode = respon.response?.statusCode else {
//                let error = NSError(domain: target.baseUrl, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.genericError])
//                completion(.failure(error))
//                return
//            }
//            if statuscode == 200 {
//                // success
//                switch respon.result{
//                case let .success(result):
//                    completion(.success(result))
//                case .failure(let err):
//                    print("there are error in alamo", err.localizedDescription)
//                    let error = NSError(domain: target.baseUrl, code: 0, userInfo: [NSLocalizedDescriptionKey: err.localizedDescription])
//                    completion(.failure(error))
//                }
//            }else {
//                let mes = "error message from backend"
//                let error = NSError(domain: target.baseUrl, code: statuscode, userInfo: [NSLocalizedDescriptionKey: mes])
//                completion(.failure(error))
//            }
//            
//        }
//    }
    private func buildpara(task: Request) -> ([String: Any], ParameterEncoding) {
        switch task {
        case .request:
            return ([:], URLEncoding.default)
        case .requestpara(para: let para, encoding: let encoding):
            return (para, encoding)
        default:
            return ([:], URLEncoding.default)
        }
    }
//    private func buildparaArr(task: Request) -> ([Any], ParameterEncoding) {
//        switch task {
//        case .requestparaArr(paraArr: let para, encoding: let encoding):
//            return (para, encoding)
//        default:
//            return ([[:]], URLEncoding.default)
//        }
//    }
    func fetchDatajson(target: T) {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.header ?? [:])
        let params = buildpara(task: target.request)
        print("url is \(target.baseUrl + target.path) with method \(method) and parameters \(params.0)")
        AF.request(target.baseUrl + target.path, method: method, parameters: params.0, encoding: params.1, headers: headers ).responseJSON { response in
            print("json is", response.result)
        }
    }
}
