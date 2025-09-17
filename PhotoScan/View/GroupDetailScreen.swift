//
//  GroupDetailScreen.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 15.09.2025.
//

import SwiftUI

struct GroupDetailScreen: View {
    @StateObject private var viewModel = PhotoLibraryManager()
    private let flexibleColumn = [
            GridItem(.fixed(120)),
            GridItem(.fixed(120)),
            GridItem(.fixed(120))
    ]
    var body: some View {
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
        
        
    }
}

#Preview {
    GroupDetailScreen()
}
