const mongoose = require('mongoose');
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();

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
