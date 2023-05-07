const express = require("express");
//const User = require("../models/user_model");
const bcryptjs = require("bcryptjs");
//json web token for signin
const jwt = require('jsonwebtoken');
//auth middleware
const auth = require("../middleware/auth");
const NGO = require("../models/ngo_model");
const Donor = require("../models/donor_model");
const donor = require("../middleware/donor");
const bodyParser = require('body-parser');
const { spawn } = require('child_process');

//creating router for handleing large amount of codes
//i.e. authrouter is for authentication only
const authRouter = express.Router();
//first-->.for Signup
authRouter.post('/api/signup', async (req, res)=>{
    try{
        //1.getting data from user 
    const {name, email, phone_number, password} = req.body;

    //checking if the users have same email address
    // checking from "User" because it is the model
    //finding takes time so it is async
    const existngUser = await Donor.findOne({ email });
    if(existngUser){
        return res
        .status(400)
        .json({message:"User with same email already exists!"});
    }
    //hashing password with salting technique
    const hashedPassword = await bcryptjs.hash(password, 8);
    //2.saving user data to database
    //creating an user model referencing schema
    let user = new Donor({
        name,
        email,
        phone_number,
        password: hashedPassword,
    });
    //saving user data to database
    user = await user.save();
    //3. giving back to user the data
    res.json(user);
    }
    catch(e){
        res.status(500).json({ error: e.message })
    }
});

//second-->.signin 
authRouter.post("/api/signin", async (req, res) => {
    try {
        //a. getting email and password
      const { email, password } = req.body;
  
       //b. finding user with that email
      const donor = await Donor.findOne({ email });
      if (!donor) {
        return res
          .status(400)
          .json({ msg: "User with this email does not exist!" });
      }
  
      //3. compairing password from database
      const isMatch = await bcryptjs.compare(password, donor.password);
      if (!isMatch) {
        return res.status(400).json({ msg: "Incorrect password." });
      }
  
      //4. use of jsonwebtoken and token is in string
      const token = jwt.sign({ id: donor._id }, "passwordKey");
       
      res.json({ token, ...donor._doc });
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });
  //third-->valid token
authRouter.post("/tokenIsValid", async (req, res)=> {
  try{
     const token = req.header('x-auth-token');
     if(!token) return res.json(false);
     const verified = jwt.verify(token, "passwordKey");
     if(!verified) return res.json(false);
     const donor = await Donor.findById(verified.id);
     console.log(donor); 
     if(!donor) return res.json(false);
     res.json(true);
  }catch(e){
      res.status(500).json("This is error" + { error: e.message });
  }
});
 


//get user data
authRouter.get('/', auth,async (req, res) => {
  const donor = await Donor.findById(req.donor);
  console.log(donor);
  res.json({...donor._doc, token: req.token});
} )







//first-->.for Signup ngo
authRouter.post('/api/signup/ngo', async (req, res)=>{
  try{
      //1.getting data from user 
  const {ngo_id, name, address, password, phone_number, email1, email,token} = req.body;
  // console.log(req.body);

  //checking if the users have same NGO ID
  // checking from "NGO" because it is the model
  //finding takes time so it is async
  const existingNGO = await NGO.find({});
  for( i=0;i<existingNGO.length;i++){
    if(existingNGO[i].ngo_id==ngo_id){
      return res
      .status(400)
      .json({msg:"NGO with same ID already exists!"});
  }
  }


  //hashing password with salting technique
  const hashedPassword = await bcryptjs.hash(password, 8);

  //2.saving NGO data to database
  //creating an NGO model referencing schema
  let ngo = new NGO({
      ngo_id,
      name,
      address,
      password: hashedPassword,
      phone_number,
      email1,
      email
  });
  
  //saving NGO data to database
  ngo = await ngo.save();
  //3. giving back to user the data
  res.json(ngo);
  }
  catch(e){
      res.status(500).json({ error: e.message })
  }
});



//for ngo sign in
authRouter.post("/api/signin/ngo", async (req, res) => {
  try {
  //a. getting ngo_id and password
  const { ngo_id, password } = req.body;
  
     //b. finding ngo with that ngo_id
    const ngo = await NGO.findOne({ ngo_id });
    if (!ngo) {
      return res
        .status(400)
        .json({ msg: "NGO with this ngo_id does not exist!" });
    }
  
    //3. compairing password from database
    const isMatch = await bcryptjs.compare(password, ngo.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password." });
    }
  
    //4. use of jsonwebtoken and token is in string
    const token = jwt.sign({ id: ngo._id }, "passwordKey");
     //sending token into app's memory
  // //...ngo._doc is used for destructing
  // // {
  // // 'token':'token',
  // // 'name':'subarna'
  // // }
  res.json({ token, ...ngo._doc });
  } catch (e) {
  res.status(500).json({ error: e.message });
  }
  });

  //getngotoken
  authRouter.post('/ngo-tokenisvalid', async (req, res)=>{
    try{
      const tokens = req.header('x-auth-token');
      if(!tokens) return res.json(false);

     const verification =  jwt.verify(tokens, "passwordKey");

     if(!verification) return res.json(false);
     const ngo = await NGO.findById(verification.id);
     if(!ngo) return res.json(false);
     res.json(true);
    }
    catch(e){
      res.status(500).json({error:e.message});
    }

  });

  //get ngo data
  authRouter.get('/ngo', auth,async (req, res) => {
    const ngo = await NGO.findById(req.donor);
    console.log(ngo);
    res.json({...ngo._doc, token: req.token});
  });




//exporting this router 
module.exports = authRouter;





