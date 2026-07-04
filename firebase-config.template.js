// TEMPLATE — safe to commit. The real firebase-config.js is generated at deploy
// time from Netlify environment variables (see SETUP.md) and is gitignored.
//
// For local testing: copy this file to firebase-config.js (same folder) and
// fill in your real values from Firebase Console → Project settings → General.
window.FIREBASE_CONFIG = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_PROJECT_ID.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID"
};
