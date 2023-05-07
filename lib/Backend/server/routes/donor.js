 const express = require("express");
const donorRouter = express.Router();
const auth = require("../middleware/auth");
// //const FoodDonation = require("../models/food_donation_model");
const Received = require("../models/donation_model");
const Donor = require("../models/donor_model");
const NGO = require("../models/ngo_model");
const onesignal = require('onesignal-node');// Define the route handler
const donor = require("../middleware/donor");
donorRouter.post('/donate', async (req, res) => {
  try {
    const {
      donorName,
      phone_number,
      donorId,
      rejectionStatus,
      ngo_id,
      ngo_name,
      ngo_address,
      ngo_phonenumber,
      ngo_emailaddress,
      description,
      count,
      address,
      areasOfInterest,
      images,
      type, 
    } = req.body;
    console.log(req.body);
    console.log(images);
   //Create a new instance of the Received model with the request body
    const received = new Received({
      donorName: donorName,
      phone_number: phone_number,
      donorId: donorId,
      rejectionStatus: rejectionStatus,
      ngo_id: ngo_id,
      ngo_name:ngo_name,
      ngo_address: ngo_address,
      ngo_phonenumber: ngo_phonenumber,
      ngo_emailaddress: ngo_emailaddress,
      description: description,
      count:count,
      address:address,
      areasOfInterest: areasOfInterest,
      images: images,
      type:type,
      donationStatus:false,
    });
    // Save the new instance to the database
    await received.save();
    //show snackbar

    //res.json(received);
    res.status(201).json({ message: 'Received item created successfully.' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Internal server error.' });
  }
});


//for bookmark

donorRouter.post('/bookmark', async (req, res) => {
  try {
    const {
      donorId,
      NGOId,
      NGOName,
      NGOAddress,
      NGOPhoneNumber,
    
      NGOEmailAddress,
   
     
    } = req.body;
     console.log(req.body);

    const existingNGO = await NGO.find({});
    for( i=0;i<existingNGO.length;i++){
      if(existingNGO[i].ngo_id==NGOId){
        return res
        .status(400)
        .json({msg:"This NGO has been already Bookmarked!"});
    }
    }

    let donor = await Donor.findById(donorId);
    console.log(donor);
    donor.bookmark.push({ 
     donorId,
      NGOId,   
     NGOName,
    NGOAddress,
      NGOPhoneNumber,
      NGOEmailAddress,});
    donor = await donor.save();
    res.json(donor);


  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Internal server error.' });
  }
});




//for fetching bookmarks
donorRouter.get('/fetch-bookmark',auth, async (req, res) => {
  try {
      let donor = await Donor.findById(req.donor);
      const donorBookmark = donor.bookmark;
       console.log(donorBookmark);
      res.json(donorBookmark);
  } catch (e) {
      res.status(500).json({ error: e.message });
  }

});

//for donattion notification
  donorRouter.post('/notification', (req, res) => {
    const {
      donorName,
      donorId,
      ngo_id, 
      ngo_name
    } = req.body;
    console.log(req.body);
    //console.log(ngo_id);

    // Create a new instance of the Received model with the request body
    const received = new Received({
      donorName: donorName,
      donorId: donorId,
      ngo_id: ngo_id,
      ngo_name: ngo_name
    
    });
 // get the donation amount from the request body
    // get the ngo_id from the request body
  
    // Set up OneSignal client and notification content
    const client = new onesignal.Client('b3f6bbb6-34cb-47aa-9308-f36ba09d1129', 'ODQwODYyMjMtOWU4Mi00YzhjLWI5YTgtOTdlYWJmNGJkNzI4');
    const notification = {
      contents: {en: `${req.body.donorName} donated to ${ngo_name} Thank You!`}, // replace with your desired message
      headings: {en: 'Donation Notification'},

      included_segments: ['All'],
      // included_player_ids: player_id, // replace with your desired player IDs
      // specify which segments to send the notification to
    };
  
    // Send the notification using the OneSignal API
    client.createNotification(notification, (err, data) => {
      if (err) {
        console.error('Error sending notification:', err);
        res.status(500).send('Error sending notification');
      } else {
        console.log('Notification sent successfully:', data);
        // Send the response to the NGO instead of the donor
        res.send(`Donation received by NGO with ID ${ngo_id}`);
      }
    });
  });
module.exports = donorRouter;
