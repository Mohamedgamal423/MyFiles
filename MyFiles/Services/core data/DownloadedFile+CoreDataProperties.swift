//
//  DownloadedFile+CoreDataProperties.swift
//  MyFiles
//
//  Created by Moh_Sawy on 19/06/2024.
//
//

import Foundation
import CoreData


extension DownloadedFile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DownloadedFile> {
        return NSFetchRequest<DownloadedFile>(entityName: "DownloadedFile")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var type: Int32

}

extension DownloadedFile : Identifiable {

}
