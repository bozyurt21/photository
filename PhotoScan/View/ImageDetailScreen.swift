//
//  ImageDetailScreen.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 15.09.2025.
//

import SwiftUI

struct ImageDetailScreen: View {
    let photos: [AppPhoto]
    let startIndex: Int
    @ObservedObject var viewModel: PhotoLibraryManager
    @State private var currentIndex: Int

    init(photos: [AppPhoto], startIndex: Int, viewModel: PhotoLibraryManager) {
        self.photos = photos
        self.startIndex = startIndex
        self.viewModel = viewModel
        _currentIndex = State(initialValue: startIndex)
    }
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(photos.enumerated()), id: \.element.id) { index, appPhoto in
                    ScreenImage(appPhoto: appPhoto, viewModel: viewModel)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .navigationBarTitleDisplayMode(.inline)
    }
}



