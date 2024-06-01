//
//  TargetType.swift
//  Asfrt
//
//  Created by Moh_ios on 24/10/2022.
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Request {
    case request
    case requestpara(para: [String: Any], encoding: ParameterEncoding)
    //case requestparaArr(paraArr: [Any], encoding: ParameterEncoding)
}

protocol TargetType {
    var baseUrl: String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var request: Request {get}
    var header: [String: String]? {get}
}
