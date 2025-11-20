//
//  ImageDetailScreen.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 15.09.2025.
//

import SwiftUI

struct ImageDetailScreen: View {
    var photos: [AppPhoto]
    let startIndex: Int
    @State private var currentIndex: Int

    init(photos: [AppPhoto], startIndex: Int) {
        self.photos = photos
        self.startIndex = startIndex
        _currentIndex = State(initialValue: startIndex)
    }
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(photos.enumerated()), id: \.element.id) { index, appPhoto in
                    ScreenImage(appPhoto: appPhoto)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .navigationBarTitleDisplayMode(.inline)
    }
}



