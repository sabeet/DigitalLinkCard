var admin = require("firebase-admin");

var { firebaseConfig } = require("../utils/config");
var serviceAccount = require("../digitallinkcard-687db-firebase-adminsdk-e4y6c-d934df80e4");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: `${firebaseConfig.storageBucket}`,
});

const db = admin.firestore();

module.exports = { admin, db };
