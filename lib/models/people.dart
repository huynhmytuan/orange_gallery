class People {
  String trackingID;
  String? name;
  List<String?> faceLandMark;
  List<String>? listImageId;
  People({
    required this.trackingID,
    required this.faceLandMark,
    this.listImageId,
  });
  // void sendData() {
  //   //1.Lay db 3 nguoi

  //   //2. Convert 3 nguoi sang list face.
  //   List<List<String?>> faceDatas = [
  //     ["123", "341", null, '321'],
  //     ["123", "341", null, '321'],
  //     ["123", "341", null, '321'],
  //   ];
  //   //3. Send for model data faces.
  //   final map = {
  //     "id": "people1",
  //     "face_data":"adad",
  //     "crop":"dasd",
  //   }
  //   //4. For loop images. send model

  //   for (var image in images) {
  //     final result = await sendImageToModel(image);
  //     if(result not in db){
  //       insert()
  //     }
  //     else{
  //       db.getID(id).edit();
  //     }

  //   }
  //   // 4.1 -
  // }
}
