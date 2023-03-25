//
//  CoreDataManager.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 25/03/23.
//

import CoreData
import UIKit

internal struct CoreDataManager<T: Codable> {
    private let entityName: String
    
    internal init(entityName: String) {
        self.entityName = entityName
    }
    
    internal func create(_ object: T) -> CoreDataError? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return .custom("Failed to get appDelegate")
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let userEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else {
            return .invalidEntityName(name: entityName)
        }
        
        guard let dictionary = object.asDictionary() else {
            return .custom("Failed to convert encodable to dictionary")
        }
        let insert = NSManagedObject(entity: userEntity, insertInto: managedContext)
        for (key, value) in dictionary {
            insert.setValue(value, forKey: key)
        }
        do{
            try managedContext.save()
        } catch {
            return CoreDataError.createError
        }
        return nil
    }
    
    internal func fetch() -> Result<[T], CoreDataError> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return .failure(.custom("Failed to get appDelegate"))
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do{
            guard let fetchedResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else {
                return .failure(.fetchError)
            }
            
            var jsonArray = [[String: Any]]()
            for data in fetchedResults {
                if let dict = data.toDictionary() {
                    jsonArray.append(dict)
                }
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode([T].self, from: jsonData)
            return .success(decodedObject)
        } catch {
            return .failure(.fetchError)
        }
    }
}

extension NSManagedObject {
    internal func toDictionary() -> [String: Any]? {
        var json = [String: Any]()
        for (key, _) in entity.attributesByName {
            if let value = self.value(forKey: key) {
                json[key] = value
            }
        }
        return json
    }
}
