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
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 200) 
                    .clipped()
                    .cornerRadius(10)
                }
            else {
                Color.gray.opacity(0.3)
                    .frame(width: 120, height: 200)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            viewModel.fetchImage(
            for: appPhoto,
            targetSize: CGSize(width: 300, height: 300)
        ) { img in
            self.image = img
        }
      }
    }
}
