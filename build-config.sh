#!/bin/bash
# Generates firebase-config.js from Netlify environment variables at build time.
# Set these in Netlify: Site settings > Environment variables.
set -e

if [ -z "$FIREBASE_API_KEY" ]; then
  echo "ERROR: FIREBASE_API_KEY is not set."
  echo "Add your Firebase env vars in Netlify: Site settings > Environment variables."
  echo "Needed: FIREBASE_API_KEY, FIREBASE_AUTH_DOMAIN, FIREBASE_PROJECT_ID,"
  echo "        FIREBASE_STORAGE_BUCKET, FIREBASE_MESSAGING_SENDER_ID, FIREBASE_APP_ID"
  exit 1
fi

cat > firebase-config.js << EOF
window.FIREBASE_CONFIG = {
  apiKey: "${FIREBASE_API_KEY}",
  authDomain: "${FIREBASE_AUTH_DOMAIN}",
  projectId: "${FIREBASE_PROJECT_ID}",
  storageBucket: "${FIREBASE_STORAGE_BUCKET}",
  messagingSenderId: "${FIREBASE_MESSAGING_SENDER_ID}",
  appId: "${FIREBASE_APP_ID}"
};
EOF

echo "firebase-config.js generated from environment variables."
