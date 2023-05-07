const mongoose = require('mongoose');  
const ratingSchema = require("./rating");

const receivedSchema = new mongoose.Schema({
  donorName: {
    type: String,
    required: true
  },
  phone_number:{
    type: String,
    required: true
  },
  donorId:{
    type:String,
    required:true
  },
  rejectionStatus:{
    type:Boolean,
    required:true
  },
  ngo_id: {
    type: String,
    required: true
  },
  ngo_name: {
    type: String,
    required: true
  },
  ngo_address: {
    type: String,
    required: true
  },
  ngo_phonenumber: {
    type: String,
    required: true
  },
  ngo_emailaddress: {
    type: String,
    required: true
  },

  description: {
    type: String,
    required: true
  },
  count: {
    type: Number,
    required: true
  },
  address: {
    type: String,
    required: true
  },
  areasOfInterest:[{
            type:String,
            required:true
        }],
        images:[{
            type:String,
            required:true
        }],
  type: {
    type: String,
    required: true
  },
  donationStatus  :{
    type:Boolean,
    required:true
 

  },
  ratings: [ratingSchema],
});

const Received = mongoose.model('Received', receivedSchema);

module.exports = Received;




// const express = require("express");
// const donorRouter = express.Router();
// const Donation = require("../models/donation_model");

// donorRouter.post("/donate", async (req, res) => {
//   try {
//     const { donorName, ngo_id, description, count, address, areasOfInterest, images, type } = req.body;
//     const donation = new Donation({
//       donorName,
//       ngo_id,
//       description,
//       count,
//       address,
//       areasOfInterest,
//       images,
//       type,
//     });
//     await donation.save();
//     res.json(donation);
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

// module.exports = donorRouter;
