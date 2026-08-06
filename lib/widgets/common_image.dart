import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum _ImageType { asset, network, file }

/// A unified image component supporting assets, network (with caching), disk files, SVG, and optimized GIFs.
class CommonImage extends StatelessWidget {
  static const String _base64Scheme = 'data:image/';
  static const String _base64Indicator = ';base64,';
  static const String _base64Separator = ',';

  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final double borderRadius;
  final _ImageType _type;

  /// Limits the decoded image size in memory to prevent crashes with large images.
  final int? memCacheWidth;
  final int? memCacheHeight;

  final String? semanticLabel;
  final bool excludeFromSemantics;
  final Widget? errorWidget;

  const CommonImage.asset(
    this.source, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.borderRadius = 0,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.errorWidget,
  }) : _type = _ImageType.asset,
       memCacheWidth = null,
       memCacheHeight = null;

  const CommonImage.url(
    this.source, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius = 0,
    this.memCacheWidth,
    this.memCacheHeight,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.errorWidget,
  }) : _type = _ImageType.network;

  CommonImage.file(
    File file, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius = 0,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.errorWidget,
  }) : source = file.path,
       _type = _ImageType.file,
       memCacheWidth = null,
       memCacheHeight = null;

  @override
  Widget build(BuildContext context) {
    // 1. Guard for empty source
    if (source.trim().isEmpty) {
      return _buildErrorWidget(context);
    }

    Widget image;

    final isSvg = source.toLowerCase().endsWith('.svg') ||
        source.toLowerCase().contains('.svg?') ||
        source.toLowerCase().contains('/svg?') ||
        source.toLowerCase().contains('/svg');
    final isGif = source.toLowerCase().endsWith('.gif');
    final isBase64 = source.startsWith(_base64Scheme) || source.contains(_base64Indicator);

    if (isBase64) {
      image = _buildBase64Image(context);
    } else if (isSvg) {
      image = _buildSvgImage();
    } else if (isGif && _type == _ImageType.network) {
      image = _buildNativelyHandledNetworkImage(context);
    } else {
      switch (_type) {
        case _ImageType.asset:
          image = _buildAssetImage();
          break;
        case _ImageType.network:
          image = _buildCachedNetworkImage(context);
          break;
        case _ImageType.file:
          image = _buildFileImage();
          break;
      }
    }

    if (borderRadius > 0) {
      image = ClipRRect(borderRadius: BorderRadius.circular(borderRadius), child: image);
    }

    if (excludeFromSemantics) {
      return ExcludeSemantics(child: image);
    } else if (semanticLabel != null) {
      return Semantics(
        label: semanticLabel,
        image: true,
        child: image,
      );
    }

    return image;
  }

  Widget _buildSvgImage() {
    if (_type == _ImageType.asset) {
      return SvgPicture.asset(
        source,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    } else if (_type == _ImageType.file) {
      return SvgPicture.file(
        File(source),
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    } else {
      return SvgPicture.network(
        source,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        placeholderBuilder: (context) => _buildPlaceholder(context),
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(context),
      );
    }
  }

  Widget _buildBase64Image(BuildContext context) {
    try {
      final String trimmedSource = source.trim();
      Uint8List? bytes = Base64ImageCache.get(trimmedSource);
      if (bytes == null) {
        final commaIndex = trimmedSource.indexOf(_base64Separator);
        final base64Str = commaIndex != -1 ? trimmedSource.substring(commaIndex + 1) : trimmedSource;
        bytes = base64Decode(base64Str.trim());
        Base64ImageCache.put(trimmedSource, bytes);
      }
      return Image.memory(bytes, width: width, height: height, fit: fit, color: color);
    } catch (e) {
      return _buildErrorWidget(context);
    }
  }

  Widget _buildAssetImage() {
    return Image.asset(source, width: width, height: height, fit: fit, color: color);
  }

  Widget _buildFileImage() {
    return Image.file(File(source), width: width, height: height, fit: fit, color: color);
  }

  Widget _buildCachedNetworkImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: source,
      width: width,
      height: height,
      fit: fit,
      color: color,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      placeholder: (context, url) => _buildPlaceholder(context),
      errorWidget: (context, url, error) => _buildErrorWidget(context),
    );
  }

  Widget _buildNativelyHandledNetworkImage(BuildContext context) {
    return Image.network(
      source,
      width: width,
      height: height,
      fit: fit,
      color: color,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildPlaceholder(context);
      },
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return ExcludeSemantics(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          // Smooth gradient placeholder replacing the spinner
          gradient: LinearGradient(
            colors: [
              theme.dividerColor.withValues(alpha: 0.05),
              theme.dividerColor.withValues(alpha: 0.1),
              theme.dividerColor.withValues(alpha: 0.05),
            ],
            begin: const Alignment(-1.0, -0.5),
            end: const Alignment(1.0, 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (errorWidget != null) {
      final child = SizedBox(width: width, height: height, child: errorWidget!);
      if (borderRadius > 0) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: child,
        );
      }
      return child;
    }
    final theme = Theme.of(context);
    return ExcludeSemantics(
      child: Container(
        width: width,
        height: height,
        color: theme.dividerColor.withValues(alpha: 0.1),
        child: const Icon(Icons.broken_image_outlined, color: Colors.grey, size: 24),
      ),
    );
  }
}

/// A highly-optimized, memory-bounded Least Recently Used (LRU) Cache 
/// for storing decoded Base64 image byte arrays.
/// Prevents redundant base64 decoding on every frame build,
/// and evicts old entries to maintain limits on count and memory size.
class Base64ImageCache {
  Base64ImageCache._();

  static int _maxCount = 100; // Default max 100 cached images
  static int _maxSizeBytes = 20 * 1024 * 1024; // Default max 20 MB memory footprint

  static final LinkedHashMap<String, Uint8List> _map = LinkedHashMap<String, Uint8List>();
  static int _currentSizeBytes = 0;

  /// Configures the cache limits globally.
  /// [maxCount] The maximum number of images allowed in the cache.
  /// [maxSizeBytes] The maximum memory footprint in bytes allowed for the cache.
  static void configure({int? maxCount, int? maxSizeBytes}) {
    if (maxCount != null) {
      _maxCount = maxCount;
    }
    if (maxSizeBytes != null) {
      _maxSizeBytes = maxSizeBytes;
    }
    _evictIfNeeded();
  }

  /// Retrieves an image from the cache and updates its LRU status.
  static Uint8List? get(String key) {
    final value = _map.remove(key);
    if (value != null) {
      _map[key] = value; // Put back to make it the most recently used
    }
    return value;
  }

  /// Adds a new image to the cache and evicts old entries if bounds are exceeded.
  static void put(String key, Uint8List value) {
    final old = _map.remove(key);
    if (old != null) {
      _currentSizeBytes -= old.lengthInBytes;
    }
    
    _map[key] = value;
    _currentSizeBytes += value.lengthInBytes;

    _evictIfNeeded();
  }

  static void _evictIfNeeded() {
    while (_map.isNotEmpty && (_map.length > _maxCount || _currentSizeBytes > _maxSizeBytes)) {
      final firstKey = _map.keys.first;
      final evicted = _map.remove(firstKey);
      if (evicted != null) {
        _currentSizeBytes -= evicted.lengthInBytes;
      }
    }
  }

  /// Clears all entries from the cache.
  static void clear() {
    _map.clear();
    _currentSizeBytes = 0;
  }

  /// Gets the number of cached items.
  static int get size => _map.length;

  /// Gets the current total size of cached items in bytes.
  static int get currentSizeBytes => _currentSizeBytes;
}
