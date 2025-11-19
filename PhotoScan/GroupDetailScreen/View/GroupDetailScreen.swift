//
//  GroupDetailScreen.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 15.09.2025.
//

import SwiftUI

struct GroupDetailScreen: View {
    let group: PhotoGroup?
    let photos : [AppPhoto]
    @ObservedObject var viewModel: PhotoLibraryViewModel
    @State private var animate = false
    
    private let flexibleColumn = [
            GridItem(.fixed(120)),
            GridItem(.fixed(120)),
            GridItem(.fixed(120))
    ]
    
    
    var body: some View {
        ScrollView {
                LazyVGrid(columns: flexibleColumn, spacing: 10) {
                    ForEach(0..<photos.count, id: \.self) { (index) in
                            let appPhoto = photos[index]
                            NavigationLink {
                                ImageDetailScreen(photos: photos, startIndex: index, viewModel: viewModel)
                            }
                            label: {
                                PhotoView(appPhoto: appPhoto, viewModel: viewModel)
                                    .opacity(animate ? 1 : 0)
                                    .offset(y: animate ? 0 : 20)
                                    .animation(
                                        .easeOut(duration: 0.4)
                                        .delay(Double(index) * 0.05),
                                         value: animate
                                    )
                                }
                            }
                }
                .onAppear {
                    animate = true}
                }
        .navigationTitle("\(group?.rawValue ?? "Other")  (\(photos.count) images)")
    }
        
}


