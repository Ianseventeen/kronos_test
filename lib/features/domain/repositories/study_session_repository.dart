import '../entities/study_session.dart';

/// Contrato do repositório de sessões de estudo.
///
/// A camada de domínio depende **apenas** desta interface.
/// A implementação concreta (Sqflite) vive em `features/data/repositories/`.
abstract interface class StudySessionRepository {
  /// Persiste uma sessão concluída no banco local com [isSynced] = false.
  Future<void> saveSession(StudySession session);

  /// Retorna todas as sessões armazenadas localmente, em ordem decrescente de
  /// data de início.
  Future<List<StudySession>> getAllSessions();

  /// Retorna apenas as sessões que ainda não foram sincronizadas com a API
  /// remota (GitHub Gists), ou seja, onde [isSynced] == false.
  Future<List<StudySession>> getUnsyncedSessions();

  /// Marca uma sessão como sincronizada após envio bem-sucedido para a API.
  Future<void> markAsSynced(String sessionId);
}
