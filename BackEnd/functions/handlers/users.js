const { db, admin } = require("../utils/admin");
const firebase = require("firebase");
const { firebaseConfig } = require("../utils/config");

firebase.initializeApp(firebaseConfig);

const {
  validateSignUpData,
  validateLoginData,
  reduceUserDetails,
} = require("../utils/validators");

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
      console.log(data);
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
      return dbEntry;
    })
    .then(() => {
      return res.status(201).json({ token });
    })
    .catch((err) => {
      console.error(err);
      if (err.code === "auth/email-already-in-use") {
        return res.status(400).json({ email: "Email already in use" });
      } else {
        return res.status(500).json({ error: err.code });
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
      console.log(err);
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
    console.log("found the doc");
    doc.update({
      links: req.body.links,
    });
    return res.status(200).json({ email: doc.email, doc: doc });
  } else return res.status(400).json({ result: "doc not found" });
};

//add cards
exports.addcards = (req, res) => {
  const card = {
    userId: "",
  };

  db.doc(`/cards${req.body.email}`)
    .get()
    .then((doc) => {
      if (doc.exists) {
        return res.status(403).json({ error: "card already exists" });
      } else {
        card.userId = db.collection("/cards").add;
      }
    });

  let doc = db.collection("users").doc(req.body.email);
  if (doc) {
    card.userId = doc.userId;
  }
  db.collection("cards").add(card);
  return res.status(200).json(card);

  try {
  } catch (error) {
    return res.status(400).json({ error: error });
  }
};
