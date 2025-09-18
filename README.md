<h1 align="center">photository</h1>

<h3 align="left">Contents</h3>

-  [App Description]("app-description")
-  [Step By Step Guide]("step-by-step-guide")
-  [How did I manage to download images from the local image library?]("how-did-i-manage-to-download-images-from-local-image-library?")
-  [How did I manage to fetch images into screen?]("how-did-i-manage-to-fetch-images-into-screen?")


## App Description

In this app, user could download their images and based on their image description value, the image is going to be assigned to folders. To be able to achieve this, I have used **PHAsset** as a pointer to the actuall image which stores the metadata information. Also used **PHImageManager** to generate preview thumbnails with given PHAsset using requestImage method. requestImage simply gave me the image representation of the given asset.

## Home Screen
## Group Detail Screen
## Image Detail Screen

## Step By Step Guide

### 1. Managing Fetching Images

First, I have started with adding a simple button and a Scrollable Lazy Grid View to show each images downloaded by the user using another view called **PhotoView**. PhotoView determined how the images are going to be shown on the screen such as their sizes etc. and since image is an optional, there is a probability that the image might not exist which in this case shows gray color instead. Since we need to fetch the images from our JSON file, PhotoView calls **PhotoLibraryManager ViewModel's fetchImage method**. It is calling on the **onApper** because user must have seen the result on each time the PhotoView is appeared in screen rather than just when screen created or while it is dissapearing.

### 2. Managing Downloading Images

When user click on the **+Add Photo** button, the sheet consisted of their gallery image is presented. It was necessary because otherwise user couldn't be able to pick photos from their gallery. Since the user should be able to pick their images in a view like object, I have added the **UIViewControllerRepresentabl**e protocole to **PhotoPicker**. **UIViewControllerRepresentable** protocol requires methods like **makeUIViewController**, **updateUIViewController** and **makeCoordinator** and a **Cordinator** class that has a **PHPickerViewControllerDelegate** method which responds to **PHPickerViewController** and knows when it is completed. On the closure, we are calling **PhotoLibraryManager ViewModel**'s **addAsset** method to be able to add asset to our JSON file so when the image has saved, even when user destroys the app it stays. 

addAsset method creates a new AppPhoto object which stores the information about a certain photo including its **PHAsset** metadata pointer. Then add the newly created photo to photo array then calls the **savePhotos** method.

**savePhotos** takes each AppPhoto object's id and put it in identifiers array so it will write it down to a JSON file to store the identifiers (id's) of the object so whe I called **loadPhotos** method (which is called in init method of PhotoLibraryManager and since it is declared as **StateObject** which means it is called every time the published property changed which is appPhotos or the identity of the view changes instead of every time the new input added to the view.) it creates PHAsset's using their identifier. Therefore, the images restored by the app itself.  

### 3. Managing Grouping Images

After I have managed to download images, it was time to start working on grouping them and also putting those group folders in home screen so when user click on each group folder, they would see the images in that specific group. While downloading and fetching images I have worked on GroupDetailScreen since for now, there was no groups existed and I have just checked the fact that if I could download images or not.

Since I haven't worked with groups, first, I have added group info to **AppPhoto** data object. I have also remove the asset property since it couldn't be codable and also I am already fetching images to add image then reloading using the id so it was unnecessary to store the asset information rather than storing group and making AppPhoto codable to store more easily in JSON file.

After I added the group info, I just add the group info each time I add new asset to photos using **addAsset** method in **PhotoLibraryViewModel** then wrote it into Text right after the photo istelf to see if it is working and indeed it was working so I have started working on Home Screen.

Home Screen must have a folders in a grid (which was my idea since I liked the idea of using grid rather then a TableView list). In the pdf, it is said that we must use **UICollectionView** in HomePage and HomePage should be written in UIKit rather than SwiftUI. HomeScreen inherited **UIViewController** class since it is a UIKit view. I have first started with seting the UICollectionView up, and to do that, I have determined the spacing and item width for UICollectionFlowLayout since each UICollectionView is going to be put in there. After that, I have created UICollectionView and make the dataSource and delegate of the UICollectionView to itself and added to UICollectionFlowLayout as subView so it will shown.

To be able to show the groups as folders, I need to know the groups existed in all photos so I map each photo's group name and since there are more than one photo in each group, I must use set to **ensure the uniqueness of the folder groups**. Also setted up the **addButton** as well and added with UIKit instead of using SwiftUI. Since the functionallity of the button haven't change, I just added the same functionality with minor changes.

Then it was time to send the photos to their designated **GroupDetailScreen**. To manage that, I have used **UIHostingController** since I was going to navigate to a SwiftUI view inside UIKit view and change the root from homeScreen to GroupDetailScreen. I have also sended the group name to GroupDetailScreen while navigating since I must see the photo's in certain group and used this group information to filter the photos to be shown inside the folder. Since I have added other as nil, I have used optional group name and determined the charatheristic based on that. Since the groupDetail must be send when a folder is clicked, I have used used **delegate** methods so each time user clicked on any folder, this information would be send to the GroupDetailScreen and it will navigate to that screen as well.



