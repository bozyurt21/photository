# Photository

Photository is an iOS app that scans the user’s photo library, computes hash value for each photo, and groups photos into folders based on those values.


---

## Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Data Model](#data-model)
- [Scanning & Grouping](#scanning--grouping)
- [UI Flow](#ui-flow)
- [Performance & Memory Considerations](#performance--memory-considerations)
- [Potential Extensions](#potential-extensions)

---

## Overview

- Scans user-selected photos from the system photo library (`PHAsset`).
- Computes hash value using the provided `reliableHash()` helper.
- Maps each photo into a `PhotoGroup` or **Other** if no hashes matches.
- Shows live, incremental results while scanning:
  - Group folders update as photos are processed.
  - A progress view shows `processed / total` photos. (A method added to remove the ones already added to be shown in progress)
- Stores all scanned photos in Core Data so the results remain after app relaunch.
- Views photos full-screen
- Horizontal swips between photos
- Delete photos from a group.

Minimum iOS: **15.0**  
Language: **Swift**  
Architecture: **MVVM**, UIKit + SwiftUI  
Persistence: **Core Data**

---

## Architecture

The project is split into three main layers:

### 1. App Layer (`App/`)

- `PhotoScanApp`: Entry point and initial navigation setup.
- `PersistenceController`: Configures the Core Data.
- `CaseHelper`: Contains the provided `PHAsset.reliableHash()` and `PhotoGroup` helper logic.

### 2. Core Layer (`Core/`)

**Model**

- `AppPhoto` (Core Data entity stored in PhotoStorage)
  - `id` – `PHAsset` local identifier.
  - `groupHash` – hash value used for grouping.
  - `groupName` – group name determined by the hash value.
  - `creationDate` – original creation date, displayed in the detail view.

**ViewModel**

- `PhotoLibraryViewModel`
  - Includes all the methods related to `AppPhoto` objects. (Core Data related code stored in here)
  - Responsible for:
    - Adding new assets, computing hashes, and assigning `PhotoGroup`s.
    - Adds photos to Core Data.
    - Loads existing photos on startup.
    - Fetchs `UIImage` instances for a given `AppPhoto` via `PHImageManager`. (Since this method used in both `Group Detail Screen` and `Image Detail Screen` I couldn't seperate it from the main view model.) 

This separation keeps photo storage / hashing / persistence out of the UI and makes it easy to reuse across screens.

### 3. Screens

Each screen has its own folder with `View` and `ViewModel` subfolders:

- **HomeScreen**
  - `HomeScreen` (UIKit , UIViewController)
    - Shows `UICollectionView` of folders.
    - Includes UI design.
  - `HomeViewModel`
    - Reads from `PhotoLibraryViewModel` and computes:
      - Available `groups: [PhotoGroup?]`. (Decided to include **nil** object to determine **Others** group)
      - Photo counts per group.
    - Handles photo picker view.
    - Uses a delegate (`HomeViewModelDelegate`) to:
      - Start / update / finish the progress view.
      - Notify the controller when groups change.
      - **Used delegate method instead of Combine since this is UIKit Screen**

- **GroupDetailScreen**
  - `GroupDetailScreen` (SwiftUI)
    - Displays a grid of photos for a selected group.
    - Navigates to `ImageDetailScreen` on tap.
    - Provides a context menu to delete a photo meaning when user hold on any photos they are able to delete the photo from the storage.
  - `PhotoView` (SwiftUI)
    - Includes design of each image in GroupDetailScreen. 
  - `GroupDetailViewModel`
    - Owns the group’s `AppPhoto` list.
    - Deletes photos from Core Data and updates the local array.
    - Dismisses the screen automatically when the last photo in the group is deleted.
    - Uses `Combine` for updating views when there is change in Published instances.

- **ImageDetailScreen**
  - `ImageDetailScreen` (SwiftUI)
    - Full-screen photo viewer using `TabView` with `PageTabViewStyle`.
    - Supports horizontal swiping within the group.
  - `ScreenImage` (SwiftUI)
    - Fetches and displays the full-size image for one `AppPhoto` using `PhotoLibraryViewModel`.
    - 
**UIKit ↔ SwiftUI bridging is done via `UIHostingController` when pushing the SwiftUI Group Detail screen from the UIKit Home screen.**

---

## Data Model

Although JSON file used to store images before, this implementation uses **Core Data** to make it easier to delete, create and update data objects:

- All scanned photos are stored as `AppPhoto` entities.
- On launch, `PhotoLibraryViewModel.loadPhotos()` fetches existing photos from Core Data into memory.
- Group information is derived from the stored `groupHash` with `PhotoGroup.group(for:)`, so grouping can be reload or changed without touching the raw image data.

This means:
- Grouping results are stored via AppPhoto object in memory.
- Already-processed photos are not duplicated; the view model keeps track of processed vs. already-existing assets.

---

## Scanning & Grouping

1. **Selecting photos**
   - The user taps the camera button on the Home screen.
   - A `PHPickerViewController` lets the user select any number of photos.
   - The picker returns an array of `PHAsset` objects.

2. **Importing assets**
   - `HomeViewModel.importAsset(_:)` is called with the selected assets.
   - The view model notifies the controller to show the `DownloadProgressBarController` by delegate methods.

3. **Processing each asset**
   - For every `PHAsset`:
     - `PhotoLibraryViewModel.addAsset(_:total:progressHandler:completion:)`:
       - Requests a thumbnail via `PHImageManager`.
       - Computes hash value of the photo using `asset.reliableHash()`.
       - Maps the hash to a `PhotoGroup` via `PhotoGroup.group(for:)`.
       - Creates and saves an `AppPhoto` in Core Data (skipping those already stored).
       - Updates internal counters (`processed`, `alreadyProcessed`) to keep progress accurate even if some assets were imported previously.
       - Calls the `progressHandler(processed, effectiveTotal)` closure.

4. **Live updates**
   - The Home screen’s delegate methods:
     - Update the progress bar (`processed / total`).
     - Recompute group folders (`loadGroups()`) and reload the collection view so folders and counts reflect newly processed photos in real time.
   - When processing finishes, the delegate hides the progress view.
     
---

## UI Flow

1. **Home Screen (UIKit)**
   - Grid of folder cells (`FolderCell`), one per group.
   - Each folder shows:
     - Group name (or **Other**).
     - Total number of photos in that group.
   - Tapping a folder pushes a `UIHostingController` with `GroupDetailScreen`.

2. **Group Detail (SwiftUI)**
   - `LazyVGrid` of `PhotoView` tiles.
   - Each tile loads a thumbnail via `PhotoLibraryViewModel.fetchImage`.
   - Tap → navigates to `ImageDetailScreen` for that group.
   - Long-press (context menu) → delete photo from the group.
   - If a group becomes empty, the view dismisses, and the Home screen will no longer show that folder.

3. **Image Detail (SwiftUI)**
   - Horizontal paging between full-screen photos in that group using `TabView`.
   - Each page is a `ScreenImage` that loads the image lazily and shows the creation date.

---

## Performance & Memory Considerations

- Uses `PHAsset` + `PHImageManager` instead of storing image binaries in Core Data.
- Thumbnails and full-size images are requested with explicit `targetSize` to avoid inconsitent UI design.
- Image loading is asynchronous and on-demand in SwiftUI views (`onAppear`), so only currently visible cells allocate images.
- The hash helper intentionally simulates processing delay; the app is designed to:
  - Keep the UI responsive.
  - Provide progressive feedback through the progress bar and live group updates.

---

## Potential Extensions:

- Add unit tests for:
  - `PhotoGroup.group(for:)` mapping.
  - Import logic (duplicate handling, group creation).
- Add richer metadata and search (e.g., by date range).
- Allow users to attach notes to photos for more personal context.
- Add multi-select delete on the Group Detail screen.


