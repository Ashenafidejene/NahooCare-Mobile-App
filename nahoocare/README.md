# NahooCare

## Symptom-Based Nearest Healthcare Center Recommendation & First-Aid Guidance Mobile Application

NahooCare is a cross-platform mobile application built with Flutter, designed to enhance healthcare accessibility and empower users through technology. The app recommends the nearest healthcare centers based on user-reported symptoms and provides offline first-aid instructions to assist in emergencies or remote areas.

## Overview

This project aims to address challenges in healthcare navigation and emergency response — especially in urban settings like Addis Ababa, Ethiopia. NahooCare helps users:

* Identify appropriate nearby healthcare centers based on symptoms.
* Access offline first-aid instructions during emergencies.
* Create personalized health profiles for better tracking.
* Rate and review healthcare services for community insight.

## Core Features

* User Authentication: Secure login/signup with hashed passwords and secret questions.
* Symptom-Based Suggestions: Users input symptoms, and the app recommends suitable nearby healthcare centers using location data.
* Offline First-Aid Guide: Preloaded, categorized instructions to handle common medical emergencies offline.
* Health Profile Management: Users can add medical history, allergies, and conditions to personalize recommendations.
* Center Rating & Reviews: Users can rate and review visited centers, improving decision-making for others.
* Search History Tracking: Tracks previously searched symptoms and centers for faster future use.

## Technology Stack

* Frontend: Flutter (Dart)
* Backend/API: FastAPI (Python)
* Database: MongoDB (cloud) & SQLite (local storage)
* State Management: flutter\_bloc
* Location & Maps: geolocator, flutter\_map, flutter\_map\_marker\_popup
* Other Packages: flutter\_rating\_bar, cloudinary\_sdk, flutter\_dotenv, fluttertoast, loading\_animation\_widget

## Architecture & Methodology

* Development Approach: Waterfall for initial planning, Agile for iterative development.
* Design Methodology: Microservices for modular backend design and maintainability.
* Collaboration Tools: Git (version control), GitHub (code hosting, issue tracking), Trello (task management), and Google Docs (documentation).

## Current Limitations

* Limited to Addis Ababa: The app currently operates only within Addis Ababa and requires scaling for other regions.
* No real-time integration with hospitals, ambulance services, or emergency hotlines.
* Some features depend on location access and internet, except offline first-aid.

## Security Practices

* Passwords stored using secure hashing algorithms.
* Sensitive user data protected through role-based access control.
* Dotenv and secure storage used to manage API keys and environment variables.

## Installation & Setup

Clone the repository and run the app locally:

```
git clone https://github.com/Ashenafidejene/NahooCare-Mobile-App.git
cd NahooCare-Mobile-App
flutter pub get
flutter run
```

Ensure that:

* Flutter SDK is installed and set up properly.
* Location permissions are enabled on your device/emulator.

## Future Improvements

* Integration with real-time hospital bed availability and live ambulance status.
* Expand coverage to regions beyond Addis Ababa.
* Add chatbot-based symptom input and health advice.
* Push notifications for health tips and emergencies.
* Integrate AI for symptom triaging and health trend analytics.

## Contribution Guidelines

We welcome contributions from developers, designers, healthcare experts, and researchers.

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature-name`).
3. Commit your changes and push to your fork.
4. Submit a pull request with a clear explanation of your changes.

## Contact

For support, partnership, or feedback:

* GitHub: [https://github.com/Ashenafidejene/NahooCare-Mobile-App](https://github.com/Ashenafidejene/NahooCare-Mobile-App)

## License

This project is open source and available under the MIT License.
