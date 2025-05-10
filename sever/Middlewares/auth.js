import jwt from "jsonwebtoken";
import USER from "../models/userModel.js";
export const AuthVerify = async (req, res, next) => {
    try {
      const ACCESS_TOKEN = req.cookies?.ACCESS_TOKEN ||
        req.header('accesstoken');
 

      if (!ACCESS_TOKEN) {
        return res.status(401).json({ message: 'Access token required',code:4 });
      }
      let decodedInfo;
     try {
        decodedInfo = jwt.verify(
         ACCESS_TOKEN,
         process.env.ACCESS_TOKEN_SECRET
       );
     } catch (error) {
      return res.status(400).json({
        message:"Expired token err :"+error
        ,code:4 
      })
     }
  
    //   console.log(decodedInfo)
      const user = await USER.findById(decodedInfo.id).select(
        '-password -refreshToken'
      );
  
      if (!user) {
        return res.status(401).json({ message: 'Unauthorized request' 
          ,code:4 
        });
      }
      req.user = user;
       next();
    } catch (error) {
      next(error);
    }
  };