<h1 align="center">DAY 1 (15 Sep, 2025)</h1>

On day 1, I mostly look at documentations to understand how can I be able to access the local galery images. What I need to look for was already indicated on Case Study pdf so I have read about **PHAsset** and learned that PHAsset is a metadata which stores the pointer to the local image object. In the same documentation there was another object called **PHImageManager** which was responsible for creating the image itself. Using the asset, I have created the image using requestImage method on PhotoLibraryManager which is called on PhotoView.

The app I have created at the end of the day 1 was only being able to reach to the local galery images and showing the whole galery so I decided to add picker afterwards since user must eb able to select the  photos they are going to download. I didn't add the changes on day 1 but put it into my to-do list.

The app consist of just a Scrollable view and a button to add images.

I have also added the requests into info.plis to be able to access the photos such as:

- Privacy - Photo Library Additions Usage Description
- Privacy - Photo Library Usage Description

<h1 align="center">DAY 2 (16 Sep, 2025)</h1>

I have started working on the PhotoPicker since user must select the photos which are going to be downloaded. Also added a JSON file tp store the identifiers of the photos in the galery. Since each photo in our galery has an identifier, 
