import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:listen_core/core.dart';
import 'package:path_provider/path_provider.dart';

import '../uikit.dart';

/// A reusable, premium-styled image cropping widget.
/// Supports both circular (e.g. for avatars) and rectangular cropping zones.
class CommonImageCropper extends StatefulWidget {
  final File imageFile;
  final BoxShape cropShape;
  final String? title;
  final String? cancelText;
  final String? confirmText;
  final String? cropFailedMessage;

  const CommonImageCropper({
    super.key,
    required this.imageFile,
    this.cropShape = BoxShape.circle,
    this.title,
    this.cancelText,
    this.confirmText,
    this.cropFailedMessage,
  });

  @override
  State<CommonImageCropper> createState() => _CommonImageCropperState();
}

class _CommonImageCropperState extends State<CommonImageCropper> {
  final GlobalKey _boundaryKey = GlobalKey();
  bool _isCropping = false;

  Future<void> _cropAndConfirm() async {
    if (_isCropping) return;
    setState(() {
      _isCropping = true;
    });

    try {
      // Step 1: Retrieve the RenderRepaintBoundary associated with the crop area.
      // This boundary defines the exact visual region of the screen we want to capture.
      final RenderRepaintBoundary? boundary =
          _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('Boundary not found');

      // Step 2: Convert the visual boundary into a raw ui.Image object.
      // We use a pixelRatio of 3.0 to ensure a high-resolution, sharp output image.
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // Step 3: Convert the ui.Image object into ByteData formatted as a PNG.
      // PNG format is essential here because it preserves the transparent alpha channels 
      // of the corners outside the circular clip mask.
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('Failed to get byte data');

      // Step 4: Extract raw bytes from the ByteData wrapper.
      final Uint8List bytes = byteData.buffer.asUint8List();

      // Step 5: Save the cropped image bytes to a temporary file on the local disk.
      final tempDir = await getTemporaryDirectory();
      final String tempPath = '${tempDir.path}/cropped_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final File croppedFile = File(tempPath);
      await croppedFile.writeAsBytes(bytes);

      // Step 6: Return the cropped File back to the previous screen using AppNav.
      if (mounted) {
        AppNav.back(croppedFile);
      }
    } catch (e) {
      appLogger.e('CommonImageCropper: Error cropping image: $e');
      if (mounted) {
        CommonToast.show(
          widget.cropFailedMessage ?? UIKitConfig.getString('Failed to crop image'),
          type: ToastType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCropping = false;
        });
      }
    }
  }

  /// Builds the [InteractiveViewer] widget.
  /// 
  /// What is InteractiveViewer?
  /// InteractiveViewer is a Flutter widget that enables pan (drag to move) and zoom (pinch to scale)
  /// gestures on its child widget.
  /// 
  /// Purpose in Cropper:
  /// It allows the user to scale and position the source image within the clipping frame 
  /// (circular or rectangular boundary) to select the perfect section of the image to crop.
  Widget _buildInteractiveViewer() {
    return InteractiveViewer(
      minScale: 0.8, // Minimum zoom out scale
      maxScale: 4.0, // Maximum zoom in scale
      boundaryMargin: const EdgeInsets.all(100), // Visual padding allowing the image to be panned past its margins
      child: Image.file(
        widget.imageFile,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => AppNav.back(),
                  ),
                  Text(
                    widget.title ?? UIKitConfig.getString('Crop Image'),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 48), // Spacer to balance close button
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Blurred Backdrop for premium styling
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: FileImage(widget.imageFile), fit: BoxFit.cover),
                        ),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(color: Colors.black.withValues(alpha: 0.6)),
                        ),
                      ),
                    ),

                    // Central Crop Viewport
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: widget.cropShape,
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: widget.cropShape == BoxShape.rectangle
                            ? BorderRadius.circular(12)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: RepaintBoundary(
                        key: _boundaryKey,
                        child: Visibility(
                          visible: widget.cropShape == BoxShape.circle,
                          replacement: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(color: Colors.black, child: _buildInteractiveViewer()),
                          ),
                          child: ClipOval(
                            child: Container(color: Colors.black, child: _buildInteractiveViewer()),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white30),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      onPressed: () => AppNav.back(),
                      child: Text(widget.cancelText ?? UIKitConfig.getString('Cancel')),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        elevation: 0,
                      ),
                      onPressed: _isCropping ? null : _cropAndConfirm,
                      child: Visibility(
                        visible: _isCropping,
                        replacement: Text(widget.confirmText ?? UIKitConfig.getString('Confirm')),
                        child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
