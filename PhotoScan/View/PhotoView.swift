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
                            .scaledToFill()     // fill the frame
                            .frame(width: 120, height: 120) // make all cells equal
                            .clipped()
                            .cornerRadius(10)    // optional: rounded corners
                    } else {
                        Color.gray.opacity(0.3)
                            .frame(width: 120, height: 120)
                            .cornerRadius(8)
                    }
                }
                .onAppear {
                    viewModel.fetchImage(
                        for: appPhoto,
                        targetSize: CGSize(width: 300, height: 300) // fetch a slightly bigger image for clarity
                    ) { img in
                        self.image = img
                    }
                }
    }
}
