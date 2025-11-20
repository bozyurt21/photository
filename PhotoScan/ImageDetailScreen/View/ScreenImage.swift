//
//  ScreenImage.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 18.09.2025.
//

import SwiftUI

struct ScreenImage: View {
    let appPhoto: AppPhoto
    @ObservedObject var viewModel: PhotoLibraryViewModel = PhotoLibraryViewModel()
    @State private var image: UIImage?
    
    var body: some View {
            
            VStack {
                Text("\(appPhoto.creationDate?.formatted(date: Date.FormatStyle.DateStyle.abbreviated, time: Date.FormatStyle.TimeStyle.omitted) ?? "")").font(.caption2)
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }else {
                    ProgressView()
                }
                        
                
            }
            .padding(10)
            .onAppear {
                viewModel.fetchImage(for: appPhoto, targetSize: CGSize(width: 1000, height: 1000)) { img in
                    self.image = img
                }
            }
       
    }
        
}

