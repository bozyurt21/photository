//
//  FolderCell.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 17.09.2025.
//

import Foundation
import UIKit

class FolderCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "mainColor")
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with group: PhotoGroup?) {
        if let group = group {
            titleLabel.text = group.rawValue
        }
        else {
            titleLabel.text = "others"
        }
    }
}
