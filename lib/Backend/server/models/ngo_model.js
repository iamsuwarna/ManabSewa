const mongoose = require("mongoose");
const ratingSchema = require('./rating');
const ngosSchema = mongoose.Schema({
  ngo_id: {
    required: true,
    type: String,
    trim: true,
  },
  name: {
    required: true,
    type: String,
    trim: true,
  },
  address: {
    type: String,
    trim: true,
    default: "",
  },
  password: {
    type: String,
    trim: true,
    required: true,
   
  },
  phone_number: {
    type: String,
    required: true,
    trim: true,
  },
  email1:{
    type: String,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    trim: true,
    required: true,
    //for validation like @, .com
    // validate: {
    //   validator: (value) => {
    //     const re =
    //       /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
    //     return value.match(re);
    //   },
    //   message: "Please enter a valid  address",
    // },
  },
  ratings: [ratingSchema]
});
const NGO = mongoose.model("NGO", ngosSchema);
module.exports = NGO;
