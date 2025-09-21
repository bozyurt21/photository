<h1 align="center">photository</h1>

<h3 align="left">Contents</h3>

-  [App Description](#app-description)
-  [Home Screen](#home-screen)
-  [Group Detail Screen](#group-detail-screen)
-  [Image Detail Screen](#image-detail-screen)
-  [Step By Step Guide](#step-by-step-guide)
    * [1. Fetching Images](#1-fetching-images)
    * [2. Downloading Images](#2-downloading-images)
    * [3. Grouping Images](#3-grouping-images)
    * [4. Image Detail Screen](#4-image-detail-screen)
    * [5. Showing Downloading Process](#5-showing-downloading-process)
   


## App Description

In this app, user could download their images and based on their image description value, the image is going to be assigned to folders. To be able to achieve this, I have used **PHAsset** as a pointer to the actuall image which stores the metadata information. Also used **PHImageManager** to generate preview thumbnails with given PHAsset using requestImage method. requestImage simply gave me the image representation of the given asset.

## Home Screen
## Properties:
- **collectionView :** UICollectionView
- **groups :** [Photo Group?]
- **viewModel :** PhotoLibraryManager
  
## Methods:
### setupCollectionView():
Sets the collectionView item's properties so it will be shown in the screen correctly. Also register FolderCell object to create each collectionViewCell into the way that **FolderCell** configured.
### loadGroups():
Responsible to update each group object and add the photos when a new image added. Also reload the collectionView to update FolderCells as well.
### setupAddButton():
Sets the add button to the end.
### addImageTapped():
When user tapped the **add Image** button, addImageTapped method called to show the picker, close the picker after completion, add each asset using **addAsset** method in PhotoLibraryManager, load group's when processed finished and updates the Progress View so it will show the processed images.
### showProgress():
Creates **DownloadProgressBarController** and present the created progress screen.
### hideProgress():
Hides the created **DownloadProgressBarController**.

## Helper Classes:
## FolderCell:

**Doesn't require ant input parameters while created.**

Responsible for setting each CollectionView cell item. 

### Method

**configure():** Configures folder names. 

## DownloadProgressBar:

**Doesn't require ant input parameters while created.**

Create a Download modular screen so when user click on Add Image button, this screen will be shown until the download process ended. 

### Method

**updateProgress():** Update the progress screen so the percentage progress and the text that shown how many images has processed will be shown. 

## PhotoPicker:
### Properties

- onComplete : ([PHAsset]) -> Void
  
Creates **PHPickerViewController**, provided by the Photos library.

### Methods:

**All below has been added since they are requires by UIViewControllerRepresentable**

**makeUIViewController():** Creates UIViewController object **(PHPickerViewController)** and configure its initial state.


**updateUIViewController():** Updates the state of the UIViewController when new information added. Since it is Picker, it is going to dismissed when the items selected so it doens't have to update state therefore I have left it empty.

**makeCoordinator():** Creates Coordinator

**Coordinator:** Custom instance I use to communicate changes from my view controller to other parts of my code. **picker** method is responsible with fetching assets and returning the added assets.

## Group Detail Screen

### Properties:
* group : PhotoGroup
* viewModel : PhotoLibraryManager
* **photos : [AppPhoto] (already initialized. No need to initialize again while calling this class)**

Responsible for creating SwiftUI Group Detail screen where user can see the photos. PhotoView is responsible for configuring each image in the group grid. I have decided to use grid to show the images in group detail screen. When user click on any images, with using simple NavigationLink, I am forwarding the clicked PhotoView to its ImageDetailScreen. While sending to image detail screen, since I need to be able to scroll to the left and right I am sending the current index as well.

## Helper Classes

## PhotoView

### Properties:
* appPhoto : AppPhoto
* viewModel: PhotoLibraryManager
* image : UIImage

Responsible for configuring the images in GroupDetail screen.

### Methods:
There is no particular method but there is a LifeCycle method initialized since each time the GroupDetailScreen open, images should be fetched from assets so I decided to use **onApear** method since it would be more suitable for this situation. I need my images to be fetch every time a new PhotoView object appear.

## Image Detail Screen
## Properties:
* photos: [AppPhoto]
* startIndex : Int
* viewModel : PhotoLibraryManager
* **currentIndex : Int (state object to control UIChanges so each time the index of the current image change, this changes as well, no need to initialize)**

Uses TabView to make the images scrollable. Each image configured using **ScreenImage**

## Helper Classes:
## ScreenImage
### Properties:
* appPhoto : [appPhoto]
* viewModel : PhotoLibraryManager
* image : UIImage?

Configures each image's properties to make them full screen. Also fetches images when each ScreenImage view appear usinf the LifeCycle method onAppear, same as PhotoView.

## General Classes That Used In Nearly Every Object

## PhotoLibraryManager
### Properties:
* appPhotos : [AppPhoto]
* storageURL : URL
* **processed : Int already initialized, no need to reinitialize)**

Responisible for implenting properties and commands to notifies view of any state changes.

### Methods:
### init()
Initialize the file manager and create url to store to know where the data is so it can access it later and loads photos.

### addAsset(_ asset: PHAsset, total: Int, progressHandler: @escaping (Int, Int)->Void, completion: @escaping () -> Void)
Used to add new PHAsset's as **AppPhoto**, creates reliable hashes to group the added asset, add necessary parts to store the photo in JSON file such as its local identifier and group info. Also sends the information about the added asset numbers so the download progress bar would know how much assets added and finished the download progress on regards to that. Also saves the requested asset information to JSON file using **savePhotos** method.

### savePhotos()
Saves the created assets to JSON file using the AppPhoto object that stores the required information.

### loadPhotos()
Load the photos saved in JSON file for user to be able to see.

### fetchImage(for appPhoto: AppPhoto,targetSize: CGSize, completion: @escaping (UIImage?) -> Void)
fetches the AppPhoto image from local gallery since the information we store in JSON file is just the local identification of the image, meaning just the pointer object not the actual image. So this methods fetches the actual image from the local gallery.

## AppPhoto
### Properties
* id : String
* group : PhotoGroup?

This is just an object to store the PHAsset pointer information to be able to reach to the actual image later and to be able to store the information in JSON file.


## Step By Step Guide

## 1. Fetching Images

First, I have started with adding a simple button and a Scrollable Lazy Grid View to show each images downloaded by the user using another view called **PhotoView**. PhotoView determined how the images are going to be shown on the screen such as their sizes etc. and since image is an optional, there is a probability that the image might not exist which in this case shows gray color instead. Since we need to fetch the images from our JSON file, PhotoView calls **PhotoLibraryManager ViewModel's fetchImage method**. It is calling on the **onApper** because user must have seen the result on each time the PhotoView is appeared in screen rather than just when screen created or while it is dissapearing.

## 2. Downloading Images

When user click on the **+Add Photo** button, the sheet consisted of their gallery image is presented. It was necessary because otherwise user couldn't be able to pick photos from their gallery. Since the user should be able to pick their images in a view like object, I have added the **UIViewControllerRepresentabl**e protocole to **PhotoPicker**. **UIViewControllerRepresentable** protocol requires methods like **makeUIViewController**, **updateUIViewController** and **makeCoordinator** and a **Cordinator** class that has a **PHPickerViewControllerDelegate** method which responds to **PHPickerViewController** and knows when it is completed. On the closure, we are calling **PhotoLibraryManager ViewModel**'s **addAsset** method to be able to add asset to our JSON file so when the image has saved, even when user destroys the app it stays. 

addAsset method creates a new AppPhoto object which stores the information about a certain photo including its **PHAsset** metadata pointer. Then add the newly created photo to photo array then calls the **savePhotos** method.

**savePhotos** takes each AppPhoto object's id and put it in identifiers array so it will write it down to a JSON file to store the identifiers (id's) of the object so whe I called **loadPhotos** method (which is called in init method of PhotoLibraryManager and since it is declared as **StateObject** which means it is called every time the published property changed which is appPhotos or the identity of the view changes instead of every time the new input added to the view.) it creates PHAsset's using their identifier. Therefore, the images restored by the app itself.  

## 3. Grouping Images

After I have managed to download images, it was time to start working on grouping them and also putting those group folders in home screen so when user click on each group folder, they would see the images in that specific group. While downloading and fetching images I have worked on GroupDetailScreen since for now, there was no groups existed and I have just checked the fact that if I could download images or not.

Since I haven't worked with groups, first, I have added group info to **AppPhoto** data object. I have also remove the asset property since it couldn't be codable and also I am already fetching images to add image then reloading using the id so it was unnecessary to store the asset information rather than storing group and making AppPhoto codable to store more easily in JSON file.

After I added the group info, I just add the group info each time I add new asset to photos using **addAsset** method in **PhotoLibraryViewModel** then wrote it into Text right after the photo istelf to see if it is working and indeed it was working so I have started working on Home Screen.

Home Screen must have a folders in a grid (which was my idea since I liked the idea of using grid rather then a TableView list). In the pdf, it is said that we must use **UICollectionView** in HomePage and HomePage should be written in UIKit rather than SwiftUI. HomeScreen inherited **UIViewController** class since it is a UIKit view. I have first started with seting the UICollectionView up, and to do that, I have determined the spacing and item width for UICollectionFlowLayout since each UICollectionView is going to be put in there. After that, I have created UICollectionView and make the dataSource and delegate of the UICollectionView to itself and added to UICollectionFlowLayout as subView so it will shown.

To be able to show the groups as folders, I need to know the groups existed in all photos so I map each photo's group name and since there are more than one photo in each group, I must use set to **ensure the uniqueness of the folder groups**. Also setted up the **addButton** as well and added with UIKit instead of using SwiftUI. Since the functionallity of the button haven't change, I just added the same functionality with minor changes.

Then it was time to send the photos to their designated **GroupDetailScreen**. To manage that, I have used **UIHostingController** since I was going to navigate to a SwiftUI view inside UIKit view and change the root from homeScreen to GroupDetailScreen. I have also sended the group name to GroupDetailScreen while navigating since I must see the photo's in certain group and used this group information to filter the photos to be shown inside the folder. Since I have added other as nil, I have used optional group name and determined the charatheristic based on that. Since the groupDetail must be send when a folder is clicked, I have used used **delegate** methods so each time user clicked on any folder, this information would be send to the GroupDetailScreen and it will navigate to that screen as well.

## 4. Image Detail Screen

After I have successfully manage to group images, it was time for me to work on image detail screen. Since both GroupDetailScreen and ImageDetailScreen were SwiftUI views, I have used NavigationLink directly to navigate in between. Therefore each time user click on image, the app navigate to ImageDetailScreen. In ImageDetailScreen, I have used TabView, since the images should be scrollable. To be able to do that, I needed to know the current index of the image in Photo's array so I have used enumerator method to gave me tuple of indexes and AppPhoto's as well but since enumerator method's output is not identifieable, I needed to declare that each element's id is their own identifier both in GroupDetailScreen and ImageDetailScreen since I should know the start index as well which is going to be sent by the GroupDetailScreen to ImageDetailScreen.

## 5. Showing Downloading Process

When ImageDetailScreen impelentation has done, I have decided to work on download progress bar. I wanted it to be shown on the screen when user add image so I have started implementing it on Home Screen. First, I have started with adding image count informations below the folders so it would be easier for me to track down if the download progress bar works correctly. After I finished configuring the download progress bar view, I have started on working how can I add it. I knew I needed to know the total images selected from the picker so I needed to show the progress bar when user selected the images from the picker. First, I have tried to implemented it in the picker method updateUIViewController since it would be called when the state of the picker has changed but it did not worked since when I call it, the picker was already dismissed. Then I have realized, I am already calling the picker on HomeScreen and if I would add the total count to add assets then I could update the progress bar using progressHandler with the information of assets added and the total assets selected. So progressHandler function will take the inputs, inform the functions inside about the change. Since the progress finished when all the images processed, it is not synchronious function, I need to update the progress for every image added not just for one image. The problems I encounter while implementing the functionality were when I added the second time, since at first I was tracking the image added by counting the images in photos, it was not been able to complete because processed and total were never become equal. I have decided to use a private processed instance in PhotoLibraryManager instead and track down the images that proceed by adding one. Even though it solves the problem I was having with adding images second time, it was not being able to solve the problem of adding same images for the second time. Since I was increasing the number of items that proceed when I add a new item, it was not being able to equal to total still so I have decided to add one to proceed anyway and when I done it, it had solved the problem but then I have realized, even though the downloaded ended, the group counts info was not updated unless I reopen the app which means the collection view and group's reloaded which wasn't happening after I have added the images since I was not calling the function inside the progressHandler clousure. When I added the functions inside the clousure, the app was working as I intended.


