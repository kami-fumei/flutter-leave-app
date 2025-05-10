import mongoose from "mongoose";

const requestSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User", // name of the model you’re referencing
      required: true,
    },
    // compenyId: {
    //   type: Number,
    // },
    name: {
      type: String,
      required: true,
      trim: true,
    },
    reason:{
      type: String,
      required: true,
      trim: true,
    },
    body:{
      type: String,
    },
    from: {
      type: String,
      required: true,
    },
    to: {
      type: String,
      required: true,
    },
    status: {
      type: Boolean,
      default: null,
    },
    On: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

const Request = mongoose.model("Request", requestSchema);
export default Request;
