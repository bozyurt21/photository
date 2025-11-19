//
//  DownloadProgressBarController.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 19.09.2025.
//

import Foundation

import UIKit

class DownloadProgressBarController: UIViewController {
    private let titleLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let percentLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)

        titleLabel.text = "Downloading..."
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center

        percentLabel.text = "0%"
        percentLabel.font = UIFont.systemFont(ofSize: 14)
        percentLabel.textAlignment = .center

        progressView.progress = 0.0
        progressView.tintColor = UIColor(named: "mainColor")

        let stack = UIStackView(arrangedSubviews: [titleLabel, progressView, percentLabel])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    func updateProgress(processed: Int, total: Int) {
        let progress = Float(processed) / Float(total)
        progressView.setProgress(progress, animated: true)
        percentLabel.text = "Downloaded \(processed)/\(total) images"
        
        if processed == total {
            titleLabel.text = "Done 🥳"
        }
    }
}
