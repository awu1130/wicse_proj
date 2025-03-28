const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const { MongoClient } = require('mongodb');

const app = express();
const PORT = process.env.PORT || 5000; 

app.use(cors());
app.use(bodyParser.json());

// MongoDB connection 
const MONGO_URI = 'mongodb+srv://angelinaaqwu:A3F4%233hB%40q.7DnH@cluster0.bko15.mongodb.net/WiCSEProject?retryWrites=true&w=majority';
let db;
mongoose.connect(MONGO_URI,).then(() => {
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

const MONGO_ATLAS_URI = 'mongodb+srv://angelinaaqwu:A3F4%233hB%40q.7DnH@cluster0.bko15.mongodb.net/WiCSEProject?retryWrites=true&w=majority';

MongoClient.connect(MONGO_ATLAS_URI)
  .then(client => {
    db = client.db('WiCSEProject');
    console.log('Connected to MongoDB Atlas');
  })
  .catch(error => console.error('Error connecting to MongoDB Atlas:', error));

// user schema
const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
});

const User = mongoose.model('User', userSchema);

app.post('/register', async (req, res) => {
  const { username, email, password } = req.body;
  try {
    const userExists = await User.findOne({ email });
    if (userExists) {
      return res.status(400).json({ message: 'Email already in use' });
    }

      // creates new user
    const newUser = new User({
      username,
      email,
      password, // possibly change to hashing
    });

    // saves
    await newUser.save();
    res.status(201).json({ message: 'User registered successfully' });
  } 
  catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error registering user' });
  }
});

app.post('/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    const user = await User.findOne({ username });
    if (!user || password !== user.password) {
      return res.status(400).json({ message: 'Invalid username or password' });
    }

    res.status(201).json({ message: 'Login successful', user: user });
  } 
  catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// medicine schema
const medicineSchema = new mongoose.Schema({
  name: { type: String, required: true },
  time: { type: String, required: true }
});

const Medicine = mongoose.model('Medicine', medicineSchema);

// medicine
app.post('/saveMed', async (req, res) => {
  const { name, time } = req.body;

  try {
    const medExists = await Medicine.findOne({ name, time });
    if (medExists) {
      return res.status(400).json({ message: 'Medicine already exists' });
    }

    const newMedicine = new Medicine({ name, time });
    await newMedicine.save();
    res.status(201).json({ message: 'Medicine saved successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error saving medicine', error });
  }
});

app.get('/getMeds', async (req, res) => {
  try {
      const medicines = await Medicine.find();
      res.json(medicines);
  } catch (error) {
      res.status(500).json({ error: error.message });
  }
});

// start
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
