//
//  GroupDetailScreen.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 15.09.2025.
//

import SwiftUI

struct GroupDetailScreen: View {
    let group: PhotoGroup?
    @ObservedObject var viewModel: PhotoLibraryManager
    
    private let flexibleColumn = [
            GridItem(.fixed(120)),
            GridItem(.fixed(120)),
            GridItem(.fixed(120))
    ]
    
    // Filtering Photos in here
    var photos : [AppPhoto] {
        if let group = group {
            return viewModel.appPhotos.filter { $0.group == group }
        }
        else {
            return viewModel.appPhotos.filter { $0.group == nil}
        }
    }
    
    var body: some View {
        ScrollView {
                LazyVGrid(columns: flexibleColumn, spacing: 10) {
                    ForEach(Array(photos.enumerated()), id: \.element.id) { (index, appPhoto) in
                        VStack {
                            NavigationLink {
                                ImageDetailScreen(photos: photos, startIndex: index, viewModel: viewModel)
                            }
                            label: {
                                PhotoView(appPhoto: appPhoto, viewModel: viewModel)
                                }
                            }
                        }
                    }
                }
        .navigationTitle("\(group?.rawValue.uppercased() ?? "Others")  (\(photos.count) images)")
    }
        
}


