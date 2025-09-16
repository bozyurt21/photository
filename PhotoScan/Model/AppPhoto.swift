//
//  Photo.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 16.09.2025.
//

import Foundation
import Photos

struct AppPhoto: Identifiable{
    let id: String            // since it is identifiable, we need to add id
    let asset: PHAsset    // we are going to group the photos so this is also needed
    //MARK: - Add creation date later
}
