# Backend Google Sign-In 400 Error (for backend developer)

**TL;DR for backend:** `POST /api/v1/auth/google` returns 400 with "Invalid Google token" but the real error is **SQLAlchemy MissingGreenlet** when reading `user.updated_at` outside an async context. Fix: use an async session for the whole Google auth flow and ensure `user.updated_at` (and any lazy-loaded user fields) are loaded inside that async context (e.g. `await session.refresh(user)` or select columns in the same async query). The id_token from the app is valid.

---

## What the app sends

- **Endpoint:** `POST /api/v1/auth/google`
- **Body:** `{ "id_token": "<Google id_token>", "access_token": "<optional>" }`
- The **id_token** is from Google Sign-In (same client ID as backend: `599895027153-ra37ms86trpaftljhnao0qiva66d589s.apps.googleusercontent.com`). The app uses this as `GOOGLE_WEB_CLIENT_ID` and the token’s `aud` claim matches.

## What the backend returns

- **Status:** 400
- **Body (summary):** `Invalid Google token: 2 validation errors for TokenResponse` and:
  - `user.updated_at` → **Error extracting attribute: MissingGreenlet: greenlet_spawn has not been called; can't call await_only() here. Was IO attempted in an unexpected place?**  
  - (SQLAlchemy async error: https://sqlalche.me/e/20/xd2s)

So the 400 is **not** because the Google token is invalid. The token is accepted; the failure happens **after** validation when building the response or updating the user.

## Cause

- **MissingGreenlet** in SQLAlchemy usually means:
  - Synchronous code is reading an attribute (here `user.updated_at`) that is loaded asynchronously, or
  - A lazy-loaded relationship/column is being accessed outside an async context.

So somewhere in the auth flow (e.g. when creating/updating the user or building the `TokenResponse`), the code is touching `user.updated_at` (or another async-loaded attribute) in a context where `greenlet_spawn` / `await_only()` has not been set up.

## Fix (backend)

1. Ensure the request handler that calls the Google auth logic is **async** and uses an **async** session (or the same async context) for the whole flow that loads/updates the user.
2. When building the response that includes `user.updated_at` (or similar):
   - Either **await** the load of that attribute in an async context, or
   - Use a sync session for that path and avoid mixing async and sync session usage for the same object.
3. Avoid lazy-loading `user.updated_at` from a sync context; load it explicitly in the async path (e.g. `await session.refresh(user)` or select the needed columns in the same async query).

After fixing the async/sync usage (and ensuring the backend is configured to verify the same Google Web client ID), the app’s Google Sign-In should succeed without any change on the Flutter side.

---

## Why `GET /api/v1/users/me` returns `"name": null`

**TL;DR:** This is a **backend issue**. The backend does not persist the user’s **name** (or may not persist **profile_image**) when creating/updating the user during Google sign-in. The app sends `id_token` + `access_token`; the **id_token** (JWT) already contains `name`, `email`, and `picture` – the backend should decode it and save these into the user record.

### What the app sends on sign-in

- **POST /api/v1/auth/google** body: `{ "id_token": "...", "access_token": "..." }`  
  Optionally the app can also send `name` and `profile_image` in the body (see below) if the backend accepts them.

- The **id_token** is a JWT. When decoded (e.g. with Google’s libraries or any JWT library), its payload includes:
  - `email`
  - `name` (display name)
  - `picture` (profile photo URL)
  - and other claims.

So the backend has everything it needs from the token; it just needs to **read these claims and save them** when creating or updating the user.

### What the backend should do

1. On **POST /api/v1/auth/google**: after validating the id_token, decode it (or call Google’s userinfo endpoint) and get `name` and `picture`.
2. When creating or updating the user record, set:
   - `name` = from token/userinfo
   - `profile_image` (or equivalent) = from token/userinfo `picture`
3. Then **GET /api/v1/users/me** will return these fields and the app will show the Google name and photo.

### Optional: accept name and profile_image in the request body

If the backend prefers to receive name/photo from the app instead of (or in addition to) decoding the token, the app can send them. The backend would then persist whatever is sent in the body. The Flutter app can be updated to send `name` and `profile_image` from `GoogleSignInAccount` in the auth/google request body; the backend would need to accept and store these fields.

---

## Age and gender on user profile (resolved)

**Backend behavior (current):** The backend now syncs onboarding profile_setup answers into the user record.

- **UserCreate** includes `age` and `gender` (set directly or auto‑populated from onboarding answers).
- **UserOut** (e.g. **GET /api/v1/users/me**) includes `name`, `age`, `gender`, `profile_image`, and `subscription`.
- In **link_session_to_user**, name, age, and gender are auto‑populated from onboarding answers, so they appear in the user profile response immediately after sign-in.

The app already reads these from `GET /api/v1/users/me` and shows them on Settings and profile. If a logged-in user updates profile_setup answers, the app also sends **PATCH /api/v1/users/me** with name/age/gender so the profile stays in sync.
