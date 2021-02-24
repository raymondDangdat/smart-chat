const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.myFunction = functions.firestore
    .document("smartChatChat/{message}")
    .onCreate((snapshot, context) => {
      return admin.messaging().sendToTopic("smartChatChat", {
        notification: {
          title: snapshot.data().username,
          body: snapshot.data().text,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      });
    });
