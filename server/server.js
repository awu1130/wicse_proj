const mongoose = require('mongoose');
const express = require('express');

const mongoose = require('mongoose');
const cors = require('cors');
const { MongoClient } = require('mongodb');

const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();

const port = 3000; // Port for your server

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

// MongoDB connection string URL
const url = var.mongoDB;
const dbName = 'WiCSEProject';
let db;


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

// GET endpoint to retrieve data
app.get('/data', async (req, res) => {
  try {
    const data = await db.collection('collection_name').find().toArray();
    console.log('Data fetched from the database:', data);
    res.json(data);
  } catch (error) {
    console.error('Error fetching data:', error);
    res.status(500).send('Error fetching data');
  }
});

app.post('/data', async (req, res) => {
  try {
    console.log('Received data:', req.body); // Log the incoming data
    
    const { symptoms, medicines } = req.body;

    if (!Array.isArray(symptoms) || !Array.isArray(medicines)) {
      return res.status(400).json({ error: 'Invalid data format. "symptoms" and "medicines" should be arrays.' });
    }

    const result = await db.collection('collection_name').insertOne({ symptoms, medicines });
    console.log('Data inserted:', result);
    res.status(201).json(result);
  } catch (error) {
    console.error('Error posting data:', error);
    res.status(500).send('Error posting data');

  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);


// middleware
app.use(cors()); // Allow all origins
app.use(bodyParser.json()); // Parse incoming JSON requests

// mongodb
mongoose.connect('mongodb+srv://angelinaaqwu:A3F4%233hB%40q.7DnH@cluster0.bko15.mongodb.net', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  })
.then(() => console.log('Connected to MongoDB Atlas'))
.catch((error) => console.error('Error connecting to MongoDB Atlas:', error));

// user schema
const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
});

const User = mongoose.model('User', userSchema);

// routes
// register new user
app.post('/register', async (req, res) => {
const { username, email, password } = req.body;
try {
  // does user already exist?
  const userExists = await User.findOne({ email });
  if (userExists) {
    return res.status(400).json({ message: 'Email already in use' });
  }

  // creates new user
  const newUser = new User({
    username,
    email,
    password,  // No hashing here, password is stored directly
  });

  // saves
  await newUser.save();
  res.status(201).json({ message: 'User registered successfully' });
} catch (error) {
  console.error(error);
  res.status(500).json({ message: 'Error registering user' });
}
});

// starts
app.listen(5000, () => {
console.log('Server running on http://localhost:5000');

});
