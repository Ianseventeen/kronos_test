import 'package:go_router/go_router.dart';
import '../page/home_page.dart';
import '../../../../core/router/routes.dart';

final homeRoute = GoRoute(
  path: Routes.home,
  builder: (context, state) => const HomePage(),
);
