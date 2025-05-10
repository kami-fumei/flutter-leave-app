import Request from '../models/requestModel.js';
import User from '../models/userModel.js';

// POST /api/requests
 const createRequest = async (req, res) => {
  try {
    const { reason,body, from, to } = req.body;

    if (!reason || !from || !to ) {
      return res.status(400).json({ message: 'All fields except status are required.' });
    }

    const request = await Request.create({
      reason,
      body:body?body:"",
      from,
      to, 
      userId:req.user._id,
      name:req.user.name
    });
    res.status(201).json(request,);
  } catch (err) {
    console.error('Create Request error:', err);
    res.status(500).json({ message: 'Server error while creating request.' });
  }
};

  
  const updateReqByAdmin = async(req,res)=>{
    try {
  const {status,_id} =req.body;
  const user = await User.findById(req.user._id);
      if(!user.isAdmin){
          return res.status(400).json({message:"Unauthorised"})
      }
  const respons = await Request.findByIdAndUpdate(_id,{status});
  
  res.status(200).json(respons);
} catch (error) {
   res.status(500).json({message:"err:"+error});
}
}

export {createRequest,updateReqByAdmin}