import mongoose from 'mongoose';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

const userSchema = new mongoose.Schema({
  // compenyId:{
  //   type:mongoose.Schema.ObjectId,
  // ref:"Compeny"
  //     },
  name: {
    type: String,
    required: true,
    trim: true
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true
  },
  password: {
    type: String,
    required: true,
    minlength: 6
  },
  refreshToken: {
    type: String,
    default: null
  },
  isAdmin:{
    type:Boolean,
    default: false,
  },
}, {
  timestamps: true
});

// Hash password before saving
userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) {
    return next();
  }
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

// Check if entered password is correct
userSchema.methods.isPasswordCorrect = async function(enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

// Generate Access Token
userSchema.methods.generateAccessToken = function() {
  return jwt.sign(
    { id: this._id, email: this.email },
    process.env.ACCESS_TOKEN_SECRET,
    { expiresIn: '3d' }
  );
};

// Generate Refresh Token and save it
userSchema.methods.generateRefreshToken = async function() {
  const refreshToken = jwt.sign(
    { id: this._id },
    process.env.REFRESH_TOKEN_SECRET,
    { expiresIn: '7d' }
  );
  this.refreshToken = refreshToken;
  await this.save();
  return refreshToken;
};

// Static method to verify a refresh token
userSchema.statics.verifyRefreshToken = function(token) {
  try {
    return jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);
  } catch (err) {
    return null;
  }
};

const User = mongoose.model('User', userSchema);
export default User;  
  