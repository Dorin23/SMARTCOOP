const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.checkLuminosityAndNotify = functions.database
  .ref("/sensor/luminoz")
  .onUpdate((change, context) => {
    const luminozValue = change.after.val();
    if (luminozValue > 850) {
      const payload = {
        notification: {
          title: "Alertă Luminozitate",
          body: "Nivelul luminozității a depășit 850."
        }
      };
      return admin.messaging().sendToTopic("luminozAlert", payload);
    }
    return null;
  });
