import { Router } from 'express';
import {login,signup} from '../controllers/userController.js'
import { getAdminRequest,getUersRequest } from '../controllers/getController.js';
import { createRequest,updateReqByAdmin } from '../controllers/uploadController.js';
import { AuthVerify as auth } from '../Middlewares/auth.js';
const routes = new Router();

// Add routes
routes.post('/signup', signup);
routes.post('/login', login);
routes.get('/getUserReq',auth,getUersRequest);
routes.get('/getLeaveReq',auth,getAdminRequest);
routes.post('/create',auth,createRequest);
routes.post('/updateStatus',auth,updateReqByAdmin); 
export default routes;
