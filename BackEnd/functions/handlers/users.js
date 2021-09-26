const { db, admin } = require("../utils/admin");
const firebase = require("firebase");
const functions = require("firebase-functions");
const { firebaseConfig } = require("../utils/config");

const twilio = require("twilio");

const accounSid = process.env.TWILIO_SID;
const authToken = process.env.TWILIO_AUTH;

firebase.initializeApp(firebaseConfig);

const {
  validateSignUpData,
  validateLoginData,
  reduceUserDetails,
} = require("../utils/validators");

var provider = new firebase.auth.GoogleAuthProvider();

//signup api
exports.signup = (req, res) => {
  const newUser = {
    email: req.body.email,
    password: req.body.password,
    confirmPassword: req.body.confirmPassword,
    firstName: req.body.firstName,
    lastName: req.body.lastName,
    // address: req.body.address,
    title: req.body.title,
    //phone: req.body.phone,
  };

  const { valid, errors } = validateSignUpData(newUser);

  if (!valid) return res.status(400).json(errors);
  //End of Validation

  const noImg = "avatar.png";

  let token, userId;
  db.doc(`/users/${newUser.email}`)
    .get()
    .then((doc) => {
      if (doc.exists) {
        return res.status(400).json({ handle: "this email already in use" });
      } else {
        return firebase
          .auth()
          .createUserWithEmailAndPassword(newUser.email, newUser.password);
      }
    })
    .then((data) => {
      data.user.sendEmailVerification();
      userId = data.user.uid;
      //console.log(data);
      return data.user.getIdToken();
    })
    .then((idtoken) => {
      token = idtoken;

      const userCredentials = {
        email: newUser.email,
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        address: null,
        title: req.body.title,
        phone: null,
        createdAt: new Date().toISOString(),
        userId,
      };
      let dbEntry = db.doc(`/users/${newUser.email}`).set(userCredentials);
      const client = new twilio(accounSid, authToken);
      const twilioPhone = "+18564524204";

      return client.messages
        .create({
          body: "Check your email to confirm account registration with Digital Link Card!",
          from: twilioPhone,
          to: "+17174303482",
        })
        .then((message) => {
          console.log(message);
        });
    })
    .then(() => {
      return res.status(201).json({ token });
    })
    .catch((err) => {
      if (err.code === "auth/email-already-in-use") {
        return res.status(400).json({ email: "Email already in use" });
      } else {
        return res.status(500).json({ error: err });
      }
    });
};

//Log a user in
exports.login = (req, res) => {
  const user = {
    email: req.body.email,
    password: req.body.password,
  };

  const { valid, errors } = validateLoginData(user);

  if (!valid) return res.status(400).json(errors);

  //Validation

  firebase
    .auth()
    .signInWithEmailAndPassword(user.email, user.password)
    .then((data) => {
      if (data.user.emailVerified) {
        return data.user.getIdToken();
      } else {
        return;
      }
    })
    .then((token) => {
      if (token) {
        return res.json({ token });
      } else return res.status(400).json({ message: "Email not verified!" });
    })
    .catch((err) => {
      if (err.code === "auth/wrong-password") {
        return res
          .status(403)
          .json({ general: "Wrong Credentials, please try again" });
      } else return res.status(500).json({ error: err.code });
    });
};

//patch user profile
exports.addlinks = (req, res) => {
  let doc = db.collection("users").doc(req.body.email);

  if (doc) {
    doc.update({
      links: req.body.links,
    });
    return res.status(200).json({ email: doc.email, doc: doc });
  } else return res.status(400).json({ result: "doc not found" });
};

//get user information
exports.getUser = (req, res) => {
  let userEmail = req.query.email;

  db.doc(`/users/${userEmail}`)
    .get()
    .then((doc) => {
      if (doc.exists) {
        res.status(200).json(doc.data());
      } else res.status(404).json({ message: "User not found" });
    })
    .catch((err) => {
      res.status(400).json({ error: err });
    });
};

//patch title
exports.addtitle = (req, res) => {
  let userData = { title: req.body.title, email: req.body.email };

  db.doc(`/users/${userData.email}`)
    .get()
    .then((doc) => {
      if (doc.exists) {
        db.collection("users")
          .doc(userData.email)
          .update({ title: userData.title });

        return res.status(200).json({ message: "title added successfully" });
      } else return res.status(404).json({ message: "User not found" });
    })
    .catch((err) => {
      return res.status(500).json({ message: err.message });
    });
};
