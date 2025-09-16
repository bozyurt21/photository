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
        

        func addAsset(_ asset: PHAsset) {
            let newPhoto = AppPhoto(id: asset.localIdentifier, asset: asset)
            appPhotos.append(newPhoto)
            savePhotos()
        }
        
        private func savePhotos() {
            let identifiers = appPhotos.map { $0.id }
            if let data = try? JSONEncoder().encode(identifiers) {
                try? data.write(to: storageURL)
            }
        }
        

        private func loadPhotos() {
            guard let data = try? Data(contentsOf: storageURL),
                  let identifiers = try? JSONDecoder().decode([String].self, from: data)
            else { return }
            
            let assets = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
            
            var restored: [AppPhoto] = []
            assets.enumerateObjects { asset, _, _ in
                restored.append(AppPhoto(id: asset.localIdentifier, asset: asset))
            }
            
            appPhotos = restored
        }
        

        func fetchImage(for appPhoto: AppPhoto,targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
            let options = PHImageRequestOptions()
            options.isSynchronous = false
            options.deliveryMode = .opportunistic
            
            PHImageManager.default().requestImage(
                for: appPhoto.asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: options
            ) { image, _ in
                completion(image)
            }
        }

}
