class EditOrderResponseModel {
  EditOrderResponseDataModel? data;

  EditOrderResponseModel.fromJson(Map<String, dynamic> json) {
    data = EditOrderResponseDataModel.fromJson(json['UpdateOrder'][0]);
  }
}

class EditOrderResponseDataModel {
  String? updateValid;
  String? errorMessage;


  EditOrderResponseDataModel.fromJson(Map<String, dynamic> json) {
    updateValid = json['UpdaterValid'];
    errorMessage = json['errMsg'];
  }
}
