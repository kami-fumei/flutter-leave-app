import mongoose from "mongoose"

export const connectDB = async ()=>{
 try{
   console.log(process.env.MONGODB_URL);
   
    const connectionInstance =await mongoose.connect(`${process.env.MONGODB_URL}`);
    console.log(`DB connected successfuly ${(connectionInstance.connection.host)}`);
    // console.log("conec obj",connectionInstance);
 }catch(err){
    console.log(`DB connrctio failed  Err: ${err}`);
    process.exit(1); 
 }
}