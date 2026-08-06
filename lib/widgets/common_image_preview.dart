import 'dart:io';

import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';

import '../uikit.dart';

/// A reusable, premium-styled fullscreen image preview page.
/// Supports zooming, panning, double-tap to reset zoom, and Hero animation transitions.
class CommonImagePreview extends StatefulWidget {
  final String? imageUrl;
  final File? imageFile;
  final String? heroTag;

  const CommonImagePreview({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.heroTag,
  });

  @override
  State<CommonImagePreview> createState() => _CommonImagePreviewState();
}

class _CommonImagePreviewState extends State<CommonImagePreview> {
  final TransformationController _transformationController = TransformationController();

  void _resetZoom() {
    setState(() {
      _transformationController.value = Matrix4.identity();
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fallbackErrorWidget = CommonAvatar(
      size: 200,
      iconSize: 100,
      backgroundColor: Colors.white10,
      iconColor: Colors.white54,
    );

    Widget imageWidget;
    if (widget.imageFile != null) {
      imageWidget = CommonImage.file(widget.imageFile!);
    } else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      imageWidget = CommonImage.url(
        widget.imageUrl!,
        errorWidget: fallbackErrorWidget,
      );
    } else {
      imageWidget = fallbackErrorWidget;
    }

    if (widget.heroTag != null) {
      imageWidget = Hero(
        tag: widget.heroTag!,
        child: imageWidget,
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main Interactive Viewer area
          Positioned.fill(
            child: GestureDetector(
              onDoubleTap: _resetZoom,
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 1.0,
                maxScale: 5.0,
                child: Center(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: imageWidget,
                  ),
                ),
              ),
            ),
          ),
          
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: Material(
              color: Colors.black38,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => AppNav.back(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
