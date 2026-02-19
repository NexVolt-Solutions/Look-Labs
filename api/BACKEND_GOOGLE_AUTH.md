# Backend Google Auth – Keys & IDs (Looks Lab)

The app calls **POST** `auth/google` with a JSON body:

```json
{
  "idToken": "<Firebase ID token or Google ID token>",
  "accessToken": "<optional, Google OAuth access token>"
}
```

The app **prefers** sending the **Firebase ID token** (from `FirebaseAuth.currentUser.getIdToken()`). If that is not available, it sends the **Google OAuth idToken** from Google Sign-In.

---

## 1. Backend must verify the token

### Option A: Verify **Firebase** ID token (recommended)

When the app sends a **Firebase** ID token, verify it with the **Firebase Admin SDK**.

**You need:**

| What | Value / Where to get it |
|------|--------------------------|
| **Firebase Project ID** | `lookslab-2b9b3` |
| **Service Account Key (JSON)** | Firebase Console → Project settings (gear) → **Service accounts** → **Generate new private key**. Download the JSON and use it to initialize the Admin SDK (e.g. `GOOGLE_APPLICATION_CREDENTIALS` or embed in env). **Do not commit this file; keep it secret.** |

- **Node:** `firebase-admin` → `admin.auth().verifyIdToken(idToken)`.
- **Python:** `firebase_admin` → `auth.verify_id_token(idToken)`.
- **Go/Java/etc.:** Use the official Firebase Admin SDK for your stack.

No Google OAuth client IDs are required for this path; the Firebase project + service account are enough.

---

### Option B: Verify **Google** ID token (fallback)

If the app sometimes sends the **Google OAuth** idToken (not the Firebase token), verify it with Google’s OAuth2 token endpoint and check the `aud` (audience) claim against **one** of your client IDs.

**Valid audiences (use one or all, depending on your logic):**

| Platform | Client ID |
|----------|-----------|
| **Web (for backend)** | `599895027153-ra37xxxxxxxx.apps.googleusercontent.com` *(from your Web client in Google Cloud)* |
| **Android** | `599895027153-obgm88m3u2crjsuuu1bki964b6605l10.apps.googleusercontent.com` |
| **iOS** | `599895027153-aksrj4i879m7kclai3hktq4rhpo3n57j.apps.googleusercontent.com` |

Get the **exact Web client ID** from: Google Cloud Console → APIs & Services → Credentials → **Web client (auto created by Google Service)** → copy **Client ID**.

---

## 2. Summary – what to configure on the backend

| Item | Required? | Value / Action |
|------|------------|----------------|
| **Firebase Project ID** | Yes (for Firebase token) | `lookslab-2b9b3` |
| **Firebase Service Account JSON** | Yes (for Firebase token) | Download from Firebase Console → Service accounts → Generate new private key. Store securely (env or secret manager). |
| **Google Web Client ID** | Only if you verify Google idToken and check `aud` | Copy from Google Cloud Console → Credentials → Web client. |
| **Android / iOS Client IDs** | Only if you verify Google idToken and allow those audiences | Android: `599895027153-obgm88m3u2crjsuuu1bki964b6605l10.apps.googleusercontent.com` · iOS: `599895027153-aksrj4i879m7kclai3hktq4rhpo3n57j.apps.googleusercontent.com` |

---

## 3. Reference – Firebase / Google IDs (no secrets)

| Key | Value |
|-----|--------|
| Firebase Project ID | `lookslab-2b9b3` |
| Firebase Auth domain | `lookslab-2b9b3.firebaseapp.com` |
| Android package / iOS bundle | `com.nexvoltsolutions.looklabs` |
| iOS URL scheme (reversed client ID) | `com.googleusercontent.apps.599895027153-aksrj4i879m7kclai3hktq4rhpo3n57j` |
| Android OAuth Client ID | `599895027153-obgm88m3u2crjsuuu1bki964b6605l10.apps.googleusercontent.com` |
| iOS OAuth Client ID | `599895027153-aksrj4i879m7kclai3hktq4rhpo3n57j.apps.googleusercontent.com` |

**API keys** (e.g. in `firebase_options.dart`) are for **client** use only. Do **not** use them for token verification on the backend; use the **Firebase Service Account** (and optionally Google Web/Android/iOS client IDs if you verify Google idToken).

---

## 4. Flutter app – api.env (Android idToken & fixing ApiException 10)

On **Android**, the app must use the **Web application** OAuth client ID as `serverClientId` (not the Android client ID). Using the Android client ID causes **ApiException: 10 (DEVELOPER_ERROR)**.

**Add to your `api.env` file (project root):**

```env
GOOGLE_WEB_CLIENT_ID=599895027153-xxxxxxxx.apps.googleusercontent.com
```

**How to get the Web client ID:**

1. **Google Cloud Console** → [Credentials](https://console.cloud.google.com/apis/credentials) → select project **lookslab**.
2. If you see **"Web client (auto created by Google Service)"** under OAuth 2.0 Client IDs → click it → copy **Client ID** → paste into `api.env` as above.
3. If you do **not** have a Web client: click **+ Create credentials** → **OAuth client ID** → Application type: **Web application** → Name (e.g. "Looks Lab Web") → **Create** → copy the new **Client ID** → paste into `api.env`.
4. Rebuild the app (`flutter clean && flutter run`).

**Important:** Use the **Web application** client ID only. Do **not** use the Android client ID (e.g. `...-obgm88...`) here; that causes sign_in_failed with ApiException 10.
