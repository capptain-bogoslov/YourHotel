const functions = require("firebase-functions");
const admin = require("firebase-admin");

//  Decode the base64 service account JSON from environment variables
// const serviceAccount = JSON.parse(
//    Buffer.from(functions.config().serviceaccount.key, "base64")
//        .toString("utf8"),
// );

// Initialize Firebase Admin SDK
// admin.initializeApp({
//  credential: admin.credential.cert(serviceAccount),
// });
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
