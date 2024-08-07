<!-- ---------- Header ---------- -->
<div align="center">
  <img width="192" height="192" src="assets\splash\splash_logo.png" align="center" alt="">
  <h1>P2P BoookShare</h1>
<p>A user-friendly Flutter app for college students to share and borrow books on campus.</p>

<!-- ---------- Badges ---------- -->
[![GitHub Downloads (specific asset, latest release)](https://img.shields.io/github/downloads/viveeeeeek/p2pbookshare/latest/total?style=for-the-badge&labelColor=%23181a19&color=%23d2e3c8)](https://github.com/viveeeeeek/p2pbookshare/releases/latest)
![GitHub Repo stars](https://img.shields.io/github/stars/viveeeeeek/p2pbookshare?style=for-the-badge&logo=star&logoColor=%23FFFFFF&labelColor=%23181a19&color=%23d2e3c8)
![GitHub Release](https://img.shields.io/github/v/release/viveeeeeek/p2pbookshare?include_prereleases&style=for-the-badge&logo=%239acbff&logoColor=%23101318&labelColor=%23181a19&color=%23d2e3c8)
![GitHub last commit](https://img.shields.io/github/last-commit/viveeeeeek/p2pbookshare?style=for-the-badge&labelColor=%23181a19&color=%23d2e3c8)
</div>

<!-- ---------- Banner Image ---------- -->
<br></br>
<img src="p2pbookshare-images/header-image.png" />
<br></br>

<!-- ---------- Features ---------- -->
## Features
- 🤖 **AI-Generated Summaries**: Get concise and insightful book summaries powered by Gemini.
- 🎨 **Material & Dynamic Theming**: Enjoy a visually appealing interface with adaptive color schemes, including light and dark modes.
- 💬 **Chat Integration**: Seamlessly communicate with other users for smooth book exchanges.
- 🗺️ **Google Maps Integration**: Easily select and share locations for meetups and book exchanges.
- 🔍 **Advanced Search**: Quickly find your favorite books and authors using the powerful search bar.
- 📲 **Push Notifications**: Stay informed with real-time notifications for chat messages.

<!-- ---------- Get Started ---------- -->
## 🔨 Steps to build
1. Clone the project:
    - Use `git clone https://github.com/viveeeeeek/p2pbookshare.git` to download the project from the GitHub repository. 

2. Install Dependencies:
   * Navigate to the project directory and run `flutter pub get` to install the required dependencies.

3. Set Up Environment Variables (.env File):
     ```
      GOOGLE_MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY
      GEMINI_PRO_API_KEY=YOUR_GEMINI_PRO_API_KEY
      FIREBASAE_PROJECT_ID=YOUR_FIREBASE_PROJECT_ID
      ```

    - **Google Maps API Key:** Create a project in the [Google Cloud Console](https://console.cloud.google.com/) and enable the Google Maps Platform APIs and obtain the API key.
    - **Gemini Pro API Key:** Obtain currently Gemini Pro API key, which is free of cost as of now [here](https://aistudio.google.com/app/apikey).
    - **Firebase Project Information:** Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/) and note down the Project ID and API Key for Cloud Messaging.

4. Configure Firebase for both iOS and Android platforms:
    - Ensure the `build.gradle` file is properly set up and includes all necessary Firebase dependencies. Add the `google-services.json` file for Android and the `GoogleService-Info.plist` file for iOS to your project. Additionally, create and include the `firebase_options.dart` file in the lib/ directory to manage Firebase configuration options.

5. Configure both debug and release builds in the app/`build.gradle` file. Create and properly set up the `key.properties` file to securely manage your signing keys and other sensitive information.

    ```properties
    keyAlias=key-alias
    keyPassword=key-password
    storeFile=/path/to/kestore
    storePassword=key-store-password
    ```

6. Create a service account within the Google Cloud Console and obtain the `service_account.json` file, which is used for sending push notifications on Android. Place this file in the assets/fcm/ folder of your project.
    - Create a Service Account in Google Cloud Console
    - Navigate to the [Google Cloud Console](https://console.cloud.google.com/).
    - Go to the "IAM & Admin" section and select "Service Accounts".
    - Click "Create Service Account".
    - Provide a name and description for the service account.
    - Grant the service account the "Firebase Admin SDK Administrator Service Agent" role.
    - After creating the service account, go to the "Keys" section of your new service account.
    - Click "Add Key" and select "Create New Key".
    - Choose "JSON" format and click "Create".
    - Download the `service_account.json` file.
    - Place the downloaded `service_account.json` file in the `assets/fcm/` folder of your Flutter project.

<!-- ---------- Contribution ---------- -->
## Contribution
***All contributions are very welcome!***
* Bug reports and feature requests can be submitted [here](https://github.com/viveeeeeek/p2pbookshare/issues).
* If you are a developer and wish to contribute to the app, please **fork** the project and submit a [pull request
  ](https://help.github.com/articles/about-pull-requests/). 

<!-- ---------- License ---------- -->
## [License](./LICENSE.txt)

    Copyright (c) 2024, VivekS.
    All rights reserved.
    
    This source code is licensed under the GPLv3-style license found in the
    LICENSE file in the root directory of this source tree.



