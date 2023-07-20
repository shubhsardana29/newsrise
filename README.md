# NewsRise
![NEWS RISE (1)](https://github.com/shubhsardana29/newsrise/assets/52607235/52acabdc-10a6-4a6e-bf59-c5b4b2823fd6)
NewsRise is a Flutter app that allows users to view top headlines news. The app fetches news data from the NewsAPI service ```https://newsapi.org/``` and displays it in a carousel slider. Users can also view their recently viewed articles and save articles for later reading.

## Features

- View top headlines from the business category in the US.
- Auto-swiping carousel slider for a seamless news browsing experience.
- Save articles for later reading and sync with Firebase Cloud Firestore.
- Firebase authentication for user login and logout.
- Search for articles by title and publish date.


## Screenshots

![Screenshot 1](./screenshots/screenshot_1.png)
![Screenshot 2](./screenshots/screenshot_2.png)
![Screenshot 3](./screenshots/screenshot_3.png)

## Requirements

- Flutter: v2.0.0 or higher
- Dart: v2.12.0 or higher
- Firebase authentication and Firestore services


## Local Setup

1. Clone the repository:
   ```git clone https://github.com/shubhsardana29/newsrise.git```
2. Navigate to the project directory:
   ```cd newsrise ```
3. Install the dependencies:
  ```flutter pub get```

4. Set up Firebase for your project:

   - Create a new Firebase project on the [Firebase Console](https://console.firebase.google.com/).
   - Add your Android and iOS apps to the project and follow the provided instructions to download the configuration files (`google-services.json` and `GoogleService-Info.plist`).
   - Enable the Authentication and Firestore services in the Firebase Console.

5. Replace the Firebase configuration files:

   - For Android, copy the `google-services.json` file to the `android/app` directory.
   - For iOS, copy the `GoogleService-Info.plist` file to the `ios/Runner` directory.

6. Run the app

   
The app should now be running on your connected device or emulator.

## How to Use

1. Upon launching the app, you will see a carousel slider displaying top headlines from the business category.

2. Swipe left or right to view different articles in the carousel.

3. Tap on an article to view its details.

4. To save an article for later reading, tap on the bookmark icon. The saved articles will be synced with Firebase Cloud Firestore.

5. To view your saved articles, switch to the "Saved Articles" tab. The saved articles will be retrieved from Firestore and displayed in the list.

6. To search for articles, type keywords in the search bar.

## Deployed Link

You can access the deployed version of NewsRise through the following link:

[NewsRise Web App](https://your-deployed-link.com)

## Reference Design Links

- [Dribbble Design - Carousel Slider](https://dribbble.com/shots/12368277-News-App)
- [Dribbble Design - Article Details](https://dribbble.com/shots/13199908-Read-News)

## YouTube Demo

[Watch the YouTube Demo](https://www.youtube.com/watch?v=your-youtube-link)

## Contributions

Contributions to the project are welcome! If you find any bugs or want to add new features, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
