const mongoose = require("mongoose");
const Bookmark = require('./bookmark_model');

//scehma is the strcture of the model
const donorSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    //removes all extra spaces
    trim: true,
  },
  email: {
    type: String,
    trim: true,
    required: true,
    //for validation like @, .com
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },
  phone_number:{
    type: String,
    required: true,

  },
  password: {
    type: String,
    trim: true,
    required: true,
    validate: {
      validator: (value) => {
        return value.length > 6;
      },
      message: "Please enter a longer password",
    },
  },
  address: {
    type: String,
    default: "",
  },
  //FIRST FOR DONOR SCREEN
  type: {
    type: String,
    default: "Donor",
  },
  bookmark: [Bookmark]

 
  //cart
});

//this is the user model
const Donor = mongoose.model("Donor", donorSchema);

//export model
module.exports = Donor;
