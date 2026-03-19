# GoRouter Helper — Kronos

> Kronos usa **go_router** com `StatefulShellRoute.indexedStack` para manter
> o estado de cada tab da bottom nav bar de forma independente.

---

## 1. Estrutura de arquivos

```
lib/
└── core/
    └── router/
        ├── routes.dart      ← constantes de path
        ├── app_shell.dart   ← bottom nav + StatefulNavigationShell
        └── router.dart      ← AppRouter.router (instância global)

features/presenter/<feature>/
└── route/
    └── <feature>_route.dart  ← GoRoute isolado da feature
```

---

## 2. `routes.dart` — constantes de path

```dart
abstract final class Routes {
  static const String home     = '/home';
  static const String timer    = '/timer';
  static const String history  = '/history';
  static const String settings = '/settings';

  // Sub-rotas: prefixe com a rota pai
  // static const String sessionDetail = '/history/detail';
}
```

**Regra:** nunca escreva strings de path inline no código — use sempre `Routes.x`.

---

## 3. Route file da feature

Cada feature tem o seu próprio `GoRoute`. Isso mantém o `router.dart` limpo e
cada feature autocontida.

```dart
// features/presenter/timer/route/timer_route.dart
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../page/timer_page.dart';
import '../vm/timer_cubit.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/di/service_locator.dart';

final timerRoute = GoRoute(
  path: Routes.timer,
  builder: (context, state) => BlocProvider(
    create: (_) => TimerCubit(
      startSession: sl(),
      finishSession: sl(),
    ),
    child: const TimerPage(),
  ),
);
```

### Sub-rota (push sobre a mesma branch)

```dart
final historyRoute = GoRoute(
  path: Routes.history,
  builder: (context, state) => const HistoryPage(),
  routes: [
    GoRoute(
      path: 'detail/:id',           // path RELATIVO ao pai → /history/detail/:id
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return SessionDetailPage(sessionId: id);
      },
    ),
  ],
);
```

---

## 4. `router.dart` — montagem global

```dart
// core/router/router.dart
abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.home,
    debugLogDiagnostics: true,        // remover em release
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [homeRoute]),
          StatefulShellBranch(routes: [timerRoute]),
          StatefulShellBranch(routes: [historyRoute]),
          StatefulShellBranch(routes: [configRoute]),
        ],
      ),
    ],
  );
}
```

`StatefulShellRoute.indexedStack` mantém a pilha de cada branch viva —
ao trocar de tab e voltar, a branch está exatamente onde estava.

---

## 5. `app_shell.dart` — bottom nav

```dart
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // Re-clicar na tab ativa volta para a rota raiz da branch
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onTap,
          destinations: const [ /* ... */ ],
        ),
      );
}
```

---

## 6. Navegação — referência rápida

| Operação | Código |
|---|---|
| Ir para uma rota (substitui histórico) | `context.go(Routes.timer)` |
| Empurrar rota sobre a pilha atual | `context.push(Routes.timer)` |
| Voltar | `context.pop()` |
| Voltar com resultado | `context.pop(result)` |
| Verificar se pode voltar | `context.canPop()` |
| Passar parâmetro de path | `context.go('/history/detail/$id')` |
| Ler parâmetro de path | `state.pathParameters['id']` |
| Passar query param | `context.go('/history?filter=unsynced')` |
| Ler query param | `state.uri.queryParameters['filter']` |
| Passar objeto (extra) | `context.go(Routes.timer, extra: myObject)` |
| Ler objeto extra | `state.extra as MyObject` |

### `go` vs `push`

- **`go`** — navega substituindo o histórico da branch. Use para tabs e fluxos
  lineares onde o utilizador não precisa de voltar.
- **`push`** — empurra a rota sobre a pilha atual. Use para detalhes,
  modais de página completa, fluxos temporários.

---

## 7. Redirecionamento (guards)

```dart
GoRouter(
  redirect: (context, state) {
    final isAuthenticated = sl<AuthRepository>().isLoggedIn;
    final goingToLogin = state.matchedLocation == '/login';

    if (!isAuthenticated && !goingToLogin) return '/login';
    if (isAuthenticated && goingToLogin) return Routes.home;
    return null; // sem redirecionamento
  },
  routes: [...],
)
```

---

## 8. Adicionar uma nova tela — checklist

```
1. Adicionar a constante em routes.dart
2. Criar o page widget em <feature>/page/<name>_page.dart
3. Criar o GoRoute em <feature>/route/<name>_route.dart
4. Registrar o GoRoute no branch correto em router.dart
   (ou como sub-rota de um GoRoute existente)
```
