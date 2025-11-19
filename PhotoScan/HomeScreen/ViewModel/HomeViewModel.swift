//
//  HomeViewModel.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 19.11.2025.
//

import Foundation
import UIKit
import CoreData
import Photos


class HomeViewModel {
    weak var delegate : HomeViewModelDelegate?
    private let photoLibrary : PhotoLibraryViewModel
    var groups : [PhotoGroup?] = []
    var totalPhotoCount : Int {
        photoLibrary.appPhotos.count
    }
    
    init(photoLibrary: PhotoLibraryViewModel = PhotoLibraryViewModel()) {
        self.photoLibrary = photoLibrary
        loadGroups()
    }
    
    // MARK: General Functions
    // returns the selected group
    func selectedGroup(at index: Int) -> PhotoGroup? {
        return groups[index]
    }
    
    // Returns the number of groups
    func numberOfGroups() -> Int {
        return groups.count
    }
    
    // Returns Photo's for group
    func photosForGroup(for group: PhotoGroup?) -> [AppPhoto] {
        let name = group?.rawValue ?? "Other"
        return photoLibrary.appPhotos.filter { $0.groupName == name }
    }
    
    // Returns the Photo Count For Group
    func photoCountForGroup(for group: PhotoGroup?) -> Int {
        let name = group?.rawValue ?? "Other"
        return photoLibrary.appPhotos.filter { $0.groupName == name }.count
    }
    // MARK: Group Functions
    func loadGroups() {
        let photos = photoLibrary.appPhotos
        
        groups = photos.compactMap { PhotoGroup.group(for: $0.groupHash)}.reduce(into: Set<PhotoGroup>()) { $0.insert($1) }
            .sorted { $0.rawValue < $1.rawValue }
        
        if photos.contains(where:{ PhotoGroup.group(for:$0.groupHash) == nil}) {
            groups.append(nil)
        }
        delegate?.homeViewModelDidUpdateGroups(self)
    }
    // MARK: Inserting Asset
    func importAsset(_ assets: [PHAsset]) {
        // Look if the photos are chosen or not
        guard !assets.isEmpty else { return }
        
        delegate?.homeViewModelDidStartImport(self, total: assets.count)
        for asset in assets {
            photoLibrary.addAsset(asset, total: assets.count, progressHandler: { [weak self] processed, total in
                guard let self = self else { return }
                self.delegate?.homeViewModel(self, didUpdateProgress: processed, total: total)
                self.delegate?.homeViewModelDidUpdateGroups(self)
                self.loadGroups()
                
            },completion : { [weak self] in
                guard let self = self else { return }
                self.delegate?.homeViewModelDidUpdateGroups(self)
                self.delegate?.homeViewModelDidFinishImport(self)
                self.loadGroups()
            })
        }
    }
}

protocol HomeViewModelDelegate: AnyObject {
    func homeViewModelDidUpdateGroups(_ viewModel: HomeViewModel)
    func homeViewModelDidStartImport(_ viewModel: HomeViewModel, total: Int)
    func homeViewModel(_ viewModel: HomeViewModel,
                       didUpdateProgress processed: Int,
                       total: Int)
    func homeViewModelDidFinishImport(_ viewModel: HomeViewModel)
}
