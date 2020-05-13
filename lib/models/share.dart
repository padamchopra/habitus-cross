import 'package:share/share.dart';

class share {
  //TODO: Put correct app link
  String appLink = 'https://github.com/padamchopra/habito';
  String _progress;

  String getProgressString(List daysCompleted) {
    return 'I have completed' + daysCompleted.toString();
  }

  void shareTheApp() {
    Share.share('Check out Habito App at $appLink');
  }

  void sharePersonalProgress(List daysCompleted) {
    _progress = getProgressString(daysCompleted);
    Share.share(_progress);
  }
}
