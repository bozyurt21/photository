//
//  PhotoLibraryManager.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 16.09.2025.
//

import Foundation
import Photos
import SwiftUI
import CoreData

class PhotoLibraryManager : ObservableObject {
    @Published var appPhotos: [AppPhoto] = []
    
    private let context: NSManagedObjectContext
    //private let storageURL: URL
    private var processed  = 0
    private var alreadyProcessed = 0
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        loadPhotos()
    }
        

    func addAsset(_ asset: PHAsset, total: Int, progressHandler: @escaping (Int, Int)->Void, completion: @escaping () -> Void) {
        let targetSize = CGSize(width: 300, height: 300)
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, _ in
            DispatchQueue.main.async  {
                let hash = asset.reliableHash()
                let group = PhotoGroup.group(for: hash)
                // TODO : Some notification could be added (maybe since I do not want to make a lot of notifiprivate let context: NSManagedObjectContextcations)
                if !self.appPhotos.contains(where: { $0.id == asset.localIdentifier}) {
                    let newPhoto = self.savePhotos(with: asset.localIdentifier, for: hash, group: group)
                    self.appPhotos.append(newPhoto)
                    self.saveContext()
                    self.processed += 1
                }
                else {
                    self.alreadyProcessed += 1
                }
                progressHandler(self.processed, total - self.alreadyProcessed)
                if self.processed == (total - self.alreadyProcessed){
                    completion()
                }
                
            }
            
        }
    }
    
    private func saveContext() {
        guard context.hasChanges else {return}
        do {
            try context.save()
        }catch {
            print("Error while saving context")
        }
    }
        
    private func savePhotos(with localIdentifier: String, for hash: Double, group: PhotoGroup?) -> AppPhoto {
        let newPhoto = AppPhoto(context: self.context)
        newPhoto.id = localIdentifier
        newPhoto.groupHash = hash
        newPhoto.groupName = group?.rawValue ?? "Other"
        return newPhoto
    }
    
    private func loadPhotos() {
        let request : NSFetchRequest<AppPhoto> = AppPhoto.fetchRequest()
        do {
            let result = try context.fetch(request)
            self.appPhotos = result
        }catch {
            print("Error while fetching photos")
            self.appPhotos = []
        }
    }
    
    
    func loadPhotosForGroups(for groupName: String) -> [AppPhoto] {
        let req : NSFetchRequest<AppPhoto> = AppPhoto.fetchRequest()
        req.predicate = NSPredicate(format: "groupName == %@", groupName)
        do {
            let result = try context.fetch(req)
            return result
        }
        catch {
            print("Error fetching the request")
            return []
        }
    }
        
    // Fetches Images from Photo Library
    func fetchImage(for appPhoto: AppPhoto,targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .opportunistic
        
        // There should be an id of the photo else return nothing.
        guard let id = appPhoto.id else {
            completion(nil)
            return
        }
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        if let asset = assets.firstObject {
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: options
            ) { image, _ in
                completion(image)
            }
        }
            
    }

}
