import 'package:shared_preferences/shared_preferences.dart';

class SaveService{
  Future<int> getSelectedButton() async{
    final prev = await SharedPreferences.getInstance();
    return prev.getInt('selectedButton') ?? 1;
  }

  void saveSelectedButton(int number) async{
    final prev = await SharedPreferences.getInstance();
    await prev.setInt('selectedButton', number);
  }
}