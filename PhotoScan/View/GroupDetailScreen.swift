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
    var body: some View {
        ScrollView {
            LazyVGrid(columns: flexibleColumn, spacing: 20) {
                if group == nil {
                    ForEach(viewModel.appPhotos.filter { $0.group == nil}) { appPhoto in
                        VStack {
                            PhotoView(appPhoto: appPhoto, viewModel: viewModel)
                        }
                   }
                }
                ForEach(viewModel.appPhotos.filter { $0.group == group }) { appPhoto in
                    VStack {
                        PhotoView(appPhoto: appPhoto, viewModel: viewModel)
                    }
               }
            }
        }
        .navigationTitle(group?.rawValue ?? "Others")
    }
}


