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
    private let imageView = UIImageView()
    private let total_count = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "folder.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "mainColor")
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        total_count.translatesAutoresizingMaskIntoConstraints = false
        total_count.textColor = .darkGray
        total_count.textAlignment = .center
        total_count.font = UIFont.boldSystemFont(ofSize: 10)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(total_count)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 85),
            
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            total_count.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            total_count.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            total_count.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            total_count.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with group: PhotoGroup?, total: Int) {
        if let group = group {
            titleLabel.text = group.rawValue.uppercased()
        }
        else {
            titleLabel.text = "Others"
        }
        total_count.text = "\(total) images"
    }
}
