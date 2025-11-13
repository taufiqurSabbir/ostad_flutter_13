import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_13/module_13/CRUD/productcontroller.dart';
import 'package:http/http.dart' as http;

import 'model/productModel.dart';

class Crud extends StatefulWidget {
  const Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  ProductController productController = ProductController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    await productController.fetchProducts();
    if (mounted) setState(() {});
  }

  productDialog(){
    TextEditingController productNameController = TextEditingController();
    TextEditingController productIMGController = TextEditingController();
    TextEditingController productQTYController = TextEditingController();
    TextEditingController productUnitPriceController = TextEditingController();
    TextEditingController productTotalPriceController = TextEditingController();
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text('Add product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                labelText: 'Name'
              ),
            ),
            SizedBox(height: 10,),

            TextField(
              controller: productIMGController,
              decoration: InputDecoration(
                  labelText: 'Image'
              ),
            ),
            SizedBox(height: 10,),

            TextField(
              controller: productQTYController,
              decoration: InputDecoration(
                  labelText: 'QTY'
              ),
            ),
            SizedBox(height: 10,),

            TextField(
              controller: productUnitPriceController,
              decoration: InputDecoration(
                  labelText: 'Unit price'
              ),
            ),
            SizedBox(height: 10,),

            TextField(
              controller: productTotalPriceController,
              decoration: InputDecoration(
                    labelText: 'Total price'
              ),
            ),
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('Cancle')),
                
                ElevatedButton(onPressed: () async {
                  productController.createProduct(Data(
                    productName: productNameController.text,
                    img: productIMGController.text,
                    qty: int.parse(productQTYController.text),
                    unitPrice: int.parse(productUnitPriceController.text),
                    totalPrice: int.parse(productTotalPriceController.text)
                  ));
                  await fetchData();
                  Navigator.pop(context);
                }, child: Text('Save',style: TextStyle(color: Colors.white),))
              ],
            )

          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product from API'),
      ),
      body: productController.isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8),
              itemCount: productController.products.length,
              itemBuilder: (context, index) {
                final item = productController.products[index];
                return Card(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 140,
                          child: Image.network(item.img.toString()),
                        ),
                        Text(
                          item.productName.toString(),
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('Price: \$${item.unitPrice} | QTY:${item.qty}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  productDialog();
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                )),
                            IconButton(
                                onPressed: () async {
                                 await productController.deleteProduct(item.sId.toString()).then((value) async {
                                   if(value){
                                        await fetchData();
                                     ScaffoldMessenger.of(context).showSnackBar(
                                       SnackBar(content: Text('Product Deleted'))
                                     );
                                   }else{
                                     ScaffoldMessenger.of(context).showSnackBar(
                                         SnackBar(content: Text('Something went wrong ...!'))
                                     );
                                   }

                                 });
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          productDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
