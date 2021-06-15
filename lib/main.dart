
import 'package:skyle_clone/utils/app_config.dart';
import 'package:skyle_clone/utils/app_theme.dart';
import 'package:skyle_clone/my_app.dart';

Future<void> main() async {
  /// Init dev config
  AppConfig(env: Env.dev(), theme: AppTheme.origin());
  await myMain();
}
