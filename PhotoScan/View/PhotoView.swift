//
//  PhotoView.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 16.09.2025.
//

import SwiftUI
import Photos

struct PhotoView: View {
    let asset: PHAsset
    @State private var image: UIImage?
    var body: some View {
        Group {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    } else {
                        Color.gray.opacity(0.3) // placeholder
                    }
                }
                .frame(width: 100, height: 100)
                .onAppear {
                    requestImage(for: asset, targetSize: CGSize(width: 100, height: 100)) { img in
                        self.image = img
                    }
            }
    }
    
    func requestImage(for asset: PHAsset, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: nil
            ) { image, _ in
                completion(image)
            }
        }
}

/*#Preview {
    PhotoView()
}*/
