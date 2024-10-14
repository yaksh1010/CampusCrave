
# CampusCrave
<img width="933" alt="Project1" src="https://github.com/user-attachments/assets/c1017512-f5aa-485f-ab7a-c799e7a4e4dd">

CampusCrave is a versatile cross-platform Flutter app designed for canteen food ordering on campuses. It provides a seamless user experience for ordering and purchasing food items, making it easier for students and staff to access canteen services. The app integrates Firebase for real-time database management, ensuring a smooth ordering process.

## Features

- **User-Friendly Interface**: Intuitive and easy-to-navigate UI, designed to enhance user experience.
- **Real-Time Ordering**: Users can place orders, view the status, and receive notifications when their order is ready.
- **Menu Browsing**: Browse through a variety of food items available in the canteen, categorized for ease of use.
- **Order History**: View past orders and track spending.
- **Admin Panel**: Manage the menu, view orders, and update order statuses.

## Tech Stack

- **Frontend**: [Flutter](https://flutter.dev/)
- **Backend**: [Firebase](https://firebase.google.com/) (Authentication, Firestore Database, and Cloud Messaging)
- **Design**: [Figma](https://www.figma.com/)
- **Version Control**: [GitHub](https://github.com/)

## Installation

To run this project locally, follow these steps:

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/yourusername/CampusCrave.git
   cd CampusCrave
   ```

2. **Setup Firebase:**

   - Create a new project in the [Firebase Console](https://console.firebase.google.com/).
   - Add an Android/iOS app to your Firebase project and download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS).
   - Place these files in their respective directories (`android/app` for Android and `ios/Runner` for iOS).
   - Enable Firebase Authentication and Firestore Database in the Firebase Console.

3. **Install Dependencies:**

   ```bash
   flutter pub get
   ```

4. **Run the App:**

   ```bash
   flutter run
   ```

## Project Structure

```plaintext
lib/
|-- main.dart          # Main entry point of the app
|-- screens/           # Contains UI screens like home, menu, order history, etc.
|-- models/            # Data models used in the app
|-- services/          # Firebase services and API integration
|-- widgets/           # Custom widgets for UI
|-- utils/             # Utility functions and constants
```

## Contributing

We welcome contributions from the community! To contribute to CampusCrave:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes and push them to your fork.
4. Create a pull request with a description of your changes.

Please ensure that your code follows the project's style guidelines and that you've tested it locally.

## Screenshots

<img width="475" alt="Screenshot 2024-10-14 at 7 11 35 PM" src="https://github.com/user-attachments/assets/d04031bf-de20-4503-a3e6-98c1e4c5a74c">
<img width="475" alt="Screenshot 2024-10-14 at 7 11 50 PM" src="https://github.com/user-attachments/assets/10b5d248-310b-4d33-af4a-8c90e935b9bf">
<img width="475" alt="Screenshot 2024-10-14 at 7 10 53 PM" src="https://github.com/user-attachments/assets/d2f8f5fb-51af-4128-a622-7db5585cca70">
<img width="475" alt="Screenshot 2024-10-14 at 7 10 37 PM" src="https://github.com/user-attachments/assets/85645b39-b7a5-489f-a756-0a9f4ec2e2fe">
<img width="475" alt="Screenshot 2024-10-14 at 7 10 29 PM" src="https://github.com/user-attachments/assets/89c5a6de-519f-47bc-8c48-8bbfc5abfef0">
<img width="475" alt="Screenshot 2024-10-14 at 7 10 23 PM" src="https://github.com/user-attachments/assets/8f58971a-debe-436b-a8f5-f2b156895919">
<img width="475" alt="Screenshot 2024-10-14 at 7 10 18 PM" src="https://github.com/user-attachments/assets/e08ce13c-4a88-4ec7-83d8-5da08d0b9810">
<img width="431" alt="Screenshot 2024-10-14 at 7 10 06 PM" src="https://github.com/user-attachments/assets/348983f4-920e-4f5a-a54d-22bec0ee038c">
<img width="475" alt="Screenshot 2024-10-14 at 7 12 19 PM" src="https://github.com/user-attachments/assets/7752b16c-0513-4e53-9dcb-763b831b91b4">
<img width="475" alt="Screenshot 2024-10-14 at 7 12 07 PM" src="https://github.com/user-attachments/assets/7e90e259-3e62-46db-8c1c-593326fad44b">

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any questions or suggestions, please reach out to us:

- **Email**: yakshdalwadi1002@gmail.com
- **LinkedIn**: [Yakshraj](https://www.linkedin.com/in/yakshraj-dalwadi-85a940248/)
