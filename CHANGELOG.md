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
