//
//  PhotoScanApp.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 15.09.2025.
//

import SwiftUI

@main
struct PhotoScanApp: App {
    var body: some Scene {
        WindowGroup {
            UIKitRootView()
        }
    }
}

struct UIKitRootView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let homeVC = HomeScreen()
        return UINavigationController(rootViewController: homeVC)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
