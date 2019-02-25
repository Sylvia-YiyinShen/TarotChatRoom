const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
let registrationToken = "ffzlfQ8GQCg:APA91bHDMAbTYSLFGLgg0thkXg9oOyjFDjzoZeiPHTsr3ghCiRPYcs-ynKLY_tVUA60Fy8fsMKk7xd3pCi6WkNNHLI2gnEPcp503SoOpmcz0SmuZSN9WxfT0uwNjpqIHFyyztTTY9avo"


exports.onHostInOut = functions.database.ref('/RoomStatus/isHostOnline').onWrite(
	async(snap, context) => {

 	let isHostOnline = snap.after.val(); 
	let payload;
	if (isHostOnline == true) {
		payload = {
	      notification: {
	        title: "Sylvia's online",
	        body: "Sylvia is online in the Tarot Room, go and get free tarot readings!"
	      }
	    };
	} else {
		payload = {
	      notification: {
	        title: "Sylvia's offline",
	        body: "See you in the next session!"
	      }
	    };
	}

	admin.messaging().sendToDevice(registrationToken, payload)
	  .then(function(response) {
	    console.log('Successfully sent message:', response);
	  })
	  .catch(function(error) {
	    console.log('Error sending message:', error);
	  });
	return null
});


	// if (admin.app() == null) {
	// 	admin.initializeApp();
	// 	console.log("admin.initializeApp();")
	// }
