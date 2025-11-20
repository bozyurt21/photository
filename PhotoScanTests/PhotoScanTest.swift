//
//  PhotoScanTest.swift
//  PhotoScan
//
//  Created by Bensu Özyurt on 21.11.2025.
//

import Testing
@testable import PhotoScan

import CoreData

// MARK: - Mock PhotoLibraryViewModel

final class MockPhotoLibraryViewModel: PhotoLibraryViewModel {
    init() {
        super.init(context: PersistenceController(inMemory: true).container.viewContext)
        self.appPhotos = []
    }

}

// MARK: - HomeScreen Tests

struct HomeScreenTest {
    
    private func makePhoto(_ id: String,_ hash: Double,_ groupName: String,_ context: NSManagedObjectContext) -> AppPhoto {
        let photo = AppPhoto(context: context)
        photo.id = id
        photo.groupHash = hash
        let group = PhotoGroup.group(for: hash)
        photo.groupName = group?.rawValue ?? "Other"
        photo.creationDate = Date()
        return photo
    }
    
    @Test func testSelectedGroup() async throws{
        // Given
        let library = MockPhotoLibraryViewModel()
        let ctx = library.context
        
        library.appPhotos = [
            makePhoto("1", 0.003, "a", ctx),
            makePhoto("2", 0.004, "a", ctx),
            makePhoto("3", 0.005, "a", ctx),
            makePhoto("4", 0.034, "b", ctx),
            makePhoto("5", 0.07, "Other", ctx)
        ]
        
        let viewModel = HomeViewModel(photoLibrary: library)
        
        // When
        viewModel.loadGroups()
        
        // Then
        #expect(viewModel.groups.count == 3)
        #expect(viewModel.groups.contains { $0 == nil })  // Other group exists
    }
    
    @Test func testGroupCount() async throws{
        // Given: multiple photos in distinct groups + Other
        let library = MockPhotoLibraryViewModel()
        let ctx = library.context
        
        library.appPhotos = [
            makePhoto("1", 0.003, "a", ctx),
            makePhoto("2", 0.052, "c", ctx),
            makePhoto("3", 0.058, "c", ctx),
            makePhoto("4", 0.176, "g", ctx),
            makePhoto("5", 0.23, "Other", ctx)
        ]
        
        let viewModel = HomeViewModel(photoLibrary: library)
        
        // When
        viewModel.loadGroups()
        
        // Then
        // Expect 4 groups: 3 non-nil, plus Other(nil)
        #expect(viewModel.groups.count == 4)
        #expect(viewModel.groups.contains { $0 == nil })
    }
    
    @Test func testPhotosForGroup() async throws{
        // Given
        let library = MockPhotoLibraryViewModel()
        let ctx = library.context
        
        library.appPhotos = [
            makePhoto("1", 0.003, "a", ctx),
            makePhoto("2", 0.004, "a", ctx),
            makePhoto("3", 0.051, "b", ctx),
            makePhoto("4", 0.99, "Other", ctx)
        ]
        
        let viewModel = HomeViewModel(photoLibrary: library)
        viewModel.loadGroups()

        // Pick the first non-nil group from groups
        guard let someGroup = viewModel.groups.first(where: { $0 != nil }) ?? nil else {
            #expect(Bool(false), "Expected at least one non-nil group")
            return
        }

        // When
        let photosInGroup = viewModel.photosForGroup(for: someGroup)


        // Then
        #expect(!photosInGroup.isEmpty)
    }
    
    @Test func testPhotoCountForGroup() async throws{
        // Given
        let library = MockPhotoLibraryViewModel()
        let ctx = library.context
        
        library.appPhotos = [
            makePhoto("1", 0.003, "a", ctx),
            makePhoto("2", 0.004, "a", ctx),
            makePhoto("3", 0.051, "b", ctx),
            makePhoto("4", 0.052, "b", ctx),
            makePhoto("5", 0.9, "Other", ctx)
        ]
           
        let viewModel = HomeViewModel(photoLibrary: library)
        viewModel.loadGroups()

        let someGroup = viewModel.groups.first(where: { $0 != nil }) ?? nil

        // Then
        if let someGroup {
            let count = viewModel.photoCountForGroup(for: someGroup)
            #expect(count > 0)
        } else {
            #expect(Bool(false), "Expected at least one non-nil group")
        }

        // nil => Other
    }
    
    @Test func testTotalPhotoCountMatchesAppPhotos() async throws{
        // Given
        let library = MockPhotoLibraryViewModel()
        let ctx = library.context
        
        library.appPhotos = [
            makePhoto("1", 0.003, "a", ctx),
            makePhoto("2", 0.051, "b", ctx),
            makePhoto("3", 0.9, "Other", ctx)
        ]
        
        let viewModel = HomeViewModel(photoLibrary: library)
        
        // Then
        #expect(viewModel.totalPhotoCount == 3)
    }
}

struct GroupDetailScreenUITests {
    
    private func makeContext() -> NSManagedObjectContext {
        let persistence = PersistenceController(inMemory: true)
        return persistence.container.viewContext
    }
        
    private func makePhoto(_ id: String,_ hash: Double, _ groupName: String, _ context: NSManagedObjectContext) -> AppPhoto {
        let photo = AppPhoto(context: context)
        photo.id = id
        photo.groupHash = hash
        photo.groupName = groupName
        photo.creationDate = Date()
        return photo
    }
    
    @Test func testDeletePhoto() async throws {
        // Given
        let library = MockPhotoLibraryViewModel()
        let context = library.context
        let p1 = makePhoto("1", 0.003, "a", context)
        let p2 = makePhoto("2", 0.004, "a", context)
        let p3 = makePhoto("3", 0.051, "b", context)
        let p4 = makePhoto("4", 0.052, "b", context)
        let p5 = makePhoto("5", 0.9, "Other", context)
        let viewModel = GroupDetailViewModel(group: nil, appPhotos: [p1,p2,p3,p4,p5], photoLibrary : library)
        // When
        viewModel.deletePhoto(appPhoto: p1)
        // Then
        #expect(viewModel.appPhotos.count == 4)
        #expect(viewModel.appPhotos.first?.id == "2")
        
    }
}
