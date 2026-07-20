## 0.0.17

- **WebView Navigation & Back Gesture Integration**:
    - Refactored `CommonWebView` to use dynamic `canPop` logic in its `PopScope` based on the browser back history state (`canPop: !widget.enableBackHistory || !_canGoBack`).
    - Added dynamic history tracking using `onUpdateVisitedHistory` and `onLoadStop` callbacks.
    - Replaced the conditional building of the `InAppWebView` widget with `Offstage` in `_buildWebViewBody` to keep the native view and method channel alive on load errors (resolving the `MissingPluginException` on retry).
- **Custom Scheme Routing**:
    - Added `url_launcher` dependency (`^6.3.2`) to the package.
    - Updated `shouldOverrideUrlLoading` in `CommonWebView` to automatically catch custom URI schemes (like `mailto:`, `tel:`, `sms:`) and launch them externally in the system browser/email client rather than letting the WebView fail.
    - Introduced the `webSchemes` parameter (defaulting to `['http', 'https', 'file', 'chrome', 'about']`) to allow callers to configure which URL schemes are treated as internal web content.
- **Dependencies**:
    - Upgraded `listen_core` dependency from `^0.0.36` to `^0.0.37`.
- **Project Metadata**:
    - Bumped package version to `0.0.17`.
    - Updated `CHANGELOG.md` to reflect version `0.0.17` changes.

## 0.0.16

- **New Features**:
    - Introduced `CommonBottomSheet` in `lib/widgets/common_bottom_sheet.dart`, providing a static `show` method that wraps `showModalBottomSheet` with a default top radius.
- **Library Exports**:
    - Exported `common_bottom_sheet.dart` in `lib/uikit.dart` to make the new widget available to consumers.
- **Dependencies**:
    - Upgraded `listen_core` from `^0.0.32` to `^0.0.36` in `pubspec.yaml`.
- **Project Metadata**:
    - Bumped package version to `0.0.16`.
    - Updated `CHANGELOG.md` to reflect version `0.0.16` changes.
  
## 0.0.15

* **Add common_icon_button.dart**:

## 0.0.14

* **Upgrade listen_code:0.0.14**:

## 0.0.13

* **CommonWebView**:
    * Added `InAppWebViewController.clearAllCache()` 
  
## 0.0.12

* **CommonWebView**:
    * Added `enableBackHistory` parameter to control whether to allow going back in WebView browser history before popping the route.
  
## 0.0.11

* **CommonWebView**:
    * Added `shrinkWrap` auto-height sensing mode based on dynamic `ResizeObserver` injection.
    * Added `shouldOverrideUrlLoadingWithAction` advanced navigation interceptor callback to support detailed `NavigationAction` parameter mapping (e.g. `hasGesture`, `isRedirect`, and `navigationType`).

## 0.0.10

* **CommonWebView & CommonDialog**:
    * Added initial implementation of commercial-grade `CommonWebView` widget.
    * Extended `CommonDialog` parameter support.

## 0.0.9

* **Dependency Update**:
    * Updated dependency on `listen_core` to `^0.0.10`.

## 0.0.8

* **Dependency Update**:
    * Updated dependency on `listen_core` to `^0.0.9`.

## 0.0.7

* **Dependency Update**:
  * Updated dependency on `listen_core` to `^0.0.8`.

## 0.0.6

* **Accessibility & Interactive Consolidations**:
  * Unified `CommonInkWell` and custom clickable behaviors into the new **`CommonClickable`** widget.
  * Added native accessibility support (`semanticLabel`, `excludeFromSemantics`, `selected`) to `CommonClickable`.
  * Added `semanticLabel` and `excludeFromSemantics` parameters to `CommonImage` constructors.
  * Deprecated and deleted `CommonInkWell` to guide transition to `CommonClickable`.

## 0.0.5

* **Theme integration update**:
  * Added compatibility for Material You dynamic color scheme injection.

## 0.0.4

* **Environment Update**:
   * Updated dependency on `listen_core` reference compatibility.

## 0.0.4

* **Environment Update**:
  * Upgraded environment SDK constraints to Dart `^3.12.1` to support Flutter `3.44.1`.
  * Updated dependency on `listen_core` reference compatibility.

## 0.0.3

* **Documentation Enhancement**:
  * Added comprehensive trilingual support (English, Chinese, Japanese)
  * Complete documentation for all 18 CommonXXX widgets
  * Reorganized README.md into separate language blocks
* **Dependency Updates**:
  * Updated listen_core dependency to version 0.0.4
  * Added pub.dev links for listen_core and listen_uikit
  * Added complete example app reference

## 0.0.2

* **Documentation**:
  * Merged `uikit-architecture.md` into `README.md` to provide a comprehensive UI component guide.
* **Dependency Management**:
  * Fixed `listen_core` dependency conflict by switching to a path dependency, ensuring alignment with the main project.
* **Version Alignment**:
  * Synchronized versioning with `listen_core` to 0.0.3.
* Initial component set implementation including `CommonText`, `CommonButton`, `CommonImage`, and `CommonDialog`.
* Integrated `UIKitConfig` for global configuration and internationalization.

## 0.0.1

* Initial project structure for Listen UI Kit.
