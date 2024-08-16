
import 'package:flutter/material.dart';
import 'package:myflutter/model/product.dart';
import 'package:myflutter/provider/product_provider.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

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
  var _initValues = {
    'name': '',
    'description': '',
    'unitPrice': '',
    'imageUrl': '',
  };

  Future<bool> isUrlValid(url) async {
    try {
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveForm() async {
    bool isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (!await isUrlValid(_imageUrlController.text)) {
      return;
    }
    _form.currentState!.save();
    if (_editedProduct.id != 0) {
      context.read<ProductProvider>().updateProduct(_editedProduct);
    } else {
      context.read<ProductProvider>().addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  final _imageUrlController = TextEditingController();

  _updateImageUrl() async {
    if (!_imageFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') && !_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      if (await isUrlValid(_imageUrlController.text)) {
        setState(() { });
      }
    }
  }

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final productId = ModalRoute.of(context)!.settings.arguments as int;
      if (productId != 0) {
        _editedProduct = context.read<ProductProvider>().findById(productId);
        _initValues = {
          'name': _editedProduct.name,
          'description': _editedProduct.description,
          'unitPrice': _editedProduct.unitPrice.toString(),
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

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
                initialValue: _initValues['name'],
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocusNode),
                onSaved: (value) => _editedProduct = Product(
                  name: value!,
                  unitPrice: _editedProduct.unitPrice,
                  description: _editedProduct.description,
                  imageUrl: _editedProduct.imageUrl,
                  id: _editedProduct.id,
                  isFavorite: _editedProduct.isFavorite,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please input the value';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                initialValue: _initValues['unitPrice'],
                focusNode: _priceFocusNode,
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocusNode),
                onSaved: (value) => _editedProduct = Product(
                    name: _editedProduct.name,
                    unitPrice: double.parse(value!),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                ),
                validator: (value) {
                  if (value!.isEmpty) { return "Please input price";}
                  if (double.tryParse(value) == null) { return 'Please enter a valid number';}
                  if (double.parse(value) <= 0) {return 'Please enter a number greater than 0';}
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                initialValue: _initValues['description'],
                focusNode: _descriptionFocusNode,
                // keyboardType: TextInputType.multiline,
                onSaved: (value) => _editedProduct = Product(
                    name: _editedProduct.name,
                    unitPrice: _editedProduct.unitPrice,
                    description: value!,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please input the value';
                  }
                  return null;
                },
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
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {return 'Please enter a image URL';}
                        if (!value.startsWith('http') && !value.startsWith('https')) {
                          return 'Please enter a valid URL';
                        }
                        if (!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')) {
                          return 'Please enter a valid URL';
                        }
                        return null;
                      },
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