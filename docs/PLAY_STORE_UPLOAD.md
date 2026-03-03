# Upload Looks Lab to Google Play Store

## 1. Play Console setup (what you’re on)

- **App name:** Up to 30 characters (e.g. “Looks Lab”).
- **Default language:** e.g. English (United Kingdom).
- **App or game:** App.
- **Free or paid:** Free (you can add in-app purchases later).
- **Declarations:**  
  - Accept **Developer Programme Policies**.  
  - Accept **Play app signing** (required for AAB).  
  - Accept **US export laws**.

Then create the app and finish any account/verification steps Play Console asks for.

---

## 2. App signing (release keystore)

You need a **keystore** to sign the release build. Two options:

### Option A – Let Google manage the key (recommended)

1. In Play Console: **Setup → App signing**.
2. Enroll in **Play App Signing**.
3. For the **first upload**, you can use an **upload key** that you create (see Option B). Play will then use its own key for the final app signing.

### Option B – Create your own upload keystore

Run once (replace with your own details; keep the file and password safe):

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

- Use a strong password and store it securely.
- Save `upload-keystore.jks` somewhere safe (e.g. project root or a secure folder). **Do not commit it to git.**

---

## 3. Configure signing in the project

1. Create **`android/key.properties`** (do not commit to git). Add to `.gitignore` if not already:

   ```properties
   storePassword=YOUR_KEYSTORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=upload
   storeFile=../upload-keystore.jks
   ```

   If the keystore is in the project root, `storeFile=../upload-keystore.jks` is correct from `android/`. If you put the keystore elsewhere, set `storeFile` to that path (relative to `android/` or absolute).

2. The app’s **`android/app/build.gradle.kts`** is set up to read `android/key.properties` and use it for release when the file exists. If you use a different alias or store path, update `key.properties` and the `signingConfigs.release` block in `build.gradle.kts` to match.

3. **`android/key.properties`** is in **`android/.gitignore`** so the keystore and passwords are never committed.

---

## 4. Build the App Bundle (AAB)

From the project root:

```bash
flutter clean
flutter pub get
flutter build appbundle
```

The signed AAB is at:

**`build/app/outputs/bundle/release/app-release.aab`**

---

## 5. Upload to Play Console

1. In Play Console: **Release → Production** (or **Testing → Internal/Closed** for a test first).
2. **Create new release**.
3. **Upload** `app-release.aab`.
4. Add **Release name** (e.g. “1.0.0 (1)”) and **Release notes**.
5. Complete the release and submit for review.

---

## 6. Before submitting – checklist

- [ ] **Store listing:** Short description, full description, screenshots (phone 16:9 or 9:16, min 2), feature graphic (1024×500), app icon (512×512).  
- [ ] **Content rating:** Complete the questionnaire.  
- [ ] **Target audience:** Age groups.  
- [ ] **Privacy policy:** URL (you have an in-app privacy policy; use the same URL).  
- [ ] **App access:** If login is required, provide a test account or instructions.  
- [ ] **Ads:** If you use ads, declare; if not, no need.

---

## 7. Version for next uploads

- In **`pubspec.yaml`**, update **`version`** (e.g. `0.1.0` → `0.1.1` or `1.0.0`).  
- Format is `version: major.minor.patch+build` (e.g. `1.0.0+1`).  
- Each new AAB upload must have a higher `versionCode` (handled by Flutter from the `+build` number) and usually a higher version name.

After you’ve created the keystore and `key.properties`, run **`flutter build appbundle`** and use the generated AAB in Play Console.
