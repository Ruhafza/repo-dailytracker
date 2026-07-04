# Daybook — Firebase Setup Guide

Your Firebase config now lives outside `index.html`, in a gitignored `firebase-config.js` that Netlify generates at deploy time from environment variables — so the real values never sit in your GitHub repo.

**Important context:** this is about keeping your repo tidy and not casually publishing your project ID to anyone browsing GitHub — it is *not* what makes your data safe. A Firebase web config isn't a secret key; it has to reach the browser for the app to work at all, so it's always visible via dev tools on the live site no matter which file it's in. What actually protects your data is the Firestore security rules in step 5, which are unchanged and still required.

## 1. Create a Firebase project
1. Go to https://console.firebase.google.com
2. Click **Add project**, name it, finish the wizard (Analytics optional).

## 2. Register a web app
1. Click the **`</>`** (web) icon to add a web app. Any nickname. Skip Firebase Hosting.
2. Copy the `firebaseConfig` object Firebase shows you — you'll need its six values in step 8.

## 3. Turn on Email/Password sign-in
Console → **Build → Authentication → Get started → Sign-in method** → enable **Email/Password**.

## 4. Create the Firestore database
Console → **Build → Firestore Database → Create database** → pick a location → **Production mode**.

## 5. Set security rules
Console → **Firestore Database → Rules**, replace everything with:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      match /days/{dateId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```
Click **Publish**.

## 6. Push this project to GitHub
This setup needs Netlify to run a small build step, so drag-and-drop deploy won't work anymore — connect a repo instead:
1. Create a new GitHub repo and push all these files to it (`index.html`, `netlify.toml`, `build-config.sh`, `firebase-config.template.js`, `.gitignore`, `SETUP.md`).
2. `firebase-config.js` itself should **not** exist in the repo — `.gitignore` keeps it out.

## 7. Connect the repo to Netlify
1. Netlify dashboard → **Add new site → Import an existing project** → pick your GitHub repo.
2. Build command and publish directory are already set via `netlify.toml` — just confirm and deploy.

## 8. Add your Firebase values as Netlify environment variables
Site settings → **Environment variables** → add each of these (values from step 2's config object):

| Key | Value |
|---|---|
| `FIREBASE_API_KEY` | apiKey |
| `FIREBASE_AUTH_DOMAIN` | authDomain |
| `FIREBASE_PROJECT_ID` | projectId |
| `FIREBASE_STORAGE_BUCKET` | storageBucket |
| `FIREBASE_MESSAGING_SENDER_ID` | messagingSenderId |
| `FIREBASE_APP_ID` | appId |

Then trigger a deploy (Deploys → Trigger deploy). The build runs `build-config.sh`, which writes `firebase-config.js` from these variables — that file exists on Netlify's server and in the deployed output, just never in your git history.

## 9. Authorize your Netlify domain
Console → **Authentication → Settings → Authorized domains → Add domain** → add your `your-site.netlify.app` address.

## Testing locally (optional)
Netlify's build step only runs on Netlify, so to run this on your own machine:
1. Copy `firebase-config.template.js` to `firebase-config.js` and fill in your real values.
2. Serve the folder with a local server (modules don't work over `file://`), e.g. `npx serve`.
3. This local `firebase-config.js` stays gitignored too — never gets committed.

## Good to know
- Each account's data lives at `users/{their-uid}` in Firestore, enforced by the rules in step 5.
- The free **Spark** plan covers personal use.
- **Delete all my data** in the app's footer permanently wipes that account's data — cannot be undone.
- The app syncs the last 120 days live; older history isn't deleted, just not auto-loaded.
- If the app shows "Missing firebase-config.js," the build step didn't run or the env vars aren't set yet — check step 8.
