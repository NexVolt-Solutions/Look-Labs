# Onboarding Flow API – Backend requirement for `index`

---

## Short version (what to ask backend)

**Endpoint:** `GET .../onboarding/sessions/{session_id}/flow?step=...&index=...`

**Ask backend:** “Use the **index** query param. Right now every index returns the same two questions. It should work like this:

- **index=0** → `current` = 1st question of the step, `next` = 2nd  
- **index=2** → `current` = 3rd question, `next` = 4th  
- **index=4** → `current` = 5th, `next` = null  

So **index** = position (0-based) in that step’s question list; **current** = question at index, **next** = question at index+1 (or null). No new fields, just use index when building current/next.”

**Where to change:** Backend only (flow handler that builds `current` and `next`).  
**When:** Before or when you want all step questions (e.g. name, age, weight, height) to show in the app.

**App change (after backend is done):** In the Flutter app, `question_answer_view_model.dart` → `loadAllQuestionsForCurrentStep()`: add a loop that calls the flow API with `index=0`, then `index=2`, then `index=4`, … and merges all `current`/`next` into one list so all questions show.

---

## Problem

The app calls:

```http
GET {{base_url}}/api/v1/onboarding/sessions/{{session_id}}/flow?step=profile_setup&index=0
```

Today, **the same response is returned for every `index`** (0, 1, 2, …). So the app only ever gets the first two questions (e.g. name, age) and cannot show the rest (e.g. weight, height) for that step.

## Required behavior

The **`index` query parameter must be used** so that different indices return different questions for the same `step`.

- **`index`** = position (0-based) of the **first** question in the list of questions for that step.

Suggested contract:

| Request (step=profile_setup) | `current` should be        | `next` should be          |
|-----------------------------|---------------------------|---------------------------|
| `index=0`                   | 1st question (e.g. name)  | 2nd question (e.g. age)   |
| `index=2`                   | 3rd question (e.g. weight)| 4th question (e.g. height)|
| `index=4`                   | 5th question (if any)     | `null`                    |

So:

- For `step=profile_setup` with 5 questions (e.g. name, age, weight, height, other):
  - `index=0` → `current` = Q1, `next` = Q2  
  - `index=2` → `current` = Q3, `next` = Q4  
  - `index=4` → `current` = Q5, `next` = null (or omit)

- Same idea for other steps: `index` is the offset into that step’s question list; `current` = question at `index`, `next` = question at `index+1` (or null if there isn’t one).

## What to change on the backend

1. **Use `index`** in the flow handler: treat it as the 0-based offset into the ordered list of questions for the given `step`.
2. Set **`current`** = question at position `index` for that step.
3. Set **`next`** = question at position `index + 1`, or `null` if there is no such question.
4. Keep **`progress`** (and the rest of the response) as today; no need to change.

Nothing needs to be **removed**; the backend only needs to **honor `index`** so the app can request each “pair” of questions (0–1, 2–3, 4–5, …) and show all questions and options for the step.

## After the backend change

Once the API returns different `current`/`next` for different `index` values, the app can call the flow endpoint with `index=0`, `2`, `4`, … and display all questions (and their options) for each step.
