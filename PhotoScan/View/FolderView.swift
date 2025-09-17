//
//  FolderView.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 17.09.2025.
//

import SwiftUI

struct FolderView: View {
    let groupName: String
    let photos: [AppPhoto]
    
    var body: some View {
        VStack {
            ZStack {
                if let first = photos.first {
                    Color.gray.opacity(0.2) // background placeholder
                    Image(systemName: "folder.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.yellow)
                }
                else {
                    Color.gray.opacity(0.3)
                    Image(systemName: "folder.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.yellow)
                }
            }
            .frame(width: 120, height: 120)
            .cornerRadius(12)

            Text(groupName.capitalized)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

/*#Preview {
    FolderView()
}*/
