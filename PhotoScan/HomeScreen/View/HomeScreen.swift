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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadGroups()
    }
    // MARK: Setting Collection View
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        let itemWidth = (view.bounds.width - (spacing * 4)) / 3   //determines the width of the folder
        layout.itemSize = CGSize(width: itemWidth, height: 140)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
            
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FolderCell.self, forCellWithReuseIdentifier: "FolderCell") //I have decided to use Folder Cell for each item in collection view
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 100, right: 0)
        view.addSubview(collectionView) // adds collection view to the view
            
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Setting Add Button
    private func setupAddButton() {
        
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "camera.fill"), for: .normal) //image
        addButton.tintColor = .white // image color
        addButton.setTitleColor(.white, for: .normal) // title color
        addButton.backgroundColor = UIColor(named: "buttonColor")  //color
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.layer.cornerRadius = 25
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)  // method call

        view.addSubview(addButton) // adds the add button to view.
        // constraints
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 50),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: Method called when you click on camera button
    // Open picker view, adds selected images to the photos, shows picker.
    /*
         Param:
            Input -> None
            Output -> None
     */
    @objc private func addImageTapped() {
        PHPhotoLibrary.requestAuthorization { status in // asks for authorization
            if status == .authorized || status == .limited { // if full authorization is given or given as limited
                DispatchQueue.main.async {
                    // select item from photo picker
                    let picker = PhotoPicker { assets in
                        self.dismiss(animated: true) {
                            self.viewModel.importAsset(assets) // add images added from the photo picker to our photos (look HomeScreenViewModel for further investigation)
                        }
                    }
                    let hostingPicker = UIHostingController(rootView: picker)
                    hostingPicker.modalPresentationStyle = .pageSheet
                    self.present(hostingPicker, animated: true)
                }
            }
        }
    }
    
    
    // MARK: Methods to show/hide Download Progress Bar
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

// MARK: Collection View
extension HomeScreen : UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Method that returns the group count for section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    // Initialize each cell as Folder Cell
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
        let group = groups[indexPath.row]
        let totalForThisGroup = viewModel.photoCountForGroup(for: group)
        cell.configure(with: group, total: totalForThisGroup)
        return cell
    }
    
    // Initialize what should happen when someone click on any of the cells
    // The method takes the selected cell's group name and navigate to respective group detail screen to show images in that group
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGroup = groups[indexPath.row]
        photosForGroup = viewModel.photosForGroup(for: selectedGroup)
        let detailView = GroupDetailScreen(group: selectedGroup, photos: photosForGroup!)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

// MARK: Home Screen Delegate Mehods for HomeScreenViewModel
extension HomeScreen : HomeViewModelDelegate {
    // When there is an update in groups
    func homeViewModelDidUpdateGroups(_ viewModel: HomeViewModel) {
        groups = viewModel.groups // initilize group as viewModel group which has been taken from the database.
        collectionView.reloadData()
    }
    
    // When start importing photos selected from the local library
    func homeViewModelDidStartImport(_ viewModel: HomeViewModel, total: Int) {
        showProgress(total: total) // start showing the download progress
    }
    
    // Update progress bar by each photos added
    func homeViewModel(_ viewModel: HomeViewModel, didUpdateProgress processed: Int, total: Int) {
        progressBar?.updateProgress(processed: processed, total: total)
    }
    
    // When import is ended
    func homeViewModelDidFinishImport(_ viewModel: HomeViewModel) {
        hideProgress() // hide the progress bar.
    }
}

