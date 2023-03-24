import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/services/firebase/fb_handeler.dart';

class UserViewModel extends ChangeNotifier {
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  Future<void> getCurrentUser({required String id}) async {
    final userDetails = await FbHandler.getUserById(id: id);
    _userModel = userDetails;
    notifyListeners();
  }
}
