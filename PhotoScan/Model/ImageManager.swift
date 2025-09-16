//
//  ImageManager.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 16.09.2025.
//

import Foundation
import Photos
import UIKit

struct ImageManager {
    
    // This functions fetches all images and puts them in category
    func fetchAllPhotos() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }
    
    func requestImage(for asset: PHAsset, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: nil
        ) { image, info in
            completion(image)
        }
    }
}
