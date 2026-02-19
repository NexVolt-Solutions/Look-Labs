# API contracts (Looks Lab)

## Legal endpoints

Both endpoints return JSON with the same shape: `version`, `lastUpdated`, and `sections` (array of `{ "id", "title", "body" }`). Auth is optional (public content).

### Privacy policy

- **Endpoint:** `GET /legal/privacy-policy` (see `ApiEndpoints.privacyPolicy` in the app)
- **Response:** `privacy_policy_response.json`

### Terms of Service

- **Endpoint:** `GET /legal/terms` (see `ApiEndpoints.termsOfService` in the app)
- **Response:** `terms_of_service_response.json`

### Response shape

| Field         | Type   | Description                                  |
|---------------|--------|----------------------------------------------|
| `version`     | string | Document version (e.g. `"1.0"`)             |
| `lastUpdated` | string | Human-readable date (e.g. `"February 2025"`) |
| `sections`    | array  | List of `{ "id", "title", "body" }`          |

The app can fetch these endpoints to show legal content dynamically; it otherwise uses in-app strings.
