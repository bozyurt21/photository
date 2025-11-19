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
    private let context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    
    init(group : PhotoGroup?, appPhotos : [AppPhoto]) {
        self.group = group
        self.appPhotos = appPhotos
    }
    
    // Deletes Photo from Core Data
    /*
        Param:
            Input -> appPhoto: AppPhoto
            Output-> None
     */
    func deletePhoto(appPhoto : AppPhoto) {
        context.delete(appPhoto) //deletes app Photo.
        appPhotos.removeAll { $0.id == appPhoto.id } // remove the app photo from the appPhoto array as well
        saveContext()
    }
    
    
    func saveContext() {
        do {
            try context.save()
        }
        catch {
            print("Error While Trying to Save Context")
        }
    }
    
}
