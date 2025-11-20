//
//  GroupDetailViewModel.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 19.11.2025.
//

import Foundation
import CoreData

class GroupDetailViewModel : ObservableObject {
    let group : PhotoGroup?
    @Published var appPhotos : [AppPhoto]
    private let photoLibrary : PhotoLibraryViewModel
    
    
    init(group : PhotoGroup?, appPhotos : [AppPhoto], photoLibrary : PhotoLibraryViewModel) {
        self.group = group
        self.appPhotos = appPhotos
        self.photoLibrary = photoLibrary
    }
    
    // Deletes Photo from Core Data
    /*
        Param:
            Input -> appPhoto: AppPhoto
            Output-> None
     */
    func deletePhoto(appPhoto : AppPhoto) {
        photoLibrary.deletePhoto(appPhoto: appPhoto)
        appPhotos.removeAll { $0.id == appPhoto.id } // remove the app photo from the appPhoto array as well
    }
    
}
