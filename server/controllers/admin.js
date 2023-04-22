import Product from '../models/product.js';

let addProduct = async (req, res) => {
    try {
        const {name,price,description,category,quantity,images} = req.body;
        if(!name || !price || !description || !category || !quantity ||!images){
            return res.status(400).json({msg:"Please fill all the fields"});
        }
        const product = new Product({
            name,
            price,
            description,
            category,
            quantity,
            images
        });
        const savedProduct = await product.save();
        return res.status(200).json({msg:"Product Added Successfully",product:savedProduct});
    } catch (error) {
            return res.status(400).json({msg:"error happend" + error.message});
    }
}




export default addProduct;