<h1 align="center">DAY 1 (15 Sep, 2025)</h1>

On day 1, I mostly look at documentations to understand how can I be able to access the local galery images. What I need to look for was already indicated on Case Study pdf so I have read about **PHAsset** and learned that PHAsset is a metadata which stores the pointer to the local image object. In the same documentation there was another object called **PHImageManager** which was responsible for creating the image itself. Using the asset, I have created the image using requestImage method on PhotoLibraryManager which is called on PhotoView.

The app I have created at the end of the day 1 was only being able to reach to the local galery images and showing the whole galery so I decided to add picker afterwards since user must eb able to select the  photos they are going to download. I didn't add the changes on day 1 but put it into my to-do list.

The app consist of just a Scrollable view and a button to add images.

I have also added the requests into info.plis to be able to access the photos such as:

- Privacy - Photo Library Additions Usage Description
- Privacy - Photo Library Usage Description

<h1 align="center">DAY 2 (16 Sep, 2025)</h1>

I have started working on the PhotoPicker since user must select the photos which are going to be downloaded. Also added a JSON file to store the identifiers of the photos in the galery so I could store the images. I used these identifiers to fetch images using their local identifier. The problems I encounter while adding the picker was since now I was being able to select more then one photo, the app didn't finished when I click to add button. The problem was occuring because I forgot to dismissed the picker after its complition. When I added **picker.dismiss(animated: true)** to picker function in **Coordinator** class it was working as I have expected it to be working.

Then, I have realized, when I delete the app and download it again, when I try to add image, picker show up and when I complete my task the authorization request has been shown which result in not being able to see the images after I added the images. I could only see them added when I killed and reopen the app, therefore I have added the request right after user click on the add image button instead of when user tries to add the images. 

Since now, I was able to download the image I have picked, I needed to store the object in JSON file to be able to reload the images that has been downloaded. I have started with creating AppPhoto object that is Identifiable. making an object identifiable is important since it ensures the object's id is unique which is important for us to store in a JSON object. Then I have started working on **PhotoLibraryViewModel** which is responsible to control UI objects and logic behind them. So it basically enables the logic to be able to work in a certain UI object. In my case, this view model was responsible for adding assets to the photo array, saving photos to the JSON file created by FileManager and initialized when the viewModel created and stored inside the document directory, fetching images using **PHImageManager**.

Since each Photo needs to have their own view, then I have started on working with **PhotoView** . It was necessary to create a view for each photo since I wanted them to look equal. In this view, I am taking the AppPhoto, viewModel and image. viewModel has **@ObservedObject** property since the PhotoView needs to update itself when PhotoLibraryViewModel has changes. Also, image has **@State** property since image since I do not store the image in AppPhoto directly so I need to fetch the asset to be able to recieve the UIImage which happens asyncronizely so it is not going to be directly so @State enables our UI object to be shown when it is fetched.

**So at the end of the day 2, I was being able to download images and store them in JSON file.**

<h1 align="center">DAY 3 (17 Sep, 2025)</h1>

In the 3rd day, I have started working on Home Screen. In the home screen, there needs to be folders with their designated names and each photo should have stored their group name. I started with working on group names first. I used Text to be shown under the image that has the name of the group so I could see when I add each image they have their own group names. I have also realized sometimes, the reliableHash that has been added as an extention to the PHAsset don't return any value which means they needs to be other group. So group function is going to return nil which I knew I need to handle well.
