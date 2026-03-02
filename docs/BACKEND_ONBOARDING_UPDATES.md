# Backend onboarding API

The app uses **one endpoint** to load all onboarding questions.

---

## GET all questions (required)

**Request:**

```
GET /api/v1/onboarding/questions
GET /api/v1/onboarding/questions?session_id={session_id}
```

Session ID is sent as an optional query param when the app has a session. Return **one JSON** with a **list of steps**. Each step has a name and a list of questions.

**Response:**

```json
{
  "status": "ok",
  "steps": [
    {
      "step": "profile_setup",
      "questions": [
        {
          "id": 6,
          "step": "profile_setup",
          "type": "text",
          "question": "What is your name?",
          "options": null,
          "constraints": null
        },
        {
          "id": 7,
          "step": "profile_setup",
          "type": "number",
          "question": "What is your age?",
          "options": null,
          "constraints": { "min": 10, "max": 120 }
        },
        {
          "id": 10,
          "step": "profile_setup",
          "type": "choice",
          "question": "What is your gender?",
          "options": ["Male", "Female", "Other"],
          "constraints": null
        }
      ]
    },
    {
      "step": "daily_lifestyle",
      "questions": []
    },
    {
      "step": "goals_focus",
      "questions": []
    },
    {
      "step": "motivation",
      "questions": []
    },
    {
      "step": "experience_planning",
      "questions": []
    }
  ]
}
```

**Rules:**

- `steps` = array of step objects. Order: profile_setup → daily_lifestyle → goals_focus → motivation → experience_planning.
- Each step: `step` (string), `questions` (array). Use `[]` for a step with no questions yet.

---

## Question object

| Field        | Type   | Required | Example |
|-------------|--------|----------|---------|
| `id`        | number | yes      | 6       |
| `step`      | string | yes      | "profile_setup" |
| `type`      | string | yes      | "text", "number", "choice", "multi_choice" |
| `question`  | string | yes      | "What is your name?" |
| `options`   | array  | no       | For choice: `["Male", "Female", "Other"]` |
| `constraints` | object | no     | For number: `{ "min": 10, "max": 120 }` |

---

## POST answers

- **URL:** `POST /api/v1/onboarding/sessions/{session_id}/answers?step=profile_setup` (or current step).
- **Body:** `question_id`, `answer`, `question_type`, `question_options?`, `constraints?`.

---

## Summary

| What   | Format |
|--------|--------|
| **Questions** | `GET .../onboarding/questions` → `{ "status": "ok", "steps": [ { "step": "...", "questions": [...] }, ... ] }` |
| **Answers**   | `POST .../onboarding/sessions/{id}/answers?step=...` with body above |
