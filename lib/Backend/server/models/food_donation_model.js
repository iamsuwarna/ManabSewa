const mongoose = require('mongoose');

const FoodDonationSchema = mongoose.Schema({
    donorName:{
        type:String,
        required:true,
        trim:true
    },
    ngo_id:{
        type:String,
        required:true,trim:true,
    },
    food_description:{
        type:String,
        required:true,
        trim:true
    },
    food_count:{
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

const FoodDonation = mongoose.model("FoodDonation", FoodDonationSchema);
module.exports = FoodDonation;