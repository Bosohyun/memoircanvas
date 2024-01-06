const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.resetRemainingGenSeoul = functions.pubsub.schedule("0 0 * * *")
    .timeZone("Asia/Seoul")
    .onRun(async (context) => {
      const usersRef = admin.firestore().collection("users");
      const snapshot = await usersRef.get();
      const batch = admin.firestore().batch();
      snapshot.forEach((doc) => {
        const userRef = usersRef.doc(doc.id);
        batch.update(userRef, {remainingGen: 2});
      });
      return batch.commit().then(() => {
        console.log("Reset remainingGen to 2 for all users");
      });
    });
