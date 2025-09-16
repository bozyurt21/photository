//
//  PhotoFetcher.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 16.09.2025.
//

import Foundation
import UIKit
import Photos

// Responsible for fetching photos from an asset
struct PhotoFetcher {
    func fetchUIImage(for appPhoto: AppPhoto, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [appPhoto.id], options: nil)
            guard let asset = assets.firstObject else {
                completion(nil)
                return
            }

            PHImageManager.default().requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFit,
                options: nil
            ) { image, _ in
                completion(image)
            }
        }
}
