//
//  HomeScreen.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 15.09.2025.
//

import SwiftUI
import Photos

struct HomeScreen: View {
    @StateObject private var viewModel = PhotoLibraryManager()
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(viewModel.photos) { appPhoto in
                        PhotoView(asset: appPhoto.asset)
                    }
                }
            }
            Button("+Add Image") {
                viewModel.fetchPhotos()
            }
            .padding(10)
            .foregroundColor(.black)
            .background(.cyan)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
    
    
}

#Preview {
    HomeScreen()
}
