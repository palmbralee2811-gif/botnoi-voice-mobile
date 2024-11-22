import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';

class LineService {
  final LineLoginProvider lineLoginProvider;

  LineService(this.lineLoginProvider);

  Future<String?> getUserIdWithLine() async {
    if (lineLoginProvider.isLoggedIn) {
      String? userId = lineLoginProvider.getIdTokenRaw;
      return userId;
    }
    return null;
  }
}
