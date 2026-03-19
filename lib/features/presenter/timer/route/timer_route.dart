import 'package:go_router/go_router.dart';
import '../page/timer_page.dart';
import '../../../../core/router/routes.dart';

final timerRoute = GoRoute(
  path: Routes.timer,
  builder: (context, state) => const TimerPage(),
);
