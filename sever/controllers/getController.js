import User from "../models/userModel.js";
import Request from "../models/requestModel.js";

const getUersRequest = async (req, res)=>{
  try {
      const leaveReq =await Request.find({userId:req.user._id}).select("-userId -_id");
      if(!leaveReq){
          return res.status(500).json({message:"something want worng usernot"})
      }
      res.status(200).json(leaveReq);
  } catch (error) {
    console.log(error);
    return res.status(500).json({message:"something want worng"})
  }
}

const getAdminRequest = async (req, res)=>{
  try {
      const user = await User.findById(req.user._id);
      // const {status} = req.body;
      
      if(!user.isAdmin){
          return res.status(400).json({message:"Unauthorised"})
      }
      const leaveReq = await Request.find();
  
      if(!leaveReq){
          return res.status(500).json({message:"something want worng"})
      }
  
      res.status(200).json(leaveReq);
  } catch (error) {
    return res.status(500).json({message:"something want worng",error})
  }
}

export {getUersRequest,getAdminRequest};