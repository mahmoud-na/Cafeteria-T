class ProductModel {
  MenuModel? data;

  ProductModel.fromJson(Map<String, dynamic> json) {
    data = MenuModel.fromJson(json['Menu'][0]);
  }
}

class MenuModel {
  bool? validState;
  List<FoodModel> food = [];
  List<BeveragesModel> beverages = [];
  List<DessertsModel> desserts = [];
  List<SnacksModel> snacks = [];

  MenuModel.fromJson(Map<String, dynamic> json) {
    if (json['Food'] != null) {
      json['Food'].forEach((element) {
        food.add(FoodModel.fromJson(element));
      });
    }
    if (json['Beverages'] != null) {
      json['Beverages'].forEach((element) {
        beverages.add(BeveragesModel.fromJson(element));
      });
    }

    if (json['Snacks'] != null) {
      json['Snacks'].forEach((element) {
        snacks.add(SnacksModel.fromJson(element));
      });
    }

    if (json['Desserts'] != null) {
      json['Desserts'].forEach((element) {
        desserts.add(DessertsModel.fromJson(element));
      });
    }
  }
}

class FoodModel {
  int? id;
  String? name;
  double? price;
  String? image;
  int? counter;
  int? quantity;

  FoodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    counter = json['counter'];
    quantity = json['quantity'];
  }
}

class BeveragesModel {
  int? id;
  String? name;
  double? price;
  String? image;
  int? counter;
  int? quantity;

  BeveragesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    counter = json['counter'];
    quantity = json['quantity'];
  }
}

class DessertsModel {
  int? id;
  String? name;
  double? price;
  String? image;
  int? counter;
  int? quantity;

  DessertsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    counter = json['counter'];
    quantity = json['quantity'];
  }
}

class SnacksModel {
  int? id;
  String? name;
  double? price;
  String? image;
  int? counter;
  int? quantity;

  SnacksModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    counter = json['counter'];
    quantity = json['quantity'];
  }
}
