const mongoose = require('mongoose');


const ratingSchema = mongoose.Schema({
    donorId:{
        type:String,
        required:true,
    },
    rating:{
        type:Number,
        required:true
    },
});

module.exports = ratingSchema;