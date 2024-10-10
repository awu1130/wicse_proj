const express = require('express');
const { MongoClient } = require('mongodb');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const port = 3000; // Change this to your desired port

app.use(cors());
  
app.use(bodyParser.json());

// MongoDB connection string URL (i believe you must change to your own!)
const url = 'mongodb+srv://angelinaaqwu:A3F4%233hB%40q.7DnH@cluster0.bko15.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';
const dbName = 'WiCSEProject'; // Your database name
let db;

// Connect to MongoDB
MongoClient.connect(url)
  .then(client => {
    console.log('Connected to Database');
    db = client.db(dbName);
  })
  .catch(err => console.error(err));

//GET
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
//POST
app.post('/data', async (req, res) => {
    try {
      const result = await db.collection('collection_name').insertOne(req.body);
      console.log('Data inserted:', result);
      res.status(201).json(result);
    } catch (error) {
      console.error('Error posting data:', error);
      res.status(500).send('Error posting data');
    }
});
  
// starts server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
