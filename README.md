# NewsRise
<div align="center">
  <img src="https://github.com/shubhsardana29/newsrise/assets/52607235/52acabdc-10a6-4a6e-bf59-c5b4b2823fd6" alt="NEWS RISE" />
</div>
NewsRise is a Flutter app that allows users to view top headlines news. The app fetches news data from the NewsAPI service https://newsapi.org and displays it in a carousel slider. Users can also view their recently viewed articles and save articles for later reading.

## Features

- View top headlines from the business category in the US.
- Auto-swiping carousel slider for a seamless news browsing experience.
- Save articles for later reading and sync with Firebase Cloud Firestore.
- Firebase authentication for user login and logout.
- Search for articles by title and publish date.


## Screenshots

![Screenshot 2023-07-20 at 5 22 23 PM Background Removed](https://github.com/shubhsardana29/newsrise/assets/52607235/e532fef5-db9b-4646-8e03-275fc1242d60)
<img width="1440" alt="Screenshot 2023-07-20 at 5 22 58 PM" src="https://github.com/shubhsardana29/newsrise/assets/52607235/b68b1db4-6473-41b0-b257-350ae22c046a">

<img width="1440" alt="Screenshot 2023-07-20 at 5 30 50 PM" src="https://github.com/shubhsardana29/newsrise/assets/52607235/c409c63b-92d9-4cc2-9d61-341e3af1e283">
<img width="1440" alt="Screenshot 2023-07-20 at 5 31 02 PM" src="https://github.com/shubhsardana29/newsrise/assets/52607235/81da0809-a810-4749-a766-b8c28b9307a1">

![Screenshot 2023-07-20 at 5 31 11 PM Background Removed](https://github.com/shubhsardana29/newsrise/assets/52607235/dba04394-0905-441e-8583-3e93d94f134c)


## Requirements

- Flutter: v3.0.0 or higher
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

1. Upon launching the app, you will be greeted with a splash screen that animates with a fading effect. After a short delay, the app will automatically navigate to the sign-in page.

2. On the sign-in page, you can enter your email and password to sign in. If you don't have an account, you can tap on the "Create Account" button to create a new account.
3. After signing in, you will see a carousel slider displaying top headlines from the business category.
4. Swipe left or right to view different articles in the carousel.
5. Tap on an article to view its details.

6. To save an article for later reading, tap on the bookmark icon. The saved articles will be synced with Firebase Cloud Firestore, ensuring you can access them from any device.

7. To view your saved articles, switch to the "Saved Articles" tab. The saved articles will be retrieved from Firestore and displayed in the list.

8. To search for articles, type keywords in the search bar in Recently viewed tab.

## APK Link

You can access the APK of NewsRise through the following link:

[NewsRise Apk](https://github.com/shubhsardana29/newsrise/releases/tag/v1.0.0)

## Reference Design Links

- [Dribbble Design ](https://dribbble.com/search/news-app)

## YouTube Demo

[Watch the YouTube Demo](https://youtu.be/vPnlMGtJgOQ)

## Contributions

Contributions to the project are welcome! If you find any bugs or want to add new features, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
