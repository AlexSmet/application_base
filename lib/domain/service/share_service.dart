import 'package:share_plus/share_plus.dart';

abstract final class ShareService {
  // Optimize(Alex): добавить другие параметры и возвращаемый результат
  static Future<void> share({required String text}) =>
      SharePlus.instance.share(ShareParams(text: text));
}
