/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();

// HTTPS function to generate a custom authentication token
exports.generateAuthToken = functions.https.onRequest(async (req, res) => {
  try {
    // Ensure this is a POST request
    if (req.method !== "POST") {
      return res.status(405).send({error: "Method Not Allowed. Use POST."});
    }

    // Extract the UID (user ID) from the request body
    const {uid, customClaims} = req.body;

    if (!uid) {
      return res.status(400).send({error: "UID is required"});
    }

    // Optionally add custom claims to the token
    const claims = customClaims || {};
    // Example: {admin: true, premiumUser: true}

    // Generate the custom token
    const token = await admin.auth().createCustomToken(uid, claims);

    // Send the generated token as the response
    return res.status(200).send({token});
  } catch (error) {
    console.error("Error generating token:", error);
    return res.status(500).send({
      error: "Failed to generate token",
      details: error.message,
    });
  }
});
