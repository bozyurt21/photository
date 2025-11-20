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
    
    // Returns the selected group
    /*
        Param:
            Input-> index: Int (index of the selected photo)
            Output-> group: PhotoGroup? (Photo group stored in groups array) (IMPORTANT!!! it can be nil, if it is nil then it belongs to other.)
     */
    
    func selectedGroup(at index: Int) -> PhotoGroup? {
        return groups[index]
    }
    
    
    // Returns the number of groups
    /*
        Param:
            Input-> None
            Output-> totalGroup: Int
     */
    
    func numberOfGroups() -> Int {
        return groups.count
    }
    
    // Returns Photo's for group
    /*
        Param:
            Input-> group : PhotoGroup?
            Output-> PhotoForGroup: [AppPhoto] (it returns the photos of the group that is nil as well since it is declared as Other in AppPhoto's)
     */
    func photosForGroup(for group: PhotoGroup?) -> [AppPhoto] {
        let name = group?.rawValue ?? "Other"
        return photoLibrary.appPhotos.filter { $0.groupName == name }
    }
    
    // Returns the Photo Count For Group
    /*
        Param:
            Input-> group : PhotoGroup?
            Output-> totalPhotoInGroup : Int (it returns the total photos of the group that is nil as well since it is declared as Other in AppPhoto's)
     */
    func photoCountForGroup(for group: PhotoGroup?) -> Int {
        let name = group?.rawValue ?? "Other"
        return photoLibrary.appPhotos.filter { $0.groupName == name }.count
    }
    
    
    // MARK: Group Functions
    // Loads Groups from the storage
    /*
        Param:
            Input-> None
            Output-> None
     */
    // Although it does not return anything nor take anything, it calls delegate method homeViewModelDidUpdateGroups
    // Reason is because load groups will update the groups array consist of PhotoGroup
     
    func loadGroups() {
        let photos = photoLibrary.appPhotos // For Photos
        // Select the group names from the hash stored in each AppPhoto's, do not take duplicates (reduce to set)
        groups = photos.compactMap { PhotoGroup.group(for: $0.groupHash)}.reduce(into: Set<PhotoGroup>()) { $0.insert($1) }
            .sorted { $0.rawValue < $1.rawValue }
        
        // If the groupHash returns nil then we need to add the nil group as well since I choose to handle group names based on if the group is nil or not.
        // if it is nil then the group name is other.
        if photos.contains(where:{ PhotoGroup.group(for:$0.groupHash) == nil}) {
            groups.append(nil)
        }
        delegate?.homeViewModelDidUpdateGroups(self)
    }
    
    func loadPhotos() {
        photoLibrary.loadPhotos()
    }
    // MARK: Inserting Asset
    // Imports the image asset to the appPhotos
    /*
        Param:
            Input-> asset : [PHAsset]
            Output-> None
     */
    
    func importAsset(_ assets: [PHAsset]) {
        // Look if the photos are chosen or not
        guard !assets.isEmpty else { return }
        
        delegate?.homeViewModelDidStartImport(self, total: assets.count) // start importing since there is asset
        for asset in assets { // for every asset
            
            // add the asset to storage
            photoLibrary.addAsset(asset, total: assets.count, progressHandler: { [weak self] processed, total in
                guard let self = self else { return }
                self.delegate?.homeViewModel(self, didUpdateProgress: processed, total: total) // responsible for updating the progress bar
                self.loadGroups() // load groups that are added thanks to newly imported assets
                self.delegate?.homeViewModelDidUpdateGroups(self) // responsible for updating the groups
                
            },completion : { [weak self] in
                guard let self = self else { return }
                self.delegate?.homeViewModelDidUpdateGroups(self) // responsible for updating the groups for any case
                self.delegate?.homeViewModelDidFinishImport(self) // finish importing assets, hide progress bar since the import completed
                self.loadGroups() // load groups for any case
            })
        }
    }
}

// MARK: Home View Model Delegate Protocol
protocol HomeViewModelDelegate: AnyObject {
    func homeViewModelDidUpdateGroups(_ viewModel: HomeViewModel)                                  // responsible for updating the groups
    func homeViewModelDidStartImport(_ viewModel: HomeViewModel, total: Int)                      // responsible for showing progress bar
    func homeViewModel(_ viewModel: HomeViewModel,didUpdateProgress processed: Int, total: Int)  // responsible for updating the progress bar
    func homeViewModelDidFinishImport(_ viewModel: HomeViewModel)                               // responsible for hiding download progress since it finished
}
