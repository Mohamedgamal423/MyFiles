//
//  CoreDataManager.swift
//  MyFiles
//
//  Created by Moh_Sawy on 19/06/2024.
//

import CoreData
import UIKit

class CoreDataManager{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let shared = CoreDataManager()
    
    func saveFile(name: String, type: Int){
        let file = DownloadedFile(context: context)
        file.name = name
        file.type = Int32(type)
        file.date = Date()
        do {
            try context.save()
        } catch let err  {
            print(err.localizedDescription)
        }
    }
    func deleteFile(name: String){
        guard let file = getFile(name: name) else{return}
        context.delete(file)
        do {
            try context.save()
        }
        catch {
            
        }
    }
    func renameFile(newName: String, oldName: String){
        guard let file = getFile(name: oldName) else{return}
        file.name = newName
        do {
            try context.save()
        }
        catch {
            
        }
    }
    func getFile(name: String) -> DownloadedFile?{
        do {
            let request = DownloadedFile.fetchRequest()
            let predicate = NSPredicate(format: "name == %@", name)
            request.predicate = predicate
            var file = try context.fetch(request).first
            return file
        } catch {
            return nil
        }
    }
    func getAllFiles() -> [DownloadedFile]{
        do {
            let request = DownloadedFile.fetchRequest()
            //let predicate = NSPredicate(format: "name == %@", floorName)
            //request.predicate = predicate
            var files = try context.fetch(request)
            return files
        } catch {
            return []
        }
    }
    
}
