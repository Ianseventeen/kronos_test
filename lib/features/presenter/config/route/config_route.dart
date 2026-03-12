import 'package:go_router/go_router.dart';
import '../page/config_page.dart';
import '../../../../core/router/routes.dart';

final configRoute = GoRoute(
  path: Routes.settings,
  builder: (context, state) => const ConfigPage(),
);
