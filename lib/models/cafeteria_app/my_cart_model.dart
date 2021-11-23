import 'package:cafeteriat/models/cafeteria_app/product_model.dart';

class MyCartModel {
  double totalPrice = 0.0;
  int? lastUpdateTime;
  int totalItems = 0;
  List<ProductDataModel> products = [];

  MyCartModel.fromJson(Map<String, dynamic> json) {
    totalPrice = json['totalPrice'];
    totalItems = json['totalItems'];
    lastUpdateTime = json['lastUpdateTime'];
    if (json['list'] != null) {
      json['list'].forEach((element) {
        products.add(ProductDataModel.fromJson(element));
      });
    }
  }

  toMap() {
    Map saveMyCart = {
      'totalPrice': totalPrice,
      'totalItems': totalItems,
      'lastUpdateTime': lastUpdateTime,
      'list': [],
    };
    products.forEach((element) {
      saveMyCart['list'].add(element.toMap());
    });
    return saveMyCart;
  }

  MyCartModel.clear() {
    totalPrice = 0.0;
    lastUpdateTime = 0;
    totalItems = 0;
    products = [];
  }
}
//
// class MyCartDataModel {
//   int? id;
//   String? name;
//   double? price;
//   String? image;
//   int? counter;
//   int? quantity;
//
//   MyCartDataModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     price = json['price'];
//     image = json['image'];
//     counter = json['counter'];
//     quantity = json['quantity'];
//   }
//
//
// }
