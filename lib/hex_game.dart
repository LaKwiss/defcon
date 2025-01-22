import 'dart:developer';

import 'package:defcon/hex.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:defcon/utils.dart';

class HexGame extends FlameGame
    with ScrollDetector, ScaleDetector, DragCallbacks {
  static const double HEX_SIZE = 50.0;
  static const int BOARD_SIZE = 8;

  late List<List<HexTile>> hexGrid;

  bool isDragging = false;

  HexGame({required Vector2 viewportResolution})
      : super(
          camera: CameraComponent.withFixedResolution(
            width: viewportResolution.x,
            height: viewportResolution.y,
          ),
        );

  static const zoomScrollSensitivity = 0.1;
  late double startZoom;

  @override
  Future<void> onLoad() async {
    // Zoom initial
    camera.viewfinder.zoom = 1.0;

    // Construction de la grille hexagonale
    hexGrid = List.generate(
      BOARD_SIZE,
      (row) => List.generate(
        BOARD_SIZE,
        (col) => HexTile(
          position: _calculateHexPosition(row, col),
          size: Vector2.all(HEX_SIZE),
          row: row,
          col: col,
        ),
      ),
    );

    // On ajoute toutes les tuiles à la world
    world.addAll(hexGrid.expand((row) => row));
  }

  /// Maintient le zoom dans la plage [0.5, 2.0]
  void clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(0.5, 2.0);
  }

  @override
  void onScroll(PointerScrollInfo info) {
    // Ajuste le zoom en fonction du défilement de la molette
    camera.viewfinder.zoom +=
        info.scrollDelta.global.y.sign * zoomScrollSensitivity;
    clampZoom();

    // On appelle éventuellement le comportement par défaut
    super.onScroll(info);
  }

  @override
  void onScaleStart(_) {
    // On enregistre la valeur de zoom de départ
    startZoom = camera.viewfinder.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    // On récupère le « pinch » (zoom) depuis info.scale
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      camera.viewfinder.zoom = startZoom * currentScale.y;
      clampZoom();
    }
  }

  /// Calcule la position d'une tuile (col, row) pour créer un layout hexagonal régulier
  Vector2 _calculateHexPosition(int row, int col) {
    // Largeur réelle d'un hexagone
    final hexWidth = HEX_SIZE * 2;
    // Hauteur réelle d'un hexagone (distance entre deux côtés parallèles)
    final hexHeight = HEX_SIZE * Utils.sqrt3;

    // Décalage horizontal entre deux colonnes successives (hex « pointy topped » décalé)
    final xStep = hexWidth * 0.75;

    // Largeur totale de la grille :
    //   - le premier hex occupe hexWidth en X,
    //   - chaque colonne additionnelle décale de xStep
    final totalWidth = hexWidth + (BOARD_SIZE - 1) * xStep;

    // Hauteur totale de la grille. Pour un arrangement "odd-r" (offset sur colonnes impaires),
    // on part sur BOARD_SIZE * hexHeight pour simplifier le centrage.
    final totalHeight = BOARD_SIZE * hexHeight;

    // Offsets pour centrer la grille au milieu de l'écran (ou de la surface de jeu)
    final offsetX = (size.x - totalWidth);
    final offsetY = (size.y - totalHeight);

    // Position de base
    final x = offsetX + col * xStep;
    // Si la colonne est impaire, on décale la tuile d'un demi-hex en Y (odd-r layout)
    final y = offsetY + row * hexHeight + (col.isOdd ? hexHeight / 2 : 0);

    return Vector2(x, y);
  }

  @override
  void onDragStart(DragStartEvent event) {
    log('DragStart');
    isDragging = true;
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    //if (!isDragging) return;

    // Déplacement de la caméra inversé, prenant en compte le zoom
    final delta = event.canvasDelta;
    camera.viewfinder.position += (-delta / camera.viewfinder.zoom);
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    isDragging = false;
    super.onDragEnd(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    isDragging = false;
    super.onDragCancel(event);
  }
}
