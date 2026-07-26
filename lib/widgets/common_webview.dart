import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../uikit.dart';

/// A wrapper class for controlling the WebView from parent widgets.
class CommonWebViewController {
  InAppWebViewController? _inAppWebViewController;

  /// Internal setter to attach the controller when webview is created
  void _attach(InAppWebViewController controller) {
    _inAppWebViewController = controller;
  }

  /// Load a new URL
  Future<void> loadUrl({required String url, Map<String, String>? headers}) async {
    if (_inAppWebViewController != null) {
      await _inAppWebViewController!.loadUrl(
        urlRequest: URLRequest(url: WebUri(url), headers: headers),
      );
    }
  }

  /// Load custom HTML content
  Future<void> loadHtml({required String html, String? baseUrl}) async {
    if (_inAppWebViewController != null) {
      await _inAppWebViewController!.loadData(
        data: html,
        mimeType: 'text/html',
        encoding: 'utf8',
        baseUrl: baseUrl != null ? WebUri(baseUrl) : null,
      );
    }
  }

  /// Go back in browser history
  Future<void> goBack() async {
    if (_inAppWebViewController != null) {
      await _inAppWebViewController!.goBack();
    }
  }

  /// Check if browser can go back
  Future<bool> canGoBack() async {
    if (_inAppWebViewController != null) {
      return await _inAppWebViewController!.canGoBack();
    }
    return false;
  }

  /// Go forward in browser history
  Future<void> goForward() async {
    if (_inAppWebViewController != null) {
      await _inAppWebViewController!.goForward();
    }
  }

  /// Check if browser can go forward
  Future<bool> canGoForward() async {
    if (_inAppWebViewController != null) {
      return await _inAppWebViewController!.canGoForward();
    }
    return false;
  }

  /// Reload the current page
  Future<void> reload() async {
    if (_inAppWebViewController != null) {
      await _inAppWebViewController!.reload();
    }
  }

  /// Clear WebView cache
  Future<void> clearCache() async {
    await InAppWebViewController.clearAllCache();
  }

  /// Evaluate custom Javascript code in the webpage
  Future<dynamic> evaluateJavascript({required String source}) async {
    if (_inAppWebViewController != null) {
      return await _inAppWebViewController!.evaluateJavascript(source: source);
    }
    return null;
  }

  /// Register a Javascript handler for communication from JS to Flutter.
  /// Inside H5, call: `window.flutter_inappwebview.callHandler('handlerName', args)`
  void addJavaScriptHandler({required String handlerName, required Function(List<dynamic> args) callback}) {
    if (_inAppWebViewController != null) {
      _inAppWebViewController!.addJavaScriptHandler(handlerName: handlerName, callback: callback);
    }
  }

  /// Remove a registered Javascript handler
  void removeJavaScriptHandler({required String handlerName}) {
    if (_inAppWebViewController != null) {
      _inAppWebViewController!.removeJavaScriptHandler(handlerName: handlerName);
    }
  }
}

/// A premium, commercial-grade WebView widget.
/// Can be used as a full-screen page or embedded into any other layouts.
class CommonWebView extends StatefulWidget {
  /// The initial URL to load
  final String? initialUrl;

  /// The initial HTML content to load
  final String? initialHtml;

  /// Header parameters to include in the initial web request
  final Map<String, String>? headers;

  /// The title displayed in the AppBar (if shown)
  final String? title;

  /// Whether to show the default AppBar (defaults to true)
  final bool showAppBar;

  /// Whether to show the top-mounted linear progress bar (defaults to true)
  final bool showProgressBar;

  /// Custom progress bar color (falls back to theme primary color)
  final Color? progressBarColor;

  /// Whether to show a close button in addition to the back button (defaults to true)
  final bool showCloseButton;

  /// Whether to enable pull-down to refresh (defaults to true)
  final bool enablePullToRefresh;

  /// Custom settings for InAppWebView
  final InAppWebViewSettings? customSettings;

  /// Callback when the WebView controller is ready and attached
  final void Function(CommonWebViewController controller)? onWebViewCreated;

  /// Callback when the web page starts loading
  final void Function(String? url)? onLoadStart;

  /// Callback when the web page stops loading
  final void Function(String? url)? onLoadStop;

  /// Callback when the web page fails to load
  final void Function(String? url, int code, String message)? onLoadError;

  /// Callback when progress changes (0 to 100)
  final void Function(int progress)? onProgressChanged;

  /// Callback when the webpage document title is updated
  final void Function(String? title)? onTitleChanged;

  /// URL navigation interception. Return true to block default loading.
  final bool Function(String url)? shouldOverrideUrlLoading;

  /// Advanced URL navigation interception with full action context.
  /// Return [NavigationActionPolicy] to control the action, or null to fall back to default behavior.
  /// If provided, this takes precedence over [shouldOverrideUrlLoading].
  final Future<NavigationActionPolicy?> Function(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  )?
  shouldOverrideUrlLoadingWithAction;

  /// Pre-defined JS handlers to register on WebView creation
  final Map<String, Function(List<dynamic> args)>? javascriptHandlers;

  /// Custom controller for programmatic interaction from parent widget
  final CommonWebViewController? controller;

  /// Whether to enable auto-height adjustment based on HTML content height.
  /// Primarily used when embedding WebView into dialogs or limited containers.
  final bool shrinkWrap;

  /// The maximum height limit when [shrinkWrap] is enabled.
  /// If content height exceeds this value, scrolling occurs within the WebView.
  final double? maxHtmlHeight;

  /// The minimum height limit when [shrinkWrap] is enabled.
  final double? minHtmlHeight;

  /// Whether to allow going back in WebView browser history before popping the route.
  /// If set to true (default), the back button and gesture will navigate back in H5 history.
  /// If set to false, they will directly close the WebView (pop the route).
  final bool enableBackHistory;

  /// The list of URI schemes that are treated as internal web content.
  /// Any scheme not in this list will be intercepted and launched externally.
  /// Defaults to `['http', 'https', 'file', 'chrome', 'about']`.
  final List<String> webSchemes;

  const CommonWebView({
    super.key,
    this.initialUrl,
    this.initialHtml,
    this.headers,
    this.title,
    this.showAppBar = false,
    this.showProgressBar = true,
    this.progressBarColor,
    this.showCloseButton = true,
    this.enablePullToRefresh = true,
    this.customSettings,
    this.onWebViewCreated,
    this.onLoadStart,
    this.onLoadStop,
    this.onLoadError,
    this.onProgressChanged,
    this.onTitleChanged,
    this.shouldOverrideUrlLoading,
    this.shouldOverrideUrlLoadingWithAction,
    this.javascriptHandlers,
    this.controller,
    this.shrinkWrap = true,
    this.maxHtmlHeight,
    this.minHtmlHeight,
    this.enableBackHistory = true,
    this.webSchemes = const ['http', 'https', 'file', 'chrome', 'about'],
  }) : assert(initialUrl != null || initialHtml != null, 'Either initialUrl or initialHtml must be provided');

  @override
  State<CommonWebView> createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView> {
  late final CommonWebViewController _webViewController;
  PullToRefreshController? _pullToRefreshController;

  double _progress = 0.0;
  bool _hasError = false;
  String _errorMsg = '';
  int _errorCode = 0;
  String? _failedUrl;
  String? _currentTitle;
  double? _htmlHeight;
  bool _canGoBack = false;

  @override
  void initState() {
    super.initState();
    _webViewController = widget.controller ?? CommonWebViewController();
    _currentTitle = widget.title;

    if (widget.enablePullToRefresh && !kIsWeb) {
      _pullToRefreshController = PullToRefreshController(
        settings: PullToRefreshSettings(color: Colors.blue),
        onRefresh: () async {
          if (kIsWeb) {
            _webViewController.reload();
          } else {
            _webViewController._inAppWebViewController?.reload();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shrinkWrap) {
      return _buildShrinkWrappedWebView(context);
    }

    final theme = Theme.of(context);
    final scaffold = Scaffold(
      appBar: widget.showAppBar ? _buildAppBar(context, theme) : null,
      body: _buildWebViewBody(context, theme),
    );

    if (!widget.enableBackHistory) {
      return scaffold;
    }

    final bool canPopWeb = !widget.enableBackHistory || !_canGoBack;

    return PopScope(
      canPop: canPopWeb,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final canGoBack = await _webViewController.canGoBack();
        if (canGoBack) {
          await _webViewController.goBack();
        }
      },
      child: scaffold,
    );
  }

  Widget _buildShrinkWrappedWebView(BuildContext context) {
    final theme = Theme.of(context);
    final minHeight = widget.minHtmlHeight ?? 50.0;
    final maxHeight = widget.maxHtmlHeight ?? 400.0;
    final currentHeight = _htmlHeight ?? minHeight;

    final webViewWidget = ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight, maxHeight: maxHeight),
      child: SizedBox(
        height: currentHeight,
        child: _buildWebViewBody(context, theme),
      ),
    );

    if (!widget.enableBackHistory) {
      return webViewWidget;
    }

    final bool canPopWeb = !widget.enableBackHistory || !_canGoBack;

    return PopScope(
      canPop: canPopWeb,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final canGoBack = await _webViewController.canGoBack();
        if (canGoBack) {
          await _webViewController.goBack();
        }
      },
      child: webViewWidget,
    );
  }

  Widget _buildWebViewBody(BuildContext context, ThemeData theme) {
    final route = ModalRoute.of(context);
    final webViewStack = Stack(
      children: [
        // 1. WebView Viewport - Always keep in tree to preserve native view and controller channel
        Offstage(
          offstage: _hasError,
          child: _buildWebView(context),
        ),

        // 2. Custom Error View
        if (_hasError) _buildErrorView(),

        // 3. Progress Bar Indicator
        if (widget.showProgressBar && _progress < 1.0 && !_hasError)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 3,
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.progressBarColor ?? theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );

    if (route == null || route.animation == null) {
      return webViewStack;
    }

    return AnimatedBuilder(
      animation: route.animation!,
      builder: (context, child) {
        final status = route.animation!.status;
        final isPopping = status == AnimationStatus.reverse;
        if (!isPopping) {
          return child!;
        }

        // Fade out the webview content during pop transition to prevent native platform view freezing stutter.
        final opacity = (1.0 - route.animation!.value).clamp(0.0, 1.0);
        return Stack(
          children: [
            child!,
            Positioned.fill(
              child: Opacity(
                opacity: opacity,
                child: Container(
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
            ),
          ],
        );
      },
      child: webViewStack,
    );
  }

  Future<void> _injectHeightReporter(InAppWebViewController controller) async {
    const jsCode = """
      function reportHeight() {
        var body = document.body;
        var html = document.documentElement;
        if (!body || !html) return;
        var height = Math.max(
          body.scrollHeight, body.offsetHeight,
          html.clientHeight, html.scrollHeight, html.offsetHeight
        );
        window.flutter_inappwebview.callHandler('resize', height);
      }
      reportHeight();
      if (window.ResizeObserver) {
        var observer = new ResizeObserver(function(entries) {
          reportHeight();
        });
        observer.observe(document.body);
      } else {
        window.addEventListener('resize', reportHeight);
        document.addEventListener('DOMContentLoaded', reportHeight);
      }
    """;
    try {
      await controller.evaluateJavascript(source: jsCode);
    } catch (e) {
      debugPrint('Error injecting height reporter: \$e');
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      title: CommonText(
        _currentTitle ?? '',
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () async {
                if (widget.enableBackHistory) {
                  final canGoBack = await _webViewController.canGoBack();
                  if (canGoBack) {
                    await _webViewController.goBack();
                    return;
                  }
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            )
          : null,
      actions: [
        if (widget.showCloseButton && Navigator.canPop(context))
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 24),
            onPressed: () => Navigator.of(context).pop(),
          ),
      ],
      elevation: 0.5,
      centerTitle: true,
    );
  }

  Widget _buildWebView(BuildContext context) {
    final defaultSettings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      javaScriptEnabled: true,
      domStorageEnabled: true,
      supportZoom: true,
      builtInZoomControls: true,
      displayZoomControls: false,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
    );

    return InAppWebView(
      initialUrlRequest: widget.initialUrl != null
          ? URLRequest(url: WebUri(widget.initialUrl!), headers: widget.headers)
          : null,
      initialData: widget.initialHtml != null
          ? InAppWebViewInitialData(data: widget.initialHtml!, mimeType: 'text/html', encoding: 'utf8')
          : null,
      initialSettings: widget.customSettings ?? defaultSettings,
      pullToRefreshController: _pullToRefreshController,
      onWebViewCreated: (controller) {
        _webViewController._attach(controller);

        if (widget.shrinkWrap) {
          controller.addJavaScriptHandler(
            handlerName: 'resize',
            callback: (args) {
              if (args.isNotEmpty && args[0] is num) {
                final height = (args[0] as num).toDouble();
                if (mounted && _htmlHeight != height) {
                  setState(() {
                    _htmlHeight = height;
                  });
                }
              }
            },
          );
        }

        // Register default JS handlers
        if (widget.javascriptHandlers != null) {
          widget.javascriptHandlers!.forEach((name, callback) {
            _webViewController.addJavaScriptHandler(handlerName: name, callback: callback);
          });
        }

        if (widget.onWebViewCreated != null) {
          widget.onWebViewCreated!(_webViewController);
        }
      },
      onLoadStart: (controller, url) {
        setState(() {
          _hasError = false;
        });
        if (widget.onLoadStart != null) {
          widget.onLoadStart!(url?.toString());
        }
      },
      onLoadStop: (controller, url) async {
        _pullToRefreshController?.endRefreshing();
        if (widget.onLoadStop != null) {
          widget.onLoadStop!(url?.toString());
        }
        if (widget.shrinkWrap) {
          await _injectHeightReporter(controller);
        }
        final canBack = await controller.canGoBack();
        if (mounted && _canGoBack != canBack) {
          setState(() {
            _canGoBack = canBack;
          });
        }
      },
      onUpdateVisitedHistory: (controller, url, isReload) async {
        final canBack = await controller.canGoBack();
        if (mounted && _canGoBack != canBack) {
          setState(() {
            _canGoBack = canBack;
          });
        }
      },
      onReceivedError: (controller, request, error) {
        // Exclude loading cancels or minor events to prevent false error pages
        if (request.isForMainFrame ?? true) {
          setState(() {
            _hasError = true;
            _errorMsg = error.description;
            _errorCode = _getErrorTypeCode(error.type);
            _failedUrl = request.url.toString();
          });
          if (widget.onLoadError != null) {
            widget.onLoadError!(request.url.toString(), _errorCode, _errorMsg);
          }
        }
      },
      onReceivedHttpError: (controller, request, errorResponse) {
        // Capture 4xx or 5xx server errors on main frames
        if (request.isForMainFrame ?? true) {
          final code = errorResponse.statusCode;
          if (code != null && code >= 400) {
            setState(() {
              _hasError = true;
              _errorMsg = 'HTTP Server Error ($code)';
              _errorCode = code;
              _failedUrl = request.url.toString();
            });
            if (widget.onLoadError != null) {
              widget.onLoadError!(request.url.toString(), code, _errorMsg);
            }
          }
        }
      },
      onProgressChanged: (controller, progress) {
        setState(() {
          _progress = progress / 100.0;
        });
        if (progress == 100 && widget.shrinkWrap) {
          _injectHeightReporter(controller);
        }
        if (widget.onProgressChanged != null) {
          widget.onProgressChanged!(progress);
        }
      },
      onTitleChanged: (controller, title) {
        if (widget.title == null && title != null && title.isNotEmpty) {
          setState(() {
            _currentTitle = title;
          });
        }
        if (widget.onTitleChanged != null) {
          widget.onTitleChanged!(title);
        }
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        if (widget.shouldOverrideUrlLoadingWithAction != null) {
          final policy = await widget.shouldOverrideUrlLoadingWithAction!(controller, navigationAction);
          if (policy != null) {
            return policy;
          }
        }
        final url = navigationAction.request.url;
        if (url != null) {
          if (!widget.webSchemes.contains(url.scheme)) {
            try {
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                debugPrint('Cannot launch custom scheme URL: $url');
              }
            } catch (e) {
              debugPrint('Error launching custom scheme URL: $e');
            }
            return NavigationActionPolicy.CANCEL;
          }

          final urlStr = url.toString();
          if (widget.shouldOverrideUrlLoading != null) {
            final block = widget.shouldOverrideUrlLoading!(urlStr);
            return block ? NavigationActionPolicy.CANCEL : NavigationActionPolicy.ALLOW;
          }
        }
        return NavigationActionPolicy.ALLOW;
      },
    );
  }

  Widget _buildErrorView() {
    return CommonEmptyView(
      type: EmptyType.error,
      title: 'Failed to Load Page',
      subtitle: _errorMsg.isNotEmpty ? _errorMsg : 'Check your internet connection and try again.',
      actionText: 'Retry',
      onAction: () {
        setState(() {
          _hasError = false;
          _progress = 0.0;
        });
        if (_failedUrl != null) {
          _webViewController.loadUrl(url: _failedUrl!, headers: widget.headers);
        } else if (widget.initialUrl != null) {
          _webViewController.loadUrl(url: widget.initialUrl!, headers: widget.headers);
        } else {
          _webViewController.reload();
        }
      },
    );
  }

  int _getErrorTypeCode(WebResourceErrorType? type) {
    if (type == null) return -1;
    final val = type.toValue();
    switch (val) {
      case 'UNKNOWN':
        return -1;
      case 'HOST_LOOKUP':
        return -2;
      case 'UNSUPPORTED_AUTH_SCHEME':
        return -3;
      case 'AUTHENTICATION':
        return -4;
      case 'PROXY_AUTHENTICATION':
        return -5;
      case 'CONNECT':
        return -6;
      case 'IO':
        return -7;
      case 'TIMEOUT':
        return -8;
      case 'REDIRECT_LOOP':
        return -9;
      case 'UNSUPPORTED_SCHEME':
        return -10;
      case 'FAILED_SSL_HANDSHAKE':
        return -11;
      case 'BAD_URL':
        return -12;
      case 'FILE':
        return -13;
      case 'FILE_NOT_FOUND':
        return -14;
      case 'TOO_MANY_REQUESTS':
        return -15;
      default:
        return val.hashCode;
    }
  }
}
