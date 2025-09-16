<h1 align="center">photository</h1>

<h3 align="left">Contents</h3>

-  [App Description]("app-description")
-  [Step By Step Guide]("step-by-step-guide")
-  [How did I manage to download images from the local image library?]("how-did-i-manage-to-download-images-from-local-image-library?")
-  [How did I manage to fetch images into screen?]("how-did-i-manage-to-fetch-images-into-screen?")

<h3 align="left">App Description</h3>

In this app, user could download their images and based on their image description value, the image is going to be assigned to folders. To be able to achieve this, I have used **PHAsset** as a pointer to the actuall image which stores the metadata information. Also used **PHImageManager** to generate preview thumbnails with given PHAsset using requestImage method. requestImage simply gave me the image representation of the given asset.

<h3 align="left">How did I manage to download images from the local image library?</h3>

When user click on the **+Add Photo** button, the sheet consisted of their gallery image is presented. It was necessary because otherwise user couldn't be able to pick photos from their gallery. Since the user should be able to pick their images in a view like object, I have added the **UIViewControllerRepresentabl**e protocole to **PhotoPicker**. **UIViewControllerRepresentable** protocol requires methods like **makeUIViewController**, **updateUIViewController** and **makeCoordinator** and a **Cordinator** class that has a **PHPickerViewControllerDelegate** method which responds to **PHPickerViewController** and knows when it is completed. On the closure, we are calling **PhotoLibraryManager ViewModel**'s **addAsset** method to be able to add asset to our JSON file so when the image has saved, even when user destroys the app it stays. 

addAsset method creates a new AppPhoto object which stores the information about a certain photo including its **PHAsset** metadata pointer. Then add the newly created photo to photo array then calls the **savePhotos** method.

**savePhotos** takes each AppPhoto object's id and put it in identifiers array so it will write it down to a JSON file to store the identifiers (id's) of the object so whe I called **loadPhotos** method (which is called in init method of PhotoLibraryManager and since it is declared as **StateObject** which means it is called every time the published property changed which is appPhotos or the identity of the view changes instead of every time the new input added to the view.) it creates PHAsset's using their identifier. Therefore, the images restored by the app itself.  

<h3 align="left">How did I manage to fetch images into screen?</h3>

First, I have started with adding a simple button and a Scrollable Lazy Grid View to show each images downloaded by the user using another view called PhotoView. PhotoView determined how the images are going to be shown on the screen such as their sizes etc. and since image is an optional, there is a probability that the image might not exist which in this case shows gray color instead. Since we need to fetch the images from our JSON file, PhotoView calls PhotoLibraryManager ViewModel's fetchImage. It is calling on the onApper because user must have seen the result on each time the PhotoView is appeared in screen rather than just when screen created or while it is dissapearing. It would have made no sense. 

<h3 align="left">Home Screen</h3>
<h3 align="left">Group Detail Screen</h3>
<h3 align="left">Image Detail Screen</h3>

<h3 align="left">Step By Step Guide</h3>
