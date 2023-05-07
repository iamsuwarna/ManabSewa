const mongoose = require('mongoose');


const bookmarkSchema = mongoose.Schema({
    
    donorId:{
        type:String,
        required:false,
    },

    NGOId:{
        type:Number,
        required:false
    },
    NGOName:{
        type:String,
        required:false
    },
    NGOAddress:{
        type:String,
        required:false
    },
    NGOPhoneNumber:{
        type:String,
        required:false
    },
    NGOEmailAddress:{
        type:String,
        required:false
    }
});

module.exports = bookmarkSchema;