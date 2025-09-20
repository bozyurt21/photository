//
//  PhotoLibraryManager.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 16.09.2025.
//

import Foundation
import Photos
import SwiftUI

class PhotoLibraryManager : ObservableObject {
    @Published var appPhotos: [AppPhoto] = []
        
    private let storageURL: URL
        
    init() {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        storageURL = docs.appendingPathComponent("savedPhotos.json")
        loadPhotos()
    }
        

    func addAsset(_ asset: PHAsset, total: Int, progressHandler: @escaping (Int, Int)->Void, completion: @escaping () -> Void) {
        let targetSize = CGSize(width: 300, height: 300)
        let options = PHImageRequestOptions()
        var processed = -(appPhotos.count)
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, _ in
            DispatchQueue.main.async  {
                let hash = asset.reliableHash()
                let group = PhotoGroup.group(for: hash)
                // TODO : Some notification could be added (maybe since I do not want to make a lot of notifications)
                if !self.appPhotos.contains(where: { $0.id == asset.localIdentifier }) {
                    let newPhoto = AppPhoto(id: asset.localIdentifier, group: group)
                    self.appPhotos.append(newPhoto)
                    self.savePhotos()
                }
                processed += self.appPhotos.count
                progressHandler(processed, total)
                if processed == total {
                    completion()
                }
                
            }
            
        }
        
        
        
    }
        
    private func savePhotos() {
        if let data = try? JSONEncoder().encode(appPhotos) {
            try? data.write(to: storageURL)
        }
    }
        
    private func loadPhotos() {
        if let data = try? Data(contentsOf: storageURL),let decoded = try? JSONDecoder().decode([AppPhoto].self, from: data) {
            appPhotos = decoded
        }
    }
        

    func fetchImage(for appPhoto: AppPhoto,targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .opportunistic
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [appPhoto.id], options: nil)
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
        else {
            completion(nil)
        }
            
    }

}
