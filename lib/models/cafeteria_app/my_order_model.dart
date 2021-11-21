class MyOrderModel {
  MyOrderDataModel? data;

  MyOrderModel({this.data});
  MyOrderModel.fromJson(Map<String, dynamic> json) {
    data = MyOrderDataModel.fromJson(json["MyOrder"][0]);
  }
}

class MyOrderDataModel {
  String? dateTime;
  int? orderNumber;
  double? totalPrice;
  bool? timeAuthorization;
  List<MyOrderListModel> orderList=[];

  MyOrderDataModel({
    this.dateTime,
    this.orderNumber,
    this.totalPrice,
    this.timeAuthorization,
    required this.orderList,
  });
  // {
  //   this.dateTime = dateTime;
  //   this.totalPrice = totalPrice;
  //   this.timeAuthorization = timeAuthorization;
  //   this.orderList = orderList;
  // }

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
  MyOrderListModel({
    this.id,
    this.name,
    this.price,
    this.image,
    this.counter,
  });
  MyOrderListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['Image'];
    price = json['unitprice'];
    counter = json['counter'];
  }
}
