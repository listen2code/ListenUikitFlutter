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
      // Step 1: Retrieve the RenderRepaintBoundary associated with the full InteractiveViewer.
      final RenderRepaintBoundary? boundary =
          _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('Boundary not found');

      // Step 2: Convert the visual boundary into a raw ui.Image object representing the full viewer area.
      final double pixelRatio = 3.0;
      final ui.Image fullImage = await boundary.toImage(pixelRatio: pixelRatio);

      // Step 3: Crop the center 280x280 region (scaled by pixelRatio) using a Canvas.
      final double cropSize = 280.0 * pixelRatio;
      final double left = (fullImage.width - cropSize) / 2;
      final double top = (fullImage.height - cropSize) / 2;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final destRect = Rect.fromLTWH(0, 0, cropSize, cropSize);

      canvas.drawImageRect(
        fullImage,
        Rect.fromLTWH(left, top, cropSize, cropSize),
        destRect,
        Paint(),
      );

      final ui.Image croppedImage = await recorder.endRecording().toImage(cropSize.toInt(), cropSize.toInt());

      // Step 4: Convert the cropped ui.Image object into ByteData formatted as a PNG.
      final ByteData? byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('Failed to get byte data');

      // Step 5: Extract raw bytes from the ByteData wrapper.
      final Uint8List bytes = byteData.buffer.asUint8List();

      // Step 6: Save the cropped image bytes to a temporary file on the local disk.
      final tempDir = await getTemporaryDirectory();
      final String tempPath = '${tempDir.path}/cropped_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final File croppedFile = File(tempPath);
      await croppedFile.writeAsBytes(bytes);

      // Step 7: Return the cropped File back to the previous screen using AppNav.
      if (mounted) {
        AppNav.back(croppedFile);
      }
    } catch (e) {
      appLogger.e('CommonImageCropper: Error cropping image: $e');
      if (mounted) {
        CommonToast.show(
          widget.cropFailedMessage ?? UIKitConfig.getString(UIKitConfig.kCropFailed),
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
      minScale: 1.0, // Minimum zoom scale is 1.0 to fit bounds properly
      maxScale: 5.0, // Maximum zoom in scale
      boundaryMargin: const EdgeInsets.all(150), // Margin allowing full pan movement past edges
      child: Center(
        child: Image.file(
          widget.imageFile,
          width: double.infinity,
          fit: BoxFit.contain, // Fits the original image to screen width/bounds correctly
        ),
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
            // Top Bar - Title and Cancel are not blurred now
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
                    widget.title ?? UIKitConfig.getString(UIKitConfig.kCropImage),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 48), // Spacer to balance close button
                ],
              ),
            ),

            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Full view RepaintBoundary with the InteractiveViewer image in background
                  Positioned.fill(
                    child: RepaintBoundary(
                      key: _boundaryKey,
                      child: Container(
                        color: Colors.black,
                        child: _buildInteractiveViewer(),
                      ),
                    ),
                  ),

                  // 2. Light grey transparent overlay mask on top, ignoring touch events
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: CropMaskPainter(cropShape: widget.cropShape),
                      ),
                    ),
                  ),
                ],
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
                      child: Text(widget.cancelText ?? UIKitConfig.getString(UIKitConfig.kCancel)),
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
                        replacement: Text(widget.confirmText ?? UIKitConfig.getString(UIKitConfig.kConfirm)),
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

/// Custom painter that draws a semi-transparent grey mask over the entire layout
/// except for a highlit circular or rounded-rectangular crop cutout in the center.
class CropMaskPainter extends CustomPainter {
  final BoxShape cropShape;

  CropMaskPainter({required this.cropShape});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6) // A subtle premium dark overlay mask
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Size and bounds for the central highlighted cutout area
    final double cutoutSize = 280.0;
    final double left = (size.width - cutoutSize) / 2;
    final double top = (size.height - cutoutSize) / 2;
    final cutoutRect = Rect.fromLTWH(left, top, cutoutSize, cutoutSize);

    final Path maskPath = Path()..addRect(rect);
    final Path cutoutPath = Path();
    if (cropShape == BoxShape.circle) {
      cutoutPath.addOval(cutoutRect);
    } else {
      cutoutPath.addRRect(RRect.fromRectAndRadius(cutoutRect, const Radius.circular(12)));
    }

    // Combine paths using subtraction to leave the center cutout fully transparent
    final Path combinedPath = Path.combine(
      PathOperation.difference,
      maskPath,
      cutoutPath,
    );

    canvas.drawPath(combinedPath, paint);

    // Draw the white outline border around the highlit cutout area
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (cropShape == BoxShape.circle) {
      canvas.drawOval(cutoutRect, borderPaint);
    } else {
      canvas.drawRRect(RRect.fromRectAndRadius(cutoutRect, const Radius.circular(12)), borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CropMaskPainter oldDelegate) {
    return oldDelegate.cropShape != cropShape;
  }
}
