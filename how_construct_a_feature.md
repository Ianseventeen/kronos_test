# Como construir uma feature — Kronos

> Guia completo de ponta a ponta, usando a feature **Timer** como exemplo real.
> Siga as camadas de baixo para cima: **Data → Domain → Presenter**.

---

## Estrutura de pastas de uma feature

```
features/
├── data/
│   ├── model/
│   │   └── study_session_model.dart        ← DTO (JSON ↔ Entity)
│   ├── source/
│   │   └── study_session_local_source.dart ← acesso ao Sqflite
│   └── repositories/
│       └── study_session_repository_impl.dart ← implementa contrato do domain
│
├── domain/
│   ├── entities/
│   │   └── study_session.dart              ← entidade pura, sem imports externos
│   ├── repositories/
│   │   └── study_session_repository.dart   ← contrato (interface)
│   └── usecases/
│       ├── use_case.dart                   ← base abstrata
│       ├── start_study_session_use_case.dart
│       ├── finish_and_save_session_locally_use_case.dart
│       └── get_local_study_history_use_case.dart
│
└── presenter/
    └── timer/
        ├── components/                     ← widgets reutilizáveis da feature
        ├── di/
        │   └── timer_providers.dart        ← wiring de dependências
        ├── page/
        │   └── timer_page.dart             ← widget raiz da tela
        ├── route/
        │   └── timer_route.dart            ← GoRoute da tela
        └── vm/
            ├── timer_cubit.dart            ← lógica de estado
            └── timer_state.dart            ← estados imutáveis
```

---

## Passo 1 — Entidade (domain/entities)

A entidade não importa nada externo. É Dart puro.

```dart
// domain/entities/study_session.dart
final class StudySession {
  final String id;
  final String subject;
  final DateTime startTime;
  final DateTime? endTime;   // null = sessão em andamento
  final bool isSynced;
  final String? notes;

  const StudySession({ required this.id, required this.subject,
    required this.startTime, this.endTime,
    this.isSynced = false, this.notes });

  Duration? get duration => endTime?.difference(startTime);
  Duration get elapsed => (endTime ?? DateTime.now()).difference(startTime);
  bool get isCompleted => endTime != null;

  StudySession copyWith({...}) => StudySession(...);
}
```

---

## Passo 2 — Contrato do repositório (domain/repositories)

A camada de domínio só conhece esta interface — nunca a implementação.

```dart
// domain/repositories/study_session_repository.dart
abstract interface class StudySessionRepository {
  Future<void> saveSession(StudySession session);
  Future<List<StudySession>> getAllSessions();
  Future<List<StudySession>> getUnsyncedSessions();
  Future<void> markAsSynced(String sessionId);
}
```

---

## Passo 3 — Casos de uso (domain/usecases)

Cada use case tem **uma única responsabilidade** e implementa `UseCase<Output, Input>`.

```dart
// domain/usecases/use_case.dart
abstract interface class UseCase<Output, Input> {
  Future<Output> call(Input params);
}
final class NoParams { const NoParams(); }
```

```dart
// domain/usecases/start_study_session_use_case.dart
final class StartStudySessionUseCase
    implements UseCase<StudySession, StartSessionParams> {
  const StartStudySessionUseCase();

  @override
  Future<StudySession> call(StartSessionParams params) async {
    return StudySession(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      subject: params.subject,
      startTime: DateTime.now(),
    );
  }
}
```

```dart
// domain/usecases/finish_and_save_session_locally_use_case.dart
final class FinishAndSaveSessionLocallyUseCase
    implements UseCase<StudySession, FinishSessionParams> {
  final StudySessionRepository _repository;
  const FinishAndSaveSessionLocallyUseCase(this._repository);

  @override
  Future<StudySession> call(FinishSessionParams params) async {
    final completed = params.activeSession.copyWith(
      endTime: DateTime.now(),
      isSynced: false,
      notes: params.notes ?? params.activeSession.notes,
    );
    await _repository.saveSession(completed);
    return completed;
  }
}
```

---

## Passo 4 — Model / DTO (data/model)

O model converte entre o formato do banco (Map) e a entidade do domínio.
A entidade **nunca** conhece o model.

```dart
// data/model/study_session_model.dart
import '../../domain/entities/study_session.dart';

final class StudySessionModel {
  static const _tableColumns = 'id, subject, start_time, end_time, is_synced, notes';

  static StudySession fromMap(Map<String, dynamic> map) => StudySession(
    id:        map['id'] as String,
    subject:   map['subject'] as String,
    startTime: DateTime.parse(map['start_time'] as String),
    endTime:   map['end_time'] != null
               ? DateTime.parse(map['end_time'] as String)
               : null,
    isSynced:  (map['is_synced'] as int) == 1,
    notes:     map['notes'] as String?,
  );

  static Map<String, dynamic> toMap(StudySession s) => {
    'id':         s.id,
    'subject':    s.subject,
    'start_time': s.startTime.toIso8601String(),
    'end_time':   s.endTime?.toIso8601String(),
    'is_synced':  s.isSynced ? 1 : 0,
    'notes':      s.notes,
  };
}
```

---

## Passo 5 — Data source local (data/source)

Encapsula toda a lógica de acesso ao Sqflite. O repositório não toca no banco diretamente.

```dart
// data/source/study_session_local_source.dart
import 'package:sqflite/sqflite.dart';
import '../model/study_session_model.dart';
import '../../domain/entities/study_session.dart';

class StudySessionLocalSource {
  final Database _db;
  static const _table = 'study_sessions';

  const StudySessionLocalSource(this._db);

  Future<void> insert(StudySession session) =>
      _db.insert(_table, StudySessionModel.toMap(session),
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<List<StudySession>> fetchAll() async {
    final rows = await _db.query(_table, orderBy: 'start_time DESC');
    return rows.map(StudySessionModel.fromMap).toList();
  }

  Future<List<StudySession>> fetchUnsynced() async {
    final rows = await _db.query(_table,
        where: 'is_synced = ?', whereArgs: [0], orderBy: 'start_time DESC');
    return rows.map(StudySessionModel.fromMap).toList();
  }

  Future<void> markSynced(String id) =>
      _db.update(_table, {'is_synced': 1},
          where: 'id = ?', whereArgs: [id]);
}
```

---

## Passo 6 — Implementação do repositório (data/repositories)

Liga o contrato do domínio ao data source. É a única classe que lida com as duas camadas.

```dart
// data/repositories/study_session_repository_impl.dart
import '../../domain/entities/study_session.dart';
import '../../domain/repositories/study_session_repository.dart';
import '../source/study_session_local_source.dart';

final class StudySessionRepositoryImpl implements StudySessionRepository {
  final StudySessionLocalSource _source;
  const StudySessionRepositoryImpl(this._source);

  @override
  Future<void> saveSession(StudySession session) => _source.insert(session);

  @override
  Future<List<StudySession>> getAllSessions() => _source.fetchAll();

  @override
  Future<List<StudySession>> getUnsyncedSessions() => _source.fetchUnsynced();

  @override
  Future<void> markAsSynced(String sessionId) => _source.markSynced(sessionId);
}
```

---

## Passo 7 — Estado do Cubit (presenter/timer/vm)

Ver `bloc_cubit_helper.md` para detalhes completos.

```dart
// presenter/timer/vm/timer_state.dart
sealed class TimerState extends Equatable { ... }

final class TimerIdle    extends TimerState { ... }
final class TimerRunning extends TimerState {
  final StudySession session;
  final Duration elapsed;
  final bool isPaused;
  ...
}
final class TimerFinished extends TimerState { ... }
final class TimerError    extends TimerState { ... }
```

---

## Passo 8 — Cubit (presenter/timer/vm)

```dart
// presenter/timer/vm/timer_cubit.dart
class TimerCubit extends Cubit<TimerState> {
  final StartStudySessionUseCase _start;
  final FinishAndSaveSessionLocallyUseCase _finish;
  Timer? _ticker;

  // start() → emit(TimerRunning) + inicia Timer.periodic
  // togglePause() → para/retoma ticker
  // finish() → chama use case → emit(TimerFinished)
  // reset() → emit(TimerIdle)

  @override
  Future<void> close() { _ticker?.cancel(); return super.close(); }
}
```

---

## Passo 9 — Route (presenter/timer/route)

O `BlocProvider` é criado **na rota** para que o Cubit seja descartado quando
o utilizador sai da tela.

```dart
// presenter/timer/route/timer_route.dart
final timerRoute = GoRoute(
  path: Routes.timer,
  builder: (context, state) => BlocProvider(
    create: (_) => TimerCubit(
      startSession: sl<StartStudySessionUseCase>(),
      finishSession: sl<FinishAndSaveSessionLocallyUseCase>(),
    ),
    child: const TimerPage(),
  ),
);
```

Registrar no `router.dart`:
```dart
StatefulShellBranch(routes: [timerRoute]),
```

---

## Passo 10 — Page (presenter/timer/page)

```dart
// presenter/timer/page/timer_page.dart
class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimerCubit, TimerState>(
      // Efeito colateral: navegar para History ao terminar
      listenWhen: (_, curr) => curr is TimerFinished,
      listener: (context, state) => context.go(Routes.history),

      // UI: muda conforme o estado
      builder: (context, state) => switch (state) {
        TimerIdle()     => const _IdleBody(),
        TimerRunning()  => _RunningBody(state: state),
        TimerFinished() => const SizedBox.shrink(), // listener já navegou
        TimerError()    => _ErrorBody(message: state.message),
      },
    );
  }
}

class _IdleBody extends StatelessWidget {
  const _IdleBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => context.read<TimerCubit>().start('Flutter'),
        child: const Text('Start'),
      ),
    );
  }
}
```

---

## Passo 11 — DI global (core/di)

Registre todas as dependências no service locator (get_it) na inicialização:

```dart
// core/di/service_locator.dart
final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Infrastructure
  final db = await openDatabase('kronos.db', ...);
  sl.registerSingleton<Database>(db);

  // Sources
  sl.registerLazySingleton(() => StudySessionLocalSource(sl()));

  // Repositories
  sl.registerLazySingleton<StudySessionRepository>(
    () => StudySessionRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => const StartStudySessionUseCase());
  sl.registerLazySingleton(() => FinishAndSaveSessionLocallyUseCase(sl()));
  sl.registerLazySingleton(() => GetLocalStudyHistoryUseCase(sl()));
}
```

Em `main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const KronosApp());
}
```

---

## Checklist rápido para uma nova feature

```
[ ] 1. Entidade em domain/entities/
[ ] 2. Contrato em domain/repositories/
[ ] 3. Use case(s) em domain/usecases/
[ ] 4. Model (toMap/fromMap) em data/model/
[ ] 5. Source (acesso ao banco/API) em data/source/
[ ] 6. Repository impl em data/repositories/
[ ] 7. TimerState (sealed + Equatable) em presenter/<f>/vm/
[ ] 8. Cubit (métodos + emit) em presenter/<f>/vm/
[ ] 9. GoRoute em presenter/<f>/route/  →  registrar em router.dart
[  ] 10. Page (BlocConsumer/Builder) em presenter/<f>/page/
[ ] 11. Registrar dependências em core/di/service_locator.dart
```
