const functions = require("firebase-functions");
const app = require("express")();
const cors = require("cors");
const { db } = require("./utils/admin");
app.use(cors());

const {
  signup,
  login,
  addlinks,
  getUser,
  addtitle,
} = require("./handlers/users");

//users api
app.get("/users", (req, res) => {
  console.log("here");
  db.collection("users")

    .get()
    .then((data) => {
      let users = [];
      data.forEach((doc) => {
        users.push({
          userId: doc.id,
          email: doc.data().email,
          firstName: doc.data().fName,
          lastName: doc.data().lName,
          title: doc.data().title,
          address: doc.data().address,
          phone: doc.data().phone,
        });
      });
      return res.json(users);
    })
    .catch((err) => {
      console.log(err);
    });
});

app.post("/signup", signup);
app.post("/login", login);
app.get("/getuser", getUser);

app.patch("/addlinks", addlinks);
app.patch("/addtitle", addtitle);

exports.api = functions.https.onRequest(app);
exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Digital Link Card!");
});
