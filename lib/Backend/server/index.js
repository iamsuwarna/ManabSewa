const express = require("express");
const mongoose = require('mongoose');

//import from other files in main file i.e. index.js
const authRouter = require("./routes/auth");
const donorRouter = require("./routes/donor");
const ngoRouter = require("./routes/ngo");
const router = require("./routes/recommend");


//initializing express in the name of 'app'
const PORT = 3000;
const app = express();
const DB = "mongodb+srv://subarna:subarna12@cluster0.82joz.mongodb.net/?retryWrites=true&w=majority";

//middleware
//client-->server-->(response)client
//client(data format no idea)-->middleware(fixes tha data format issue)-->server(gets data)
app.use(express.json());
app.use(authRouter);
app.use(donorRouter);
app.use(ngoRouter);
app.use(router);


mongoose.set('strictQuery', false);

//connections
mongoose.connect(DB).then(() => {
    console.log('Connection Successful');
}).catch((e) => {
    console.log(e);
});


//port listening
app.listen(PORT,"0.0.0.0",() => {
    console.log(`connected at port ${PORT}`);
  });
