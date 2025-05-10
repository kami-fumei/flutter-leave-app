import User from '../models/userModel.js';
// import jwt from 'jsonwebtoken';

// POST /api/auth/signup
export const signup = async (req, res) => {
  try {
    const { name, email, password } = req.body;
    if (!name || !email || !password) {
      return res.status(400).json({ message: 'All fields are required.' });
    }

    const existing = await User.findOne({ email });
    if (existing) {
      return res.status(409).json({ message: 'Email already in use.' });
    }

    const user = await User.create({ name, email, password });

    res.status(201).json({message:"Created user successfully",
      user: { name: user.name, email: user.email },
      // accessToken,
      // refreshToken
    });
  } catch (err) {   
    console.error('Signup error:',req.body,err);
    res.status(500).json({ message: 'Server error during signup.'  });
  }
};

// POST /api/auth/login
export const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password are required.' });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ message: 'Invalid credentials.Email' });
    }

    const valid = await user.isPasswordCorrect(password.toString());
    if (!valid) {
      return res.status(401).json({ message: 'Invalid credentials.' });
    }

    const accessToken = user.generateAccessToken();
    const refreshToken = await user.generateRefreshToken();

    res.set({'accesstoken': accessToken,
      'refreshtoken':refreshToken
    });
    res.status(201).json({
  id: user._id, name: user.name, email: user.email,isAdmin:user.isAdmin ,}
    );
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ message: 'Server error during login',
     });
  }
};
