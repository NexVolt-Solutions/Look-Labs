# QA Checklist

Use this checklist after major refactors or before release.

## 1) Auth + Home Load

- Launch app with an existing logged-in user.
- Confirm splash refreshes token and navigates to Home.
- Verify Home data appears:
  - Wellness cards
  - Daily quote
  - Weekly progress strip
  - Explore plans grid

## 2) Domain Lock/Unlock Behavior

- With no goal selected, tap a plan card:
  - Snackbar appears
  - "Select goal" action is available
- With a goal selected:
  - Only selected domain card is tappable
  - Non-selected domains stay blocked with correct message

## 3) Fashion Completed Flow

- Tap Fashion card when backend returns completed flow.
- Verify old/new dialog behavior:
  - If previous data exists: dialog appears
  - If previous data does not exist: opens New Scan directly
- Verify actions:
  - "Previous Record" -> Fashion profile flow
  - "New Scan" -> Fashion review scan flow

## 4) Fashion Profile Screen

- Confirm no layout overflow on weekly subtitle row.
- Verify profile data matches backend:
  - Body type
  - Undertone
  - Style
  - Review scans (front/back images)
  - Best clothing fits
  - Styles to avoid
  - Warm palette

## 5) Fashion Weekly Plan Screen

- Verify weekly day list renders from backend response.
- Verify day icons render correctly (local assets).
- Verify season tabs switch the displayed data.
- Verify all sections render when present:
  - Outfit Combinations
  - Recommended Fabrics
  - Footwear

## 6) Workout Result + Progress

- Open workout result and workout progress flows.
- Verify:
  - Plan generation works
  - Progress cards load
  - Recovery checklist toggles persist
  - Chart period switching works

## 7) Skin/Hair Daily Routine

- Open skin routine screen.
- Open hair routine screen.
- Verify for both:
  - Data loads successfully
  - Completion state save/load works
  - Remedies/products blocks appear when backend provides them

## 8) Smoke Checks

- Run static checks:
  - `flutter analyze`
- Run app:
  - `flutter run`
- Confirm no new exceptions in debug console.

## Optional: Release Gate

- [ ] All items above passed
- [ ] No critical console exceptions
- [ ] Navigation paths verified on target platform(s)
