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
    @State private var showingPicker = false
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(viewModel.appPhotos) { appPhoto in
                        PhotoView(appPhoto: appPhoto, viewModel: viewModel)
                    }
                }
            }

            Button("+ Add Image") {
                showingPicker = true
            }
            .padding(10)
            .foregroundColor(.black)
            .background(.cyan)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .sheet(isPresented: $showingPicker) {
                PhotoPicker { asset in
                    viewModel.addAsset(asset)
                }
            }
        }
    }
    
    
}

#Preview {
    HomeScreen()
}
