class HistoryModel {
  HistoryDataModel? data;

  HistoryModel.fromJson(Map<String, dynamic> json,String historyType) {
    data = HistoryDataModel.fromJson(json[historyType][0]);
  }
}

class HistoryDataModel {
String? dateTime;
String? price;
String? payType;
List<HistoryOrdersModel> ordersList = [];


  HistoryDataModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['datetime'];
    price = json['price'];
    payType = json['payType'];

    if (json['List'] != null) {
      json['List'].forEach((element) {
        ordersList.add(HistoryOrdersModel.fromJson(element));
      });
    }
  }
}

class HistoryOrdersModel {
  int? id;
  String? name;
  double? price;
  int? counter;
  String? orderStatus;

  HistoryOrdersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    counter = json['counter'];
    orderStatus = json['OrderStatus'];
  }
}


