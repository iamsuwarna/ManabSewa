const express = require("express");
const ngoRouter = express.Router();
const Received = require("../models/donation_model");
//const NGO = require("../models/ngo_model");
const uuidValidate = require('uuid-validate');

const uuid = require('uuid');

const auth = require('../middleware/auth');
const donorRouter = require("./donor");
const onesignal = require('onesignal-node');// Define the route handler
const NGO = require("../models/ngo_model");

ngoRouter.get('/ngo/received-donations', async(req, res)=>{
    try{
        console.log("123");
        const received = await Received.find({});
        res.json(received);
    } catch(e){
        res.status(500).json({ error: e.message })    }
});

//for sending notification
ngoRouter.post('/api/sendnotifications', (req, res) => {
    const { ngoId } = req.params;
    const { donationAmount } = req.body;
    if (!notificationsByNGO[ngoId]) {
      notificationsByNGO[ngoId] = [];
    }
    notificationsByNGO[donationAmount].push(`Received donation of $${donationAmount}`);
    res.status(200).json({ message: 'Notification sent successfully' });
  });


  //for getting notification
  ngoRouter.get('/api/getnotifications', (req, res) => {
    const { ngoId } = req.params;
    const notificationsByNGO = notifications[ngoId] || [];  
    res.status(200).json({ notificationsByNGO });
  });



ngoRouter.put('/ngo/change-status', async(req, res)=>{
    try {
        const { projectId } = req.body;
        console.log(projectId);
        let existingProject = await Received.findById(projectId);
        if (!existingProject) return res.status(404).json({ error: 'Project not found' });
        existingProject.donationStatus= true;
        existingProject.save();
        res.json(existingProject);
    } catch (e) {
    res.status(500).json({error: e.message});
    }
});



ngoRouter.put('/ngo/reject-status', async(req, res)=>{
    try {
        const { projectId } = req.body;
        console.log(projectId);
        let existingProject = await Received.findById(projectId);
        if (!existingProject) return res.status(404).json({ error: 'Project not found' });
        existingProject.rejectionStatus= true;
        existingProject.save();
        res.json(existingProject);
    } catch (e) {
    res.status(500).json({error: e.message});
    }
});


    //accept notification to donor
    // Route to send a notification to the donor
donorRouter.post('/accept/notification-to-donor', (req, res) => {
  const { donor_id, ngo_id, ngoName, donorName } = req.body;
 
  const received = new Received({
    donor_id:donor_id,
    ngo_id: ngo_id,
    ngoName: ngoName,
    donorName:donorName
  });
  const final_donor_id = uuid.v5(donor_id, uuid.v5.URL);
   if (!uuidValidate(final_donor_id)) {
    console.error('Invalid donor_id:', donor_id);
    res.status(400).send('Invalid donor_id');
    return;
  }

  // Set up OneSignal client and notification content
  const client = new onesignal.Client('b3f6bbb6-34cb-47aa-9308-f36ba09d1129', 'ODQwODYyMjMtOWU4Mi00YzhjLWI5YTgtOTdlYWJmNGJkNzI4');
  const notification = {
    contents: { en: `Thank you for your donation, ${ngoName} appreciates your support!` },
    headings: { en: `Donation Received by,${ngoName}` },
    included_segments: ['All'], 
    
  };
  
  // Send the notification using the OneSignal API
  client.createNotification(notification, (err, data) => {
    if (err) {
      console.error('Error sending notification:', err);
      res.status(500).send('Error sending notification');
    } else {
      console.log('Notification sent successfully:', data);
      res.send('Notification sent successfully');
    }
  });
});



donorRouter.post('/reject/notification-to-donor', (req, res) => {
  const { donor_id, ngo_id, ngoName, donorName } = req.body;
 
  const received = new Received({
    donor_id:donor_id,
    ngo_id: ngo_id,
    ngoName: ngoName,
    donorName:donorName
  });
  const final_donor_id = uuid.v5(donor_id, uuid.v5.URL);
   if (!uuidValidate(final_donor_id)) {
    console.error('Invalid donor_id:', donor_id);
    res.status(400).send('Invalid donor_id');
    return;
  }

  // Set up OneSignal client and notification content
  const client = new onesignal.Client('b3f6bbb6-34cb-47aa-9308-f36ba09d1129', 'ODQwODYyMjMtOWU4Mi00YzhjLWI5YTgtOTdlYWJmNGJkNzI4');
  const notification = {
    contents: { en: `Unfortunately, ${ngoName} rejected your donation!` },
    headings: { en: `Thank you for the support!` },
    included_segments: ['All'], 
    
  };
  
  // Send the notification using the OneSignal API
  client.createNotification(notification, (err, data) => {
    if (err) {
      console.error('Error sending notification:', err);
      res.status(500).send('Error sending notification');
    } else {
      console.log('Notification sent successfully:', data);
      res.send('Notification sent successfully');
    }
  });
});




//for rating ngo
ngoRouter.post('/api/rate_the_ngo', auth, async(req, res)=>{
  try{
  const { id, rating} = req.body;
  let ngo_to_rate1 = await NGO.find();
  let ngo_to_rate;
  for(let i=0; i<ngo_to_rate1.length;i++){
    if(ngo_to_rate1[i].ngo_id==id){
      console.log("here");
      ngo_to_rate=ngo_to_rate1[i];
      break;
    }
  }
  //for loop for all the ratings
  for (let i =0; i<ngo_to_rate.ratings.length; i++){
    if(ngo_to_rate.ratings[i].donorId == req.donor ){
      ngo_to_rate.ratings.splice(i, 1);
      break;
    }
  }

  const ratingSchema = {
    donorId: req.donor,
    rating,
  };

  ngo_to_rate.ratings.push(ratingSchema);
  ngo_to_rate = await ngo_to_rate.save();
  res.json(ngo_to_rate);
  }
  catch(e){
    res.status(500).json({error: e.message});
  }
})


ngoRouter.get('/api/ngo/search/:name', auth, async(req, res)=>{

  try{
const ngo = await NGO.find({ 
  name: {$regex: req.params.name, $options:"i"},
});
res.json(ngo);

  }
  catch(e){

  }

});
module.exports = ngoRouter;