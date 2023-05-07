const mongoose = require('mongoose');

const ClothDonationSchema = mongoose.Schema({
    donorName:{
        type:String,
        required:true,
        trim:true
    },
    ngo_id:{
        type:String,
        required:true,trim:true,
    },
    cloth_description:{
        type:String,
        required:true,
        trim:true
    },
    cloth_count:{
        type:Number,
        required:true
    },
    address:{
        type:String,
        required:true,
        trim:true
    },
    areasOfInterest:[{
        type:String,
        required:true
    }],
    images:[{
        type:String,
        required:true
    }]

});

const ClothDonation = mongoose.model("ClothDonation", ClothDonationSchema);
module.exports = ClothDonation;
