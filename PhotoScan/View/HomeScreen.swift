//
//  HomeScreenController.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 17.09.2025.
//

import Foundation
import UIKit
import SwiftUI
import Photos

class HomeScreen: UIViewController {
    
    private var collectionView: UICollectionView!
    private var groups: [PhotoGroup?] = []
    private let viewModel = PhotoLibraryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group Folders"
        view.backgroundColor = .systemBackground
        setupCollectionView()
        loadGroups()
        setupAddButton()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let itemWidth = (view.bounds.width - (spacing * 4)) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
            
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FolderCell.self, forCellWithReuseIdentifier: "FolderCell")
            
        view.addSubview(collectionView)
            
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadGroups() {
            // Example: filter groups that actually have photos
            groups = viewModel.appPhotos
                .compactMap { $0.group }
                .reduce(into: Set<PhotoGroup>()) { $0.insert($1) }
                .sorted { $0.rawValue < $1.rawValue }
            
            // Always include "Others" if needed
            if viewModel.appPhotos.contains(where: { $0.group == nil }) {
                groups.append(nil)
            }
            
            collectionView.reloadData()
    }
    
    private func setupAddButton() {
        let addButton = UIButton(type: .system)
        addButton.setTitle("+ Add Images", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = UIColor(named: "mainColor")
        addButton.layer.cornerRadius = 12
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)

        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func addImageTapped() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                DispatchQueue.main.async {
                    let picker = PhotoPicker { assets in
                        for asset in assets {
                            self.viewModel.addAsset(asset)
                        }
                        self.loadGroups()
                    }
                    let hostingPicker = UIHostingController(rootView: picker)
                    hostingPicker.modalPresentationStyle = .pageSheet
                    self.present(hostingPicker, animated: true)
                }
            }
        }
    }
    
    
}

extension HomeScreen : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
        let group = groups[indexPath.row]
        cell.configure(with: group)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGroup = groups[indexPath.row]
        
        let detailView = GroupDetailScreen(group: selectedGroup, viewModel: viewModel)
        
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

