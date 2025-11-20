//
//  GroupDetailScreen.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 15.09.2025.
//

import SwiftUI

struct GroupDetailScreen: View {
    let group : PhotoGroup?
    @State private var animate = false
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel : GroupDetailViewModel
    private let flexibleColumn = [
            GridItem(.fixed(120)),
            GridItem(.fixed(120)),
            GridItem(.fixed(120))
    ]
    
    init(group: PhotoGroup?, photos: [AppPhoto]) {
        self.group = group
        _viewModel = StateObject(wrappedValue: GroupDetailViewModel(group: group, appPhotos: photos, photoLibrary: PhotoLibraryViewModel()))
    }
    
    var body: some View {
        ScrollView {
                LazyVGrid(columns: flexibleColumn, spacing: 10) {
                    ForEach(Array(viewModel.appPhotos.enumerated()), id: \.element.objectID) { (index, appPhoto) in
                            NavigationLink {
                                ImageDetailScreen(photos: viewModel.appPhotos, startIndex: index)
                            }
                            label: {
                                PhotoView(appPhoto: appPhoto)
                                    .opacity(animate ? 1 : 0)
                                    .offset(y: animate ? 0 : 20)
                                    .animation(
                                        .easeOut(duration: 0.4)
                                        .delay(Double(index) * 0.05),
                                         value: animate
                                    )
                                }
                            .contextMenu {
                                Button(role: .destructive) {
                                    viewModel.deletePhoto(appPhoto: appPhoto)
                                    
                                    if viewModel.appPhotos.isEmpty {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                            
                }
                .onAppear {
                    animate = true
                }
                }
                .navigationTitle("\(group?.rawValue ?? "Other")  (\(viewModel.appPhotos.count) images)")
                .onChange(of: viewModel.appPhotos.count) { newCount in
                    if newCount == 0 {
                        presentationMode.wrappedValue.dismiss()
                    }
                    animate = true
                }
        }
        
}


