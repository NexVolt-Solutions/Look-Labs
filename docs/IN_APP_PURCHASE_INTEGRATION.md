# In-App Purchase Integration – Step-by-Step

This doc describes how the Looks Lab app integrates with your backend subscription/IAP APIs and with **Play Store** (and **App Store**) subscription products. It also recommends **which APIs the app actually calls** so the backend can remove or deprioritize unused ones.

---

## 1. Which APIs the app uses (keep these)

| API | Method | Used by app? | Purpose |
|-----|--------|--------------|---------|
| **GET** `/api/v1/subscriptions/plans` | GET | **Yes** | Load subscription plans (id, name, store product_id, price, duration) to show on Subscription screen. |
| **GET** `/api/v1/iap/products` | GET | **Yes** | Optional: get store product IDs if not included in plans. Can merge with plans response. |
| **POST** `/api/v1/iap/validate-receipt` | POST | **Yes** | After user completes purchase in Play/App Store, app sends receipt + product_id; backend verifies with store and creates/updates subscription. |
| **POST** `/api/v1/iap/restore-purchases` | POST | **Yes** | User taps “Restore”; app sends store purchase tokens; backend syncs and returns current subscription. |
| **GET** `/api/v1/subscriptions/me` | GET | **Yes** | Get current user subscription (plan, status, expiry). Used to show “You’re premium” / expiry and to gate premium features. |
| **GET** `/api/v1/subscriptions/me/status` | GET | **Yes** | Lightweight check (e.g. `active: true/false`) before showing premium content. Can be merged with `/me` if you prefer one endpoint. |

**Recommendation:** Keep these six. The app will call them in the flow below.

---

## 2. APIs the app does NOT call (candidates to remove or keep for internal use)

| API | Method | Used by app? | Note |
|-----|--------|--------------|------|
| **POST** `/api/v1/subscriptions/` | POST | **No** | Subscription is usually created when backend validates the receipt. App only calls **validate-receipt**, not “create subscription” separately. Backend can remove or use only internally after validation. |
| **GET** `/api/v1/subscriptions/{id}` | GET | **No** | App only needs “my” subscription via `/subscriptions/me`. Specific ID is not needed. Can remove. |
| **PATCH** `/api/v1/subscriptions/{id}/cancel` | PATCH | **No** | Cancellation is done in **Play Store / App Store** (user manages subscription there). Backend is notified via **webhooks**. App may show “Manage subscription” link to store. Can remove from app; keep only if you want app-triggered cancel. |
| **PATCH** `/api/v1/subscriptions/{id}/reactivate` | PATCH | **No** | Same as cancel; reactivation is typically via store. Can remove from app. |
| **POST** `/api/v1/iap/webhooks/apple` | POST | **No** | Server-to-server only (Apple calls your backend). App never calls this. **Keep** for backend. |
| **POST** `/api/v1/iap/webhooks/google` | POST | **No** | Server-to-server only (Google calls your backend). App never calls this. **Keep** for backend. |

**Summary for backend:**  
- **Remove or repurpose:** `POST /subscriptions/`, `GET /subscriptions/{id}`, `PATCH .../cancel`, `PATCH .../reactivate` if you don’t need them for other tools.  
- **Keep:** All IAP and webhook endpoints; `GET /subscriptions/plans`, `GET /subscriptions/me`, `GET /subscriptions/me/status`.

---

## 3. Step-by-step flow (app + backend + store)

### Step 1 – Configure products in Play Store (and App Store)

- In **Google Play Console** → Your app → **Monetize** → **Subscriptions**: create subscription products (e.g. `weekly_premium`, `monthly_premium`, `lifetime_premium`).
- Note the **product IDs**; the backend and app must use the same IDs.

### Step 2 – Backend: subscription plans

- **GET /subscriptions/plans** should return plans that include the **store product_id** (e.g. `monthly_premium`) for each plan.
- Optionally include display price/duration so the app can show them before querying the store (store gives localised price when app loads products).

### Step 3 – App: load plans and store products

1. App calls **GET /subscriptions/plans** (auth optional, depending on your design).
2. App gets list of product IDs from the response.
3. App uses **in_app_purchase** to **load products** by these IDs from Play/App Store (to get price, title, etc.).
4. Subscription screen shows plans (from API) with prices from the store.

### Step 4 – User purchases

1. User selects a plan and taps Subscribe.
2. App uses **in_app_purchase** to start the purchase flow with the chosen **product_id**.
3. User completes payment in Play Store / App Store.
4. App receives a **purchase token / receipt** from the store.

### Step 5 – Validate receipt and get subscription

1. App calls **POST /iap/validate-receipt** with:
   - `product_id` (or equivalent)
   - Store-specific data: **Android:** `purchase_token`, `order_id`; **iOS:** receipt or `transaction_id` (match your backend’s expected body).
2. Backend verifies with Google/Apple and creates or updates the subscription, then returns success (and optionally subscription details).
3. App then calls **GET /subscriptions/me** to show “Premium until …” and to gate features.

### Step 6 – Restore purchases

1. User taps “Restore purchases”.
2. App uses **in_app_purchase** to get past purchases from the store.
3. App sends these to **POST /iap/restore-purchases** (body as defined by your API).
4. Backend syncs and returns current subscription; app updates UI and premium status.

### Step 7 – Check status when app opens or before premium content

- Call **GET /subscriptions/me** or **GET /subscriptions/me/status** (with auth) to know if the user is active premium. Cache briefly to avoid calling every screen.

### Step 8 – Webhooks (backend only)

- **Apple** and **Google** send subscription events (renewal, cancel, refund) to your **webhook** URLs. Backend updates subscription status; app just uses **GET /subscriptions/me** or **/me/status** to reflect current state.

---

## 4. Suggested request/response shapes (align with backend)

Backend may already have different shapes; adjust app models to match.

- **GET /subscriptions/plans**  
  - Response: `{ "plans": [ { "id": "...", "name": "Monthly", "product_id": "monthly_premium", "duration_days": 30, "price_display": "€9.99/month" } ] }`  
  - App needs at least `id`, `product_id`, and display info (name, price if provided).

- **GET /subscriptions/me**  
  - Response: `{ "subscription": { "id": "...", "plan_id": "...", "status": "active", "expires_at": "2025-04-01T00:00:00Z" } }` or similar.  
  - App needs `status` and `expires_at` (or equivalent) to show premium state and expiry.

- **GET /subscriptions/me/status**  
  - Response: `{ "active": true }` or `{ "is_premium": true }`.  
  - Used for quick checks; can be a slim version of `/me`.

- **POST /iap/validate-receipt**  
  - Request: e.g. `{ "platform": "android", "product_id": "monthly_premium", "purchase_token": "...", "order_id": "..." }` (iOS: receipt or transaction_id as your backend expects).  
  - Response: `{ "success": true, "subscription": { ... } }` or similar.

- **POST /iap/restore-purchases**  
  - Request: e.g. list of `{ "platform": "android", "purchase_token": "...", "product_id": "..." }`.  
  - Response: same as `/subscriptions/me` or `{ "subscription": { ... } }`.

---

## 5. Implementation order in the app

1. **API layer** – Endpoints, DTOs, repository for: plans, my subscription, status, validate-receipt, restore, and (optional) iap/products.
2. **Store products** – Add `in_app_purchase` (or equivalent) to `pubspec.yaml`; implement “load products by ID” and show them on the subscription screen.
3. **Purchase flow** – On “Subscribe”, start purchase with selected product_id; on success, call validate-receipt then fetch `/subscriptions/me`.
4. **Restore** – “Restore purchases” button → get store purchases → call restore API → refresh `/subscriptions/me`.
5. **Premium gating** – On app start (or before premium screens), call `/subscriptions/me` or `/me/status` and cache result; show paywall or premium content accordingly.

---

## 6. Files added in the app

- **API:** `lib/Core/Network/api_endpoints.dart` – all subscription and IAP paths.
- **Models:** `subscription_plan_response.dart`, `my_subscription_response.dart`, `subscription_status_response.dart`, `iap_request_response.dart` (validate/restore request DTOs). Align field names with your backend.
- **Repository:** `lib/Repository/subscription_repository.dart` – `getPlans()`, `getMySubscription()`, `getSubscriptionStatus()`, `validateReceipt()`, `restorePurchases()`, `getIapProducts()`, plus optional `cancelSubscription()` / `reactivateSubscription()`.
- **IAP:** `in_app_purchase: ^3.2.3` in `pubspec.yaml`; `lib/Core/Services/iap_service.dart` – `initialize()`, `loadProducts(productIds)`, `buySubscription(productId)`, `restorePurchases()`, and automatic receipt validation with backend on purchase stream.

## 7. Next steps to wire the UI

1. **Subscription plans screen**  
   - Call `SubscriptionRepository.instance.getPlans()` on load.  
   - Extract `product_id` from each plan and call `IapService.instance.loadProducts(Set.from(plan.productId))` to get store prices.  
   - Display plans (from API) with prices from store; on “Subscribe” call `IapService.instance.buySubscription(selectedPlan.productId)`.

2. **Restore button**  
   - Call `IapService.instance.restorePurchases()`, then `SubscriptionRepository.instance.getMySubscription()` to refresh UI.

3. **Premium gating**  
   - On app start or before premium screens, call `getMySubscription()` or `getSubscriptionStatus()` and cache result; show paywall or premium content accordingly.
