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
    
    @Published var photos: [AppPhoto] = [] // this makes the photos broadcasted among the other objects
    
    func fetchPhotos() {
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized || status == .limited else { return }

                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)

                var temp: [AppPhoto] = []
                result.enumerateObjects { asset, _, _ in
                    temp.append(AppPhoto(id: asset.localIdentifier, asset: asset))
                }

                DispatchQueue.main.async {
                    self.photos = temp
                }
            }
        }
}
