# Re-sembrar las preguntas en Firestore

Las preguntas viven en el **código** (`QuestionSeederService` + `lib/data/questions/*`).
Hay **1.130 preguntas coherentes** por siembra (de un pool de ~1.802 variantes),
verificadas por `test/question_review_test.dart`.

La regla de Firestore `questions` se queda **siempre** en `allow write: if false;`
(los clientes nunca escriben preguntas). La siembra se hace con permisos de
admin, que ignoran las reglas.

---

## Método recomendado — Admin SDK (sin tocar reglas, un comando)

**Setup (una sola vez):**
1. Firebase Console → ⚙️ Configuración del proyecto → **Cuentas de servicio** →
   **Generar nueva clave privada**. Guarda el JSON como
   `scripts/serviceAccount.json` (ya está en `.gitignore`, no se commitea).
2. Instala dependencias:
   ```bash
   cd scripts && npm install
   ```

**Cada vez que cambies/añadas preguntas:**
```bash
cd scripts && npm run seed
```
Eso (1) regenera `questions_seed.json` desde los generadores Dart y (2) borra las
antiguas y siembra las nuevas. **No se tocan reglas ni se despliega nada.**

> Si solo quieres subir el JSON ya generado: `cd scripts && npm run seed:upload`

---

## Verificar coherencia (opcional, recomendado antes de sembrar)
```bash
flutter test test/question_review_test.dart
```
0 ambiguas / 0 filtradas / 0 MC con varios correctos / 0 opciones inválidas.

---

## Alternativas (no recomendadas — requieren abrir la regla temporalmente)

<details>
<summary>Seeder en la app o subidor REST</summary>

Solo si NO quieres usar una service account. Requieren cambiar
`allow write: if false;` → `if request.auth != null;`, desplegar
(`firebase deploy --only firestore:rules`), sembrar, y volver a cerrar.

- App: `flutter run -t lib/main_seed.dart -d <device>` → botón “Sembrar Preguntas”.
- REST: `FUTKO_EMAIL=… FUTKO_PASSWORD=… node scripts/upload_questions.js`
</details>
