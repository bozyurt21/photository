//
//  PhotoView.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 16.09.2025.
//

import SwiftUI
import Photos

struct PhotoView: View {
    let appPhoto: AppPhoto
    @ObservedObject var viewModel: PhotoLibraryManager
    @State private var image: UIImage?
    var body: some View {
        Group {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        
                } else {
                    Color.gray.opacity(0.3) // if photo does not exist then we are going to show an gray color.
                }
        }
        .frame(width: 100, height: 100)
        .onAppear {
            viewModel.fetchImage(for: appPhoto, targetSize: CGSize(width: 100, height: 100)) { img in
                self.image = img
            }
        }
    }
}
