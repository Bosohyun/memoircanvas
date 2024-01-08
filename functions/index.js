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

exports.scheduledDeleteUnverifiedUsers = functions.pubsub
    .schedule("0 0 * * *")
    .timeZone("Asia/Seoul")
    .onRun((context) => {
      const users = [];
      let unVerifiedUsers = [];
      const listAllUsers = async (nextPageToken) => {
        return admin
            .auth()
            .listUsers(1000, nextPageToken)
            .then((listUsersResult) => {
              listUsersResult.users.forEach((userRecord) => {
                users.push(userRecord);
              });
              if (listUsersResult.pageToken) {
                listAllUsers(listUsersResult.pageToken);
              }
            })
            .catch((error) => {
              console.log("Error listing users:", error);
            });
      };

      listAllUsers().then(() => {
        unVerifiedUsers = users
            .filter((user) => !user.emailVerified)
            .map((user) => user.uid);
        admin
            .auth()
            .deleteUsers(unVerifiedUsers)
            .then((deleteUsersResult) => {
              console.log(
                  `Successfully deleted ${deleteUsersResult.successCount}`,
              );
              console.log(
                  `Failed to delete ${deleteUsersResult.failureCount}`,
              );
              deleteUsersResult.errors.forEach((err) => {
                console.log(err.error.toJSON());
              });
              return true;
            })
            .catch((error) => {
              console.log("Error deleting users:", error);
              return false;
            });
      });
    });
