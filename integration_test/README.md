# Integration Tests — FutKO

Tests de integración que prueban el flujo completo de la app usando **Firebase Emulators**.

## Requisitos

- Firebase CLI instalado: `npm install -g firebase-tools`
- Java JDK (para los emuladores de Firebase)
- Flutter SDK configurado

## Configuración inicial

```bash
# Login en Firebase (solo primera vez)
firebase login

# Instalar emuladores (solo primera vez)
firebase init emulators
```

## Cómo correr los tests

### Opción 1: Todo en uno (recomendado)

```bash
# Terminal 1: Arrancar emuladores
firebase emulators:start

# Terminal 2: Correr integration tests
flutter test integration_test/
```

### Opción 2: Script automatizado

```bash
# En Linux/Mac
firebase emulators:exec "flutter test integration_test/"

# En Windows (PowerShell)
firebase emulators:exec "flutter test integration_test/"
```

### Opción 3: Con logs detallados

```bash
# Terminal 1
firebase emulators:start --debug

# Terminal 2
flutter test integration_test/ --verbose
```

## Qué prueban estos tests

El test `app_test.dart` verifica el flujo completo:

1. **Splash screen** → La app arranca correctamente
2. **Login** → Autenticación con email/password funciona
3. **Home** → Navegación post-login y carga de datos de usuario
4. **Partida rápida** → Inicio de partida y carga de preguntas
5. **Responder preguntas** → Interacción con opciones de respuesta
6. **Resultado** → Pantalla de resultados con puntuación
7. **Navegación** → Volver a Home desde resultados

## Estructura

```
integration_test/
├── app_test.dart              # Test principal del flujo completo
├── firebase_emulators.dart    # Helpers para conectar con emuladores
└── README.md                  # Este archivo
```

## Datos de prueba

El test crea automáticamente:
- **Usuario**: `test@futko.app` / `test1234`
- **Preguntas**: 10 preguntas de diferentes tipos (player, team, stadium, etc.)

## Troubleshooting

### "Emulator not running"
```bash
firebase emulators:start
```

### "Port already in use"
Los puertos por defecto son:
- Auth: `9099`
- Firestore: `8080`
- UI: `4000`

Puedes cambiarlos en `firebase.json` → sección `emulators`.

### "Test timeout"
Aumenta el timeout en el test:
```dart
testWidgets('...', (tester) async {
  // ...
}, timeout: const Timeout(Duration(minutes: 5)));
```

### "Questions not found"
Verifica que `seedTestQuestions()` en `firebase_emulators.dart` tenga las preguntas correctas.

## CI/CD

Para correr en GitHub Actions u otro CI:

```yaml
- name: Start Firebase Emulators
  run: firebase emulators:exec "flutter test integration_test/"
```

## Ver UI de emuladores

Mientras los emuladores están corriendo, abre:
- **http://localhost:4000** → Firebase Emulator UI
- Ahí puedes ver Auth, Firestore, y logs en tiempo real

## Limpiar datos

Para resetear los emuladores:
```bash
# Detener emuladores (Ctrl+C)
# Limpiar datos persistentes
rm -rf .firebase/
# Reiniciar
firebase emulators:start
```

## Más información

- [Firebase Emulators docs](https://firebase.google.com/docs/emulator-suite)
- [Flutter Integration Testing](https://docs.flutter.dev/testing/integration-tests)
