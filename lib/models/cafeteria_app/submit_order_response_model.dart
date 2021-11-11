
class SubmitOrderResponseModel {
  SubmitOrderResponseDataModel? data;

  SubmitOrderResponseModel.fromJson(Map<String, dynamic> json) {
    data = SubmitOrderResponseDataModel.fromJson(json['Order'][0]);
  }
}

class SubmitOrderResponseDataModel {
  String? orderValid;
  String? errMsg;
  int? orderNumber;

  SubmitOrderResponseDataModel.fromJson(Map<String, dynamic> json) {
    orderValid = json['OrderValid'];
    errMsg = json['errMsg'];
    orderNumber = json['OrderNum'];
  }
}
