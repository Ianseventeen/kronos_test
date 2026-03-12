# Kronos — Descrição Detalhada dos Casos de Uso

> Documento de referência para os casos de uso da camada de domínio do Kronos. Cada caso de uso segue o padrão: identificador, nome, ator, pré-condições, fluxo principal, fluxos alternativos, pós-condições e exceções.

---

## Visão Geral

O **Kronos** é um app Flutter *offline-first* para rastreamento de sessões de estudo. A camada de domínio é completamente independente de bibliotecas externas; ela expõe apenas entidades puras e contratos de repositório. Os casos de uso orquestram essas entidades para satisfazer os objetivos do usuário.

### Entidade Central: `StudySession`

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `String` | Identificador único gerado com `microsecondsSinceEpoch`. |
| `subject` | `String` | Assunto/área de estudo (ex: `"Flutter"`, `"Inglês"`). |
| `startTime` | `DateTime` | Instante exato em que a sessão foi iniciada. |
| `endTime` | `DateTime?` | Instante de término; `null` enquanto estiver em andamento. |
| `isSynced` | `bool` | `false` ao salvar localmente; `true` após sincronização com a API. |
| `notes` | `String?` | Anotação livre do usuário sobre a sessão. |

Propriedades calculadas:
- `duration` → `Duration?` — retorna `null` se a sessão ainda está em andamento.
- `elapsed` → `Duration` — tempo decorrido até agora; usa `DateTime.now()` se `endTime` for nulo.
- `isCompleted` → `bool` — `true` quando `endTime != null`.

---

## UC-01 — Iniciar Sessão de Estudo

**Caso de Uso:** `StartStudySessionUseCase`  
**Arquivo:** `lib/features/domain/usecases/start_study_session_use_case.dart`

### Ator
Usuário do aplicativo (via `TimerPage`).

### Descrição
Permite ao usuário iniciar o cronômetro para uma nova sessão de estudo, informando obrigatoriamente o assunto e, opcionalmente, uma anotação inicial. A sessão é criada inteiramente em memória e mantida no estado gerenciado pelo Cubit (`TimerCubit`); **nenhum dado é persistido em banco neste momento**.

### Pré-condições
- O app está aberto na aba `Timer` (`/timer`).
- Não existe nenhuma sessão ativa em andamento no estado do Cubit (o campo `activeSession` é `null`).
- O usuário preencheu ao menos o campo `subject`.

### Parâmetros de Entrada — `StartSessionParams`

| Parâmetro | Obrigatório | Descrição |
|---|---|---|
| `subject` | Sim | Nome do assunto/matéria que será estudado. |
| `notes` | Não | Anotação inicial; pode ser complementada na finalização. |

### Fluxo Principal

1. O usuário acessa a aba **Timer**.
2. O usuário informa o assunto no campo de texto.
3. O usuário aciona o botão **"Iniciar"**.
4. O `TimerCubit` invoca `StartStudySessionUseCase(StartSessionParams(subject: subject))`.
5. O caso de uso gera um ID único baseado em `DateTime.now().microsecondsSinceEpoch`.
6. Uma instância de `StudySession` é criada com:
   - `startTime = DateTime.now()`
   - `endTime = null`
   - `isSynced = false`
7. A sessão criada é retornada ao Cubit.
8. O `TimerCubit` atualiza o estado para `TimerRunning(session)`.
9. A UI exibe o cronômetro em execução, mostrando `session.elapsed` atualizado a cada segundo.

### Fluxos Alternativos

**FA-01 — Anotação inicial fornecida:**  
No passo 2, o usuário também preenche o campo `notes`. O valor é repassado via `StartSessionParams(subject: subject, notes: notes)` e incluído na sessão criada.

**FA-02 — Campo `subject` em branco:**  
O botão **"Iniciar"** permanece desabilitado ou a UI exibe uma mensagem de validação. O caso de uso não é chamado.

### Pós-condições
- Uma instância de `StudySession` com `endTime = null` existe no estado do `TimerCubit`.
- O cronômetro está em execução.
- Nenhuma escrita ocorreu no banco de dados local.

### Exceções / Tratamento de Erros
Nenhuma exceção esperada — operação puramente em memória, sem dependências externas.

---

## UC-02 — Finalizar e Salvar Sessão Localmente

**Caso de Uso:** `FinishAndSaveSessionLocallyUseCase`  
**Arquivo:** `lib/features/domain/usecases/finish_and_save_session_locally_use_case.dart`

### Ator
Usuário do aplicativo (via `TimerPage`).

### Descrição
Finaliza a sessão ativa, registra o horário de término e persiste a sessão completa no banco de dados local (SQLite via Sqflite). A sessão é salva com `isSynced = false`, sinalizando que ainda precisa ser enviada à API remota (GitHub Gists). Essa separação garante o comportamento *offline-first*: o dado é salvo com segurança localmente antes de qualquer tentativa de sincronização.

### Pré-condições
- Existe uma sessão ativa no estado do `TimerCubit` (`activeSession != null` e `isCompleted == false`).
- O `StudySessionRepository` está registrado e operacional (banco de dados inicializado via `DatabaseService`).

### Parâmetros de Entrada — `FinishSessionParams`

| Parâmetro | Obrigatório | Descrição |
|---|---|---|
| `activeSession` | Sim | Instância da sessão em andamento retornada por `StartStudySessionUseCase`. |
| `notes` | Não | Anotação final; substitui a anotação inicial se fornecida. |

### Fluxo Principal

1. O usuário aciona o botão **"Finalizar"** na `TimerPage`.
2. O `TimerCubit` invoca `FinishAndSaveSessionLocallyUseCase(FinishSessionParams(activeSession: session))`.
3. O caso de uso chama `activeSession.copyWith(endTime: DateTime.now(), isSynced: false)`.
4. Se `notes` for fornecido, substitui o campo `notes` da sessão; caso contrário, mantém as notas originais.
5. O caso de uso invoca `_repository.saveSession(completedSession)`.
6. O `StudySessionRepository` (implementação Sqflite) insere o registro na tabela `study_sessions` com `is_synced = 0`.
7. A sessão concluída é retornada ao `TimerCubit`.
8. O `TimerCubit` atualiza o estado para `TimerIdle` (sem sessão ativa).
9. A UI exibe a confirmação de sessão salva e redefine o cronômetro para zero.

### Fluxos Alternativos

**FA-01 — Anotação final fornecida:**  
O usuário preenche o campo de notas antes de acionar "Finalizar". `FinishSessionParams(activeSession: session, notes: finalNotes)` é passado; as notas finais substituem as iniciais na sessão persistida.

**FA-02 — Erro de escrita no banco:**  
O repositório lança uma exceção durante `saveSession`. O `TimerCubit` captura o erro e emite o estado `TimerError` com a mensagem apropriada. A sessão ativa é mantida no estado para nova tentativa.

### Pós-condições
- A sessão de estudo está persistida na tabela `study_sessions` do SQLite com `is_synced = 0`.
- O estado do `TimerCubit` não possui mais sessão ativa.
- O histórico local está atualizado (nova linha disponível para `GetLocalStudyHistoryUseCase`).

### Exceções

| Exceção | Causa | Ação esperada |
|---|---|---|
| Falha de I/O no SQLite | Disco cheio ou banco corrompido | Emitir `TimerError`; manter sessão no estado para nova tentativa |

### Esquema de Persistência (tabela `study_sessions`)

```sql
CREATE TABLE study_sessions (
  id        TEXT PRIMARY KEY,
  subject   TEXT NOT NULL,
  start_time TEXT NOT NULL,   -- ISO-8601
  end_time   TEXT NOT NULL,   -- ISO-8601
  is_synced  INTEGER NOT NULL DEFAULT 0,  -- 0 = false, 1 = true
  notes      TEXT
);
```

---

## UC-03 — Consultar Histórico Local de Sessões

**Caso de Uso:** `GetLocalStudyHistoryUseCase`  
**Arquivo:** `lib/features/domain/usecases/get_local_study_history_use_case.dart`

### Ator
Usuário do aplicativo (via `HistoryPage`).

### Descrição
Recupera todas as sessões de estudo já concluídas e persistidas no banco de dados local, ordenadas da mais recente para a mais antiga. Funciona 100% *offline* — nenhuma conexão de rede é necessária. É o ponto de entrada para o usuário visualizar seu progresso histórico de estudos.

### Pré-condições
- O banco de dados SQLite está inicializado (via `DatabaseService` registrado no `GetIt`).
- O `StudySessionRepository` está corretamente registrado e injetado no caso de uso.

### Parâmetros de Entrada
`NoParams` — nenhum parâmetro necessário.

### Fluxo Principal

1. O usuário navega para a aba **History** (`/history`).
2. O `HistoryCubit` emite o estado `HistoryLoading` e invoca `GetLocalStudyHistoryUseCase(const NoParams())`.
3. O caso de uso delega para `_repository.getAllSessions()`.
4. O repositório executa a query:
   ```sql
   SELECT * FROM study_sessions ORDER BY start_time DESC;
   ```
5. Os registros são deserializados em uma lista de `StudySession`.
6. A lista é retornada ao `HistoryCubit`.
7. O Cubit emite `HistoryLoaded(sessions)`.
8. A `HistoryPage` renderiza a lista de sessões com:
   - Nome do assunto (`subject`)
   - Data e hora de início (`startTime`)
   - Duração calculada (`duration`)
   - Indicador de sincronização (`isSynced`)
   - Anotações, se presentes (`notes`)

### Fluxos Alternativos

**FA-01 — Histórico vazio:**  
O banco não contém nenhuma sessão. O repositório retorna `[]`. O Cubit emite `HistoryLoaded([])`. A UI exibe o estado vazio com uma mensagem de encorajamento (ex: *"Nenhuma sessão registrada ainda. Inicie sua primeira sessão!"*).

**FA-02 — Erro de leitura no banco:**  
O repositório lança uma exceção. O Cubit emite `HistoryError` com a mensagem de erro. A UI exibe uma mensagem de falha com opção de tentar novamente.

### Pós-condições
- A lista de sessões é exibida na `HistoryPage`.
- Nenhuma escrita ocorre no banco durante esta operação.

### Exceções

| Exceção | Causa | Ação esperada |
|---|---|---|
| Falha de I/O no SQLite | Banco corrompido ou inacessível | Emitir `HistoryError`; exibir botão de retry |

---

## UC-04 — Sincronizar Sessões com a API Remota *(planejado)*

**Caso de Uso:** `SyncSessionsWithRemoteUseCase`  
**Status:** Planejado — contrato de repositório já preparado (`getUnsyncedSessions`, `markAsSynced`).

### Ator
Sistema (executado automaticamente ao detectar conectividade, ou manualmente via botão na `SettingsPage`/`HistoryPage`).

### Descrição
Busca todas as sessões locais com `isSynced = false`, serializa-as e as envia para a API do **GitHub Gists** via `DioWrapper`. Após cada envio bem-sucedido, marca a sessão como sincronizada no banco local (`is_synced = 1`). Implementa a estratégia *offline-first*: o app funciona sem rede e sincroniza quando a conexão estiver disponível.

### Pré-condições
- O dispositivo está conectado à internet.
- O Personal Access Token (PAT) do GitHub está armazenado de forma segura no `FlutterSecureStorage` (chave `github_token`).
- O PAT tem permissão de escrita em Gists (`gist` scope).
- Existem sessões com `isSynced = false` no banco local.

### Parâmetros de Entrada
`NoParams` — nenhum parâmetro necessário.

### Fluxo Principal

1. O caso de uso invoca `_repository.getUnsyncedSessions()`.
2. O repositório executa:
   ```sql
   SELECT * FROM study_sessions WHERE is_synced = 0;
   ```
3. Para cada sessão retornada:
   a. Serializa a sessão para JSON.
   b. Invoca `DioWrapper.post('gists', data: gistPayload)` para criar um novo Gist **ou** `DioWrapper.patch('gists/{id}', data: gistPayload)` para atualizar um Gist existente do dia/período.
   c. Se a requisição for bem-sucedida (HTTP 200/201), invoca `_repository.markAsSynced(session.id)`.
   d. O repositório executa:
      ```sql
      UPDATE study_sessions SET is_synced = 1 WHERE id = ?;
      ```
4. Retorna o número de sessões sincronizadas com sucesso.
5. A UI exibe feedback de sucesso (ex: snackbar *"X sessões sincronizadas"*).

### Fluxos Alternativos

**FA-01 — Nenhuma sessão pendente:**  
`getUnsyncedSessions()` retorna `[]`. O caso de uso retorna `0` sem nenhuma requisição de rede.

**FA-02 — Falha parcial (erro em uma sessão):**  
Se uma sessão falhar (ex: timeout), o loop continua para as demais. As sessões sincronizadas com sucesso são marcadas; as que falharam permanecem com `isSynced = false` para nova tentativa posterior.

**FA-03 — Token inválido ou expirado (HTTP 401):**  
O `ApiInterceptor` loga o erro. O caso de uso lança `ApiException(statusCode: 401)`. A UI exibe mensagem orientando o usuário a atualizar o PAT nas configurações.

**FA-04 — Rate limit atingido (HTTP 403/429):**  
O `ApiInterceptor` loga o aviso. O caso de uso interrompe o loop e agenda nova tentativa com back-off exponencial.

**FA-05 — Sem conexão:**  
`DioException` com tipo `connectionError`. O caso de uso é abortado silenciosamente; as sessões permanecem como `isSynced = false`.

### Pós-condições
- Todas as sessões enviadas com sucesso possuem `isSynced = true` no banco local.
- Os Gists correspondentes foram criados/atualizados na conta GitHub do usuário.
- Sessões com falha permanecem `isSynced = false` para re-tentativa futura.

### Exceções

| Exceção | Código HTTP | Ação esperada |
|---|---|---|
| Token inválido | 401 | Notificar usuário; redirecionar para configurações |
| Sem permissão | 403 | Notificar usuário; verificar escopo do PAT |
| Rate limit | 429 | Back-off exponencial; retry automático |
| Timeout / sem rede | — | Abortar silenciosamente; retry na próxima detecção de conectividade |

---

## Mapa de Dependências entre Casos de Uso

```
[UC-01] StartStudySessionUseCase
    │  (retorna StudySession em memória)
    ▼
[UC-02] FinishAndSaveSessionLocallyUseCase
    │  (persiste no SQLite com isSynced=false)
    ▼
[UC-03] GetLocalStudyHistoryUseCase        [UC-04] SyncSessionsWithRemoteUseCase
    │  (lê do SQLite)                           │  (lê isSynced=false, envia ao GitHub,
    │                                           │   marca isSynced=true)
    ▼                                           ▼
  HistoryPage                            GitHub Gists API
```

---

## Contrato do Repositório — `StudySessionRepository`

O domínio depende exclusivamente desta interface. A implementação concreta (Sqflite) reside em `lib/features/data/repositories/`.

| Método | Retorno | Descrição |
|---|---|---|
| `saveSession(StudySession)` | `Future<void>` | Persiste uma sessão concluída com `isSynced = false`. |
| `getAllSessions()` | `Future<List<StudySession>>` | Retorna todas as sessões em ordem decrescente de `startTime`. |
| `getUnsyncedSessions()` | `Future<List<StudySession>>` | Retorna apenas sessões com `isSynced = false`. |
| `markAsSynced(String id)` | `Future<void>` | Atualiza `isSynced = true` após sincronização bem-sucedida. |

---

## Convenções de Implementação

- **Contrato base:** todos os casos de uso implementam `UseCase<Output, Input>`.
- **Sem parâmetros:** usar `NoParams` como tipo de entrada (`UseCase<Output, NoParams>`).
- **Imutabilidade:** `StudySession` é uma `final class`; mutações usam `copyWith`.
- **ID de sessão:** gerado com `microsecondsSinceEpoch` na ausência do pacote `uuid`. Para produção, substituir por `Uuid().v4()`.
- **Armazenamento seguro:** o PAT do GitHub é lido/escrito exclusivamente via `FlutterSecureStorage` — nunca hardcoded em código-fonte.
- **Separação de camadas:** casos de uso nunca importam pacotes de UI (`flutter/material.dart`), persistência (`sqflite`) ou rede (`dio`) — apenas entidades e contratos do próprio domínio.
