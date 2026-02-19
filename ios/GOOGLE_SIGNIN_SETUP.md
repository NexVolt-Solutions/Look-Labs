# Google Sign-In on iOS – URL scheme

For the Google account picker to show, the app must have the correct **reversed client ID** as a URL scheme.

## Option A: Get it from Firebase (recommended)

1. Open [Firebase Console](https://console.firebase.google.com) → your project **lookslab-2b9b3**.
2. Go to **Project settings** (gear) → **Your apps**.
3. Select your **iOS app** (`com.nexvoltsolutions.looklabs`).
4. Click **Download GoogleService-Info.plist** and **replace** the file at `ios/Runner/GoogleService-Info.plist`.
5. Open the new **GoogleService-Info.plist** and look for **`REVERSED_CLIENT_ID`**.
   - If it’s there: copy its value (e.g. `com.googleusercontent.apps.599895027153-aksrxxxxxxxx`).
   - If it’s still missing: ensure **Authentication → Sign-in method → Google** is **Enabled**, then download the plist again.

## Option B: Get it from Google Cloud Console

1. Open [Google Cloud Console](https://console.cloud.google.com) → **APIs & Services** → **Credentials**.
2. Under **OAuth 2.0 Client IDs**, click **iOS client for com.nexvoltsolutions.looklabs**.
3. Copy the full **Client ID** (e.g. `599895027153-aksrxxxxxxxx.apps.googleusercontent.com`).
4. Turn it into the reversed form:
   - From: `599895027153-aksrXXXXXXXX.apps.googleusercontent.com`
   - To:   `com.googleusercontent.apps.599895027153-aksrXXXXXXXX`
   - (Replace `.apps.googleusercontent.com` with `com.googleusercontent.apps.` at the start.)

## Where to put it

1. Open `ios/Runner/Info.plist` in Xcode or a text editor.
2. Find **CFBundleURLTypes** → **CFBundleURLSchemes**.
3. Set the **single** scheme string to your **full** reversed client ID (e.g. `com.googleusercontent.apps.599895027153-aksrxxxxxxxx`), not just `com.googleusercontent.apps.599895027153`.

Save, clean build, and run again. The Google account picker should appear when you tap Sign in with Google.
