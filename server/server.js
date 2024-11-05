const express = require('express');
const { MongoClient } = require('mongodb');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const port = 3000; // Port for your server

app.use(cors());
app.use(bodyParser.json());

// MongoDB connection string URL
const url = 'mongodb+srv://angelinaaqwu:A3F4%233hB%40q.7DnH@cluster0.bko15.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';
const dbName = 'WiCSEProject';
let db;

// Connect to MongoDB
MongoClient.connect(url)
  .then(client => {
    console.log('Connected to Database');
    db = client.db(dbName);
  })
  .catch(err => console.error(err));

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
});
