class HistoryModel {
  List<HistoryDataModel> data = [];

  HistoryModel.fromJson(Map<String, dynamic> json, String historyType) {
    json[historyType].forEach((element) {
      data.add(HistoryDataModel.fromJson(element));
    });
  }
}

class HistoryDataModel {
  String? dateTime;
  double? price;
  String? payType;
  int? orderNumber;
  List<HistoryOrdersModel> ordersList = [];

  HistoryDataModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['datetime'];
    price = json['price'];
    payType = json['payType'];
    orderNumber = json['OrderNumber'];

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
  bool? orderStatus;

  HistoryOrdersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    counter = json['counter'];
    orderStatus = json['OrderStatus'];
  }
}
