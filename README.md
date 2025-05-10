# simple leave app

## Short Description

Simple Leave App is a mobile application for hostel students to submit leave requests and view their leave history. Push notifications coming soon.

## Motivation & Purpose

This project aims to streamline and automate the leave process for students in hostels, reducing paperwork and delays while improving communication between students and wardens.

## Key Features

* **Submit Leave Requests**: Select dates, reason, and destination; attach documents.
* **View History**: Browse past leave applications and their statuses.
* **Notifications (Coming Soon)**: Real-time updates on request approvals or rejections.

## Tech Stack

* **Front-end**: Flutter (Dart)
* **Back-end**: Node.js, Express
* **Database**: MongoDB

## Installation

### Pre-requisites

* Flutter SDK (>= 3.0)
* Android Studio or Visual Studio Code (optional)

### Flutter Client

```bash
# Clone the repo
git clone https://github.com/username/simple-leave-app.git
cd simple-leave-app/client

# Install Flutter dependencies
flutter pub get

# (Android only) If you experience secure storage errors, add:
# ndkVersion = "27.0.12077973"
# to android/app/build.gradle.kts under android {
```

### Node.js Server

```bash
cd simple-leave-app/server

# Install server dependencies
npm install

# Create a .env file (see Configuration below)
# Start the development server
npm run dev
```

## Usage

1. Ensure the server is running on `http://localhost:5000`.
2. Launch an emulator or connect a device.
3. From `client` folder, run:

```bash
flutter run
```

## Configuration

In the `server/` directory, create a `.env` file with:

```
MONGO_URI=your-mongodb-connection-string
PORT=5000
JWT_SECRET=your_jwt_secret_key
```

## Testing

No automated tests are available yet. Contributions to add unit, widget, or API tests are welcome.

## Contribution Guidelines

1. Fork the repository
2. Create a feature branch:

   ```bash
   ```

git checkout -b feature/YourFeature

````
3. Commit your changes:
   ```bash
git commit -m "Add some feature"
````

4. Push to the branch:

   ```bash
   ```

git push origin feature/YourFeature

```
5. Open a Pull Request and describe your changes.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Maintainer / Contact


```
