# Tendencias de Animaciones en Flutter 2025

## 🔥 Paquetes y Tecnologías Líderes

### 1. **flutter_animate** (Más Popular)
El paquete más usado en 2025 para animaciones declarativas simples.

```dart
// Animaciones encadenadas de forma declarativa
Text('Hello')
  .animate()
  .fade(duration: 500.ms)
  .scale(delay: 200.ms)
  .slide(curve: Curves.easeOut);
```

**Ventajas:**
- Sintaxis muy limpia y legible
- No requiere StatefulWidget
- Animaciones encadenables
- Efectos predefinidos (shimmer, shake, etc.)

### 2. **Lottie** (Animaciones complejas)
Para animaciones complejas exportadas desde After Effects.

```dart
Lottie.asset(
  'assets/animation.json',
  repeat: true,
  animate: true,
  fit: BoxFit.contain,
)
```

**Uso actual en FutKO:**
- Animaciones de logros desbloqueados
- Trofeos, fuego, coronas animadas
- Fallback a emojis si falla la carga

### 3. **Rive** (Animaciones interactivas)
Para animaciones que responden a interacciones del usuario.

```dart
RiveAnimation.asset(
  'assets/character.riv',
  fit: BoxFit.contain,
  onInit: (artboard) {
    // Controlar animación programáticamente
  },
)
```

### 4. **shimmer** (Estados de carga)
Efecto brillante para indicar carga de contenido.

```dart
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(width: 200, height: 100),
)
```

## 🎯 Patrones de Animación Populares

### 1. **Micro-interacciones**
Pequeñas animaciones de feedback que mejoran la UX.

```dart
// Botón con animación de escala
class AnimatedButton extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: Duration(milliseconds: 100),
        child: Container(...),
      ),
    );
  }
}
```

### 2. **Page Transitions Personalizadas**
Transiciones únicas entre pantallas.

```dart
// En go_router
GoRoute(
  path: '/game',
  pageBuilder: (context, state) => CustomTransitionPage(
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    child: GameScreen(),
  ),
)
```

### 3. **Skeleton Loaders**
Marcadores de posición animados mientras carga contenido.

```dart
Skeletonizer(
  enabled: isLoading,
  child: Card(
    child: ListTile(
      title: Text('Título'),
      subtitle: Text('Subtítulo'),
    ),
  ),
)
```

### 4. **Hero Animations**
Transiciones fluidas de elementos entre pantallas.

```dart
// Pantalla A
Hero(
  tag: 'avatar-${user.id}',
  child: CircleAvatar(backgroundImage: ...),
)

// Pantalla B
Hero(
  tag: 'avatar-${user.id}',
  child: CircleAvatar(backgroundImage: ..., radius: 50),
)
```

## 🎁 Widgets Nativos de Animación

### ImplicitlyAnimatedWidget
Para animaciones automáticas cuando cambia un valor.

```dart
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  color: isSelected ? Colors.blue : Colors.grey,
  transform: isSelected ? Matrix4.translationValues(10, 0, 0) : Matrix4.identity(),
)
```

### AnimatedBuilder
Control total sobre la animación.

```dart
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.rotate(
      angle: _controller.value * 2 * pi,
      child: child,
    );
  },
  child: Icon(Icons.refresh),
)
```

## 🎮 Implementaciones en FutKO

### Confetti Celebration
```dart
// assets/widgets/common/confetti_widget.dart
ConfettiCelebration(
  isActive: showConfetti,
  particleCount: 50,
  onComplete: () => setState(() => showConfetti = false),
)
```

### Achievement Unlock con Sonido
```dart
// Sistema completo de feedback
Future<void> unlockAchievement(Achievement achievement) async {
  // 1. Reproducir sonido
  await audioService.playAchievementUnlocked();
  
  // 2. Mostrar toast animado
  showAchievementToast(achievement);
  
  // 3. Lottie animation
  setState(() => showLottieAnimation = true);
}
```

## 📈 Métricas de Éxito

Las animaciones efectivas deben ser:
- **Rápidas:** 200-500ms para micro-interacciones
- **Propósito:** Guiar al usuario, no distraer
- **Consistentes:** Mismo easing y duración en toda la app
- **Opcionales:** Respetar `prefers-reduced-motion`

## 🚀 Paquetes Recomendados para FutKO

| Paquete | Uso | Prioridad |
|---------|-----|-----------|
| `flutter_animate` | Animaciones de UI generales | Alta |
| `lottie` | Logros y celebraciones | Ya implementado |
| `shimmer` | Estados de carga | Media |
| `rive` | Personajes animados | Baja |
| `confetti` | Celebraciones | Ya implementado |

## 📚 Recursos

- [flutter_animate docs](https://pub.dev/packages/flutter_animate)
- [LottieFiles](https://lottiefiles.com/) - Animaciones gratuitas
- [Rive Community](https://rive.app/community/)
- [Material Motion Guidelines](https://m3.material.io/styles/motion/overview)
