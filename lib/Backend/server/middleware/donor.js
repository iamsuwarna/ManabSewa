const jwt = require("jsonwebtoken");
const Donor = require("../models/donor_model");
//creating a middleware named 'auth'
//we need two middlewares i.e. donor and ngo donor is like admin and ngo is like donor
//why? --> adding auth middleware and performing all the donor validation
const donor = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    //if there's no token
    if (!token)
      return res.status(401).json({ msg: "No auth token, access denied" });
    const verified = jwt.verify(token, "passwordKey");
    //if token is not verified
    if (!verified)
      return res
        .status(401)
        .json({ msg: "Token verification failed, authorization denied." });

    const donor = await Donor.findById(verified.id);
    //chechking donor type
    if (donor.type == "NGO") {
      return res.status(401).json({ msg: "You are not the donor" });
    }
    req.donor = verified.id;
    req.token = token;
    next();
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = donor;
