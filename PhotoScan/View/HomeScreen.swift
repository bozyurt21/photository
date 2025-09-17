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
    
    private let flexibleColumn = [
            
            GridItem(.flexible(minimum: 100, maximum: 200)),
            GridItem(.flexible(minimum: 100, maximum: 200)),
            GridItem(.flexible(minimum: 100, maximum: 200))
        ]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: flexibleColumn, spacing: 20) {
                    ForEach(viewModel.appPhotos) { appPhoto in
                        VStack {
                            PhotoView(appPhoto: appPhoto, viewModel: viewModel)
                            if let group = appPhoto.group {
                                Text(group.rawValue)
                            }
                            else {
                                Text("Others")
                            }
                        }
                        
                    }
                }
                
            }
            
            Button("+ Add Image") {
                // I want to gave the request before th picker opens because otherwise the images added didn't shown directly
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized || status == .limited {
                        DispatchQueue.main.async {
                            showingPicker = true
                        }
                    }
                }
            }
            .padding(10)
            .foregroundColor(.black)
            .background(.cyan)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .sheet(isPresented: $showingPicker) {
                PhotoPicker { assets in
                    for asset in assets { // since it takes several PHassets as input
                            viewModel.addAsset(asset)
                    }
                    showingPicker = false // close the picker when user select their images
                }
            }
        }
    }
    
    
}

#Preview {
    HomeScreen()
}
