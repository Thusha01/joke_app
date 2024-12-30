# jokes_app_assessment_1

A new Flutter project.

# Jokes App with Offline Support

This project is a simple jokes app built with Flutter that allows users to fetch jokes from an API and displays cached jokes when the app is offline. The app demonstrates how to handle online and offline states effectively using Flutter and local storage.

---

## Features

- Fetches jokes from a remote API when online.
- Caches jokes locally for offline access.
- Displays cached jokes when there is no internet connection.
- User-friendly interface with loading indicators and error messages.

---

## Requirements

- Flutter SDK (version 3.0.0 or higher)
- Dart (version 2.17 or higher)

---

## How It Works

1. **Online Mode**:
   - When the app has an active internet connection, jokes are fetched from the API.
   - Fetched jokes are cached locally using `SharedPreferences`.

2. **Offline Mode**:
   - When there is no internet connection, the app automatically retrieves jokes from the local cache.
   - The user can continue viewing previously fetched jokes without disruption.

3. **Fallback Handling**:
   - If the API request fails due to network issues or other reasons, cached jokes are displayed as a fallback.

---
