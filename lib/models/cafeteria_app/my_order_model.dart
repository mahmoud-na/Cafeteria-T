class MyOrderModel {
  MyOrderDataModel? data;

  MyOrderModel.fromJson(Map<String, dynamic> json) {
    data = MyOrderDataModel.fromJson(json["MyOrder"][0]);
  }
}

class MyOrderDataModel {
  String? dateTime;
  int? orderNumber;
  double? totalPrice;
  bool? timeAuthorization;
  List<MyOrderListModel> orderList = [];


  MyOrderDataModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['datetime'];
    orderNumber = json['ordernumber'];
    totalPrice = json['totalprice'];
    timeAuthorization = json['timeauthorization'];

    if (json['List'] != null) {
      json['List'].forEach((element) {
        orderList.add(MyOrderListModel.fromJson(element));
      });
    }
  }
}

class MyOrderListModel {
  int? id;
  String? name;
  double? price;
  String? image;
  int? counter;

  MyOrderListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['Image'];
    price = json['price'];
    counter = json['counter'];
  }
}


