/// Contrato base para todos os casos de uso do Kronos.
///
/// [Output] — tipo retornado pelo caso de uso.
/// [Input]  — parâmetros necessários para a execução.
///
/// Uso para casos de uso sem parâmetros:
/// ```dart
/// class MyUseCase implements UseCase<MyOutput, NoParams> { ... }
/// ```
abstract interface class UseCase<Output, Input> {
  Future<Output> call(Input params);
}

/// Sentinela para casos de uso que não recebem parâmetros.
final class NoParams {
  const NoParams();
}
