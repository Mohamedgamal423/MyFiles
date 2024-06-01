//
//  CheckVersion.swift
//  Asfrt
//
//  Created by Moh_ios on 18/03/2023.
//

import Foundation

struct CheckVersion: Codable {
    let resultCount: Int?
    let results: [versreslt]?
}
struct versreslt: Codable {
    let version: String?
}
