const express = require('express');
const bodyParser = require('body-parser');
const { spawn } = require('child_process');

const router = express.Router();

router.use(bodyParser.json());

router.post('/recommend', (req, res) => {
  const { district, zone } = req.body;
  console.log(req.body);
  const pythonProcess = spawn('python', ['recommend.py', district, zone]);
  pythonProcess.stdout.on('data', (data) => {
    const recommendedNGOs = JSON.parse(data.toString());
    const recommendedNGOsJSON = JSON.stringify({ recommendedNGOs });
    res.send(recommendedNGOsJSON);
    console.log(recommendedNGOsJSON)
  });

  pythonProcess.stderr.on('data', (data) => {
    console.error(`stderr: ${data}`);
  });

  pythonProcess.on('close', (code) => {
    console.log(`child process exited with code ${code}`);
  });
});

module.exports = router;
