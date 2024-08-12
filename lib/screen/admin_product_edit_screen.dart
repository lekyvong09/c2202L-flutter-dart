

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myflutter/model/product.dart';

class AdminProductEditScreen extends StatefulWidget {
  static const routeName = '/product-edit';

  const AdminProductEditScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminProductEditScreen();
}

class _AdminProductEditScreen extends State<AdminProductEditScreen> {
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  Product _editedProduct = Product(id: 0, name: '', unitPrice: 0, description: '', imageUrl: '');

  void _saveForm() {
    _form.currentState!.save();
    log(_editedProduct.name);
    log(_editedProduct.description);
    log(_editedProduct.imageUrl);
    log(_editedProduct.unitPrice.toString());
  }

  final _imageUrlController = TextEditingController();

  _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() { });
    }
  }

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: _saveForm,
              icon: const Icon(Icons.save)
          )
        ],
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocusNode),
                onSaved: (value) => _editedProduct = Product(
                  name: value!,
                  unitPrice: _editedProduct.unitPrice,
                  description: _editedProduct.description,
                  imageUrl: _editedProduct.imageUrl,
                  id: 0
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocusNode),
                onSaved: (value) => _editedProduct = Product(
                    name: _editedProduct.name,
                    unitPrice: double.parse(value!),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: 0
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                // keyboardType: TextInputType.multiline,
                onSaved: (value) => _editedProduct = Product(
                    name: _editedProduct.name,
                    unitPrice: _editedProduct.unitPrice,
                    description: value!,
                    imageUrl: _editedProduct.imageUrl,
                    id: 0
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    child: _imageUrlController.text.isEmpty
                        ? const Text('Enter a URL')
                        : FittedBox(fit: BoxFit.cover, child: Image.network(_imageUrlController.text),),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      focusNode: _imageFocusNode,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onEditingComplete: () => setState(() {}),
                      onSaved: (value) => _editedProduct = Product(
                          name: _editedProduct.name,
                          unitPrice: _editedProduct.unitPrice,
                          description: _editedProduct.description,
                          imageUrl: value!,
                          id: 0
                      ),
                    )
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

}