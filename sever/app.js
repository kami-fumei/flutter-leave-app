import express from "express"
import cookieParser from "cookie-parser";
import dotenv from "dotenv";
import { connectDB } from "./db/dbConnect.js";
import routes from "./routes/userRoutes.js";
import  cors from 'cors'
dotenv.config({
    path: './.env'
})

const app = express();

app.use(cors({
    origin:process.env.CORS_PORT,  
    credentials:true
}))

app.use(express.json(/*{limit:"16kb"}*/));
app.use(express.urlencoded({extended:true, limit:"16kb"}))
app.use(cookieParser());
app.use(routes); 

connectDB().then(()=>{
    let PORT= process.env.PORT; 
    app.listen(PORT,()=>{
        console.log(`Server listening at ${PORT}`);
    })
}
).catch((err)=>{
console.log(`DB not connected (index.js) errr: ${err}`);

}); 