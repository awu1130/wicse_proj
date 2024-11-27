const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const { MongoClient } = require('mongodb');
const bodyParser = require('body-parser');

const app = express();
const port = 3000; // Change this to your desired port

app.use(cors());
app.use(bodyParser.json());

const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/plantDB';
mongoose.connect(MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => {
  console.log('Connected to MongoDB');
}).catch(err => {
  console.error('Error connecting to MongoDB:', err);
});

// Mongoose Schema and Model
const plantSchema = new mongoose.Schema({
  name: { type: String, required: true },
  imagePath: { type: String, required: true },
});

const Plant = mongoose.model('Plant', plantSchema);

// Fetch all plants
app.get('/plants', async (req, res) => {
  try {
    const plants = await Plant.find();
    res.json(plants);
  } catch (error) {
    console.error('Error fetching plants:', error);
    res.status(500).send('Error fetching plants');
  }
});

// POST: Add a new plant
app.post('/plants', async (req, res) => {
  try {
    const { name, imagePath } = req.body;
    if (!name || !imagePath) {
      return res.status(400).send('Name and imagePath are required');
    }
    const newPlant = new Plant({ name, imagePath });
    await newPlant.save();
    res.status(201).json(newPlant);
  } catch (error) {
    console.error('Error adding plant:', error);
    res.status(500).send('Error adding plant');
  }
});
  
// starts server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
