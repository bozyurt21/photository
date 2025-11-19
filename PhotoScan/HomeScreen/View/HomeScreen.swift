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
    private let viewModel = HomeViewModel()
    private var progressBar : DownloadProgressBarController?
    private var photosForGroup : [AppPhoto]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        title = "Group Folders (total: \(viewModel.totalPhotoCount) images)"
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupAddButton()
        viewModel.loadGroups()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        let itemWidth = (view.bounds.width - (spacing * 4)) / 3
        layout.itemSize = CGSize(width: itemWidth, height: 140)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
            
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FolderCell.self, forCellWithReuseIdentifier: "FolderCell")
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 100, right: 0)
        view.addSubview(collectionView)
            
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func setupAddButton() {
        
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        addButton.tintColor = .white
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = UIColor(named: "buttonColor")
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.layer.cornerRadius = 25
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)

        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func addImageTapped() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                DispatchQueue.main.async {
                    let picker = PhotoPicker { assets in
                        self.dismiss(animated: true) {
                            self.viewModel.importAsset(assets)
                        }
                    }
                    let hostingPicker = UIHostingController(rootView: picker)
                    hostingPicker.modalPresentationStyle = .pageSheet
                    self.present(hostingPicker, animated: true)
                }
            }
        }
    }
    
    // This part is where the groups load!
    
    private func showProgress(total: Int) {
            let vc = DownloadProgressBarController()
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
            progressBar = vc
    }

    private func hideProgress() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressBar?.dismiss(animated: true)
            self.progressBar = nil
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
        let totalForThisGroup = viewModel.photoCountForGroup(for: group)
        cell.configure(with: group, total: totalForThisGroup)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGroup = groups[indexPath.row]
        photosForGroup = viewModel.photosForGroup(for: selectedGroup)
        let detailView = GroupDetailScreen(group: selectedGroup, photos: photosForGroup!, viewModel: PhotoLibraryViewModel())
        
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

extension HomeScreen : HomeViewModelDelegate {
    func homeViewModelDidUpdateGroups(_ viewModel: HomeViewModel) {
        groups = viewModel.groups
        collectionView.reloadData()
        
    }
    func homeViewModelDidStartImport(_ viewModel: HomeViewModel, total: Int) {
        showProgress(total: total)
    }
    func homeViewModel(_ viewModel: HomeViewModel, didUpdateProgress processed: Int, total: Int) {
        progressBar?.updateProgress(processed: processed, total: total)
    }
    func homeViewModelDidFinishImport(_ viewModel: HomeViewModel) {
        hideProgress()
    }
}

