import 'package:cafeteriat/models/cafeteria_app/product_model.dart';

class MyCartModel{
  double? totalPrice ;
  int? totalItems ;
  List<ProductDataModel> products = [];
  MyCartModel({this.totalItems, this.totalPrice,});
}

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
// }
