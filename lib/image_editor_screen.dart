import 'package:flutter/material.dart';
import 'package:image_sketcher/image_sketcher.dart';
import 'package:whatsapp_status/app_colors.dart';
import 'package:whatsapp_status/action_button.dart';
import 'package:whatsapp_status/color_slider.dart';
import 'package:whatsapp_status/line_weight_selector.dart';

class ImageEditorScreen extends StatefulWidget {
  const ImageEditorScreen({super.key});

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  final _imageKey = GlobalKey<ImageSketcherState>();
  final _key = GlobalKey<ScaffoldState>();

  Color drawColor = Colors.white;
  PaintMode paintMode = PaintMode.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Stack(
          children: [
            ImageSketcher.asset(
              'images/image.jpg',
              key: _imageKey,
              enableToolbar: false,
              initialPaintMode: paintMode,
              initialColor: drawColor,
            ),

            // default bottom bar
            if (paintMode == PaintMode.none)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(
                            100,
                          ),
                          border: Border.all(
                            color: AppColors.grey,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Add a caption..",
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "Status (Contacts)",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ActionButton(
                            onTap: () {},
                            icon: Icons.send,
                            backgroundColor: AppColors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // draw bottom bar
            if (paintMode == PaintMode.freeStyle)
              Align(
                alignment: Alignment.bottomCenter,
                child: LineWeightSelector(
                  onBrushWeightChanged: (weight) {
                    _imageKey.currentState?.changeBrushWidth(weight);
                  },
                ),
              ),

            // default top bar
            if (paintMode == PaintMode.none)
              _DefaultTopBar(
                onEnterDrawMode: () {
                  _imageKey.currentState?.changePaintMode(PaintMode.freeStyle);
                  setState(() {
                    paintMode = PaintMode.freeStyle;
                  });
                },
                onUndoTap: () {
                  _imageKey.currentState?.undo();
                },
              ),

            // draw top bar
            if (paintMode == PaintMode.freeStyle)
              _DrawTopBar(
                initialColor: drawColor,
                onColorChanged: (selectedColor) {
                  _imageKey.currentState?.updateColor(selectedColor);
                  setState(() {
                    drawColor = selectedColor;
                  });
                },
                onUndo: () {
                  _imageKey.currentState?.undo();
                },
                onDone: () {
                  _imageKey.currentState?.changePaintMode(PaintMode.none);
                  setState(() {
                    paintMode = PaintMode.none;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DrawTopBar extends StatefulWidget {
  final Color _initialColor;
  final void Function(Color selectedColor)? _onColorChanged;
  final void Function()? _onDone;
  final void Function()? _onUndo;
  const _DrawTopBar({
    required Color initialColor,
    Function(Color selectedColor)? onColorChanged,
    void Function()? onDone,
    void Function()? onUndo,
  })  : _initialColor = initialColor,
        _onColorChanged = onColorChanged,
        _onDone = onDone,
        _onUndo = onUndo;

  @override
  State<_DrawTopBar> createState() => _DrawTopBarState();
}

class _DrawTopBarState extends State<_DrawTopBar> {
  late Color color = widget._initialColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: widget._onDone,
            child: const Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          const Spacer(),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ActionButton(
                  onTap: widget._onUndo,
                  icon: Icons.undo,
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  children: [
                    ActionButton(
                      onTap: () {},
                      icon: Icons.edit_outlined,
                      backgroundColor: color,
                      color: color == Colors.white
                          ? AppColors.black
                          : Colors.white,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ColorSlider(
                      onColorChanged: (selectedColor) {
                        setState(() {
                          color = selectedColor;
                        });
                        widget._onColorChanged?.call(selectedColor);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultTopBar extends StatelessWidget {
  final void Function()? _onCancelTap;
  final void Function()? _onUndoTap;
  final void Function()? _onEnterTextMode;
  final void Function()? _onEnterDrawMode;
  const _DefaultTopBar({
    void Function()? onCancelTap,
    void Function()? onUndoTap,
    void Function()? onEnterTextMode,
    void Function()? onEnterDrawMode,
  })  : _onCancelTap = onCancelTap,
        _onUndoTap = onUndoTap,
        _onEnterTextMode = onEnterTextMode,
        _onEnterDrawMode = onEnterDrawMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          ActionButton(
            onTap: _onCancelTap,
            icon: Icons.clear,
          ),
          const Spacer(),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ActionButton(
                  onTap: _onUndoTap,
                  icon: Icons.undo,
                ),
                const SizedBox(
                  width: 16,
                ),
                ActionButton(
                  onTap: _onEnterTextMode,
                  icon: Icons.text_fields_outlined,
                ),
                const SizedBox(
                  width: 16,
                ),
                ActionButton(
                  onTap: () {
                    debugPrint("Aksi draw di klik");
                    _onEnterDrawMode?.call();
                  },
                  icon: Icons.edit_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
