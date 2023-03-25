//
//  ImageFileManager.swift
//  SocialNetworkPlatform
//
//  Created by Alvin Matthew Pratama on 26/03/23.
//

import UIKit

internal struct ImageFileManager {
    internal static func save(data: Data?, completion: @escaping (_ fileName: String?, _ error: String?) -> Void) {
        guard let imageData = data else { return }
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(nil, "Failed to get documentsDirectory")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        
        let currentUsername = UserManager.shared.getCurrentUser().username
        let filename = "\(currentUsername)_\(dateFormatter.string(from: Date()))"
        let fileURL = documentDirectory.appendingPathComponent(filename).appendingPathExtension("jpg")
        do {
            try imageData.write(to: fileURL, options: .atomic)
            completion(filename, nil)
        } catch {
            completion(nil, error.localizedDescription)
        }
    }
    
    internal static func getImage(byName name: String) -> UIImage? {
        let fileManager = FileManager.default
        do {
            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let imageURL = documentsURL.appendingPathComponent(name)
            guard
                let imageData = try? Data(contentsOf: imageURL),
                let image = UIImage(data: imageData)
            else { return nil }
            return image
        } catch {
            print(">>> ImageFileManager error get image: ", error)
            return nil
        }
    }
    
    internal static func delete(fileName: String) {
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[safe: 0]
        if let fileUrl = documentsUrl?.appendingPathComponent(fileName) {
            do {
                try fileManager.removeItem(at: fileUrl)
                print(">>> ImageFileManager file deleted: \(fileName)")
            } catch let error {
                print(">>> ImageFileManager error deleting file: \(error.localizedDescription)")
            }
        }
    }
    
}
