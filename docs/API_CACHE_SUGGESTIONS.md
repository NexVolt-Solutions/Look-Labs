# API Caching

All main APIs use cache-first + background refresh with change detection.

## Cached APIs

| API | Endpoint | Strategy |
|-----|----------|----------|
| **Domains** | `GET domains/explore` | Cache-first, background refresh, update only when data changed |
| **Wellness** | `GET onboarding/users/me/wellness` | Cache-first, background refresh, update only when data changed |
| **User profile** | `GET users/me` | Cache-first, background refresh, update only when data changed |
| **Weekly progress** | `GET users/me/progress/weekly` | Cache-first, background refresh, update only when data changed |
| **Onboarding questions** | `GET onboarding/questions` | Cached for question flow |
| **Onboarding domains** | `GET onboarding/domains` | Cached for goal screen |

## Pre-fetch at Login

Splash (returning user) and Auth (new sign-in) pre-fetch all caches in parallel. Home loads instantly from cache.

## Change Detection

Background refresh: fetch from API, compare with cached. If different, update cache and notify UI.

## Logout

All caches cleared on logout and delete account.
