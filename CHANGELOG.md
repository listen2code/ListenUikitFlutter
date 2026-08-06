## 0.0.29
- **UI Components**: Created `CommonAvatar` in `ListenUiKit`, providing a standardized circular placeholder with customizable size, colors, and icons.
- **Refactoring**: Replaced inline `Container` and `Icon` implementations with the new `CommonAvatar` widget in `CommonImagePreview`, `HomePage`, and `AboutMeHeader`.
- **Error Handling**: Updated `CommonImage.url` usages in the home and profile sections to provide `CommonAvatar` as the `errorWidget`, improving the visual experience when remote images fail to load.
- **Accessibility**: Enhanced the profile header by wrapping the avatar component in a `Semantics` widget with appropriate labels.
- **UI Kit**: Exported `CommonAvatar` from the main `uikit.dart` library for project-wide availability.

## 0.0.28
- **CommonImage Widget**: Added an optional `errorWidget` property to the `asset`, `network`, and `file` constructors.
- **Error Rendering**: Refactored `_buildErrorWidget` to prioritize the provided `errorWidget`, ensuring it respects defined dimensions and `borderRadius` constraints.
- **CommonImagePreview**: Introduced a circular `fallbackErrorWidget` featuring a person icon. This replaces the generic "broken image" icon when an image URL is missing or fails to load.

## 0.0.27
- **UI Layout**: Modified `CommonButton` to apply conditional default padding based on the `isFullWidth` property.
- **Padding Defaults**:
    - **Full-width buttons**: Maintains the existing `vertical: 12` padding.
    - **Standard buttons**: Now defaults to `horizontal: 16, vertical: 8` when no custom padding is explicitly provided.

## 0.0.26
- **Dependencies**: Updated `listen_core` dependency to `^0.0.51`.
- **Documentation & Alignment**: Aligned component specifications and documentation with core infrastructure updates and localized data rendering.

## 0.0.25
- **Navigation**: Uncommented `Navigator.of(context).pop()` calls within the back navigation handlers to ensure the widget pops from the navigation stack when the WebView cannot navigate backward.

## 0.0.24
- **New Property**: Added `preventSwipeBack` to `CommonWebView` (defaulting to `false`) to control whether system navigation gestures are blocked.
- **Navigation Logic**: Updated `PopScope` and its `canPop` condition to respect the `preventSwipeBack` flag, ensuring the WebView handles back events internally or blocks them as configured.
- **Cleanup**: Removed `AnimatedBuilder` and `ModalRoute` animation tracking from `_buildWebViewBody`. This removes the custom fade-out effect previously applied during route transitions to simplify the implementation.
- **Refactoring**: Streamlined `_buildWebViewBody` to return a `Stack` directly and cleaned up formatting across the file.

## 0.0.23
- **Transition Handling**: Integrated `ModalRoute` animation tracking within `_buildWebViewBody` to detect when the view is being popped.
- **Animation Logic**: Wrapped the WebView stack in an `AnimatedBuilder` that monitors the `AnimationStatus.reverse` state.
- **Visual Smoothing**: Added a dynamic overlay using the theme's `scaffoldBackgroundColor` that fades in as the route animation value decreases, effectively hiding the native platform view before it is disposed.
- **Refactoring**: Extracted the WebView and progress indicator into a `webViewStack` variable to improve readability and conditional rendering logic.

## 0.0.22
- **Dialog Components**:
    - Added a nullable `subtitle` field to the `DialogSwitchItem` class and updated its constructor.
    - Updated the `ListTile` in `common_dialog.dart` to render the subtitle when provided, using a smaller font size and grey color.

## 0.0.21
- **CommonImage Optimization**:
    - Updated `_buildBase64Image` to attempt to retrieve decoded bytes from `Base64ImageCache` before performing a `base64Decode` operation.
    - Successfully decoded bytes are now automatically stored in the cache for future use.
- **Base64ImageCache Utility**:
    - Introduced a `Base64ImageCache` class to manage a `LinkedHashMap` of decoded image data.
    - Implemented memory-sensitive eviction logic that limits the cache to 100 items or a 20 MB total memory footprint by default.
    - Added configuration methods to allow global adjustment of cache limits and manual cache clearing.

## 0.0.20
- **New UI Component**:
    - Created `CommonImagePreview` in `lib/widgets/common_image_preview.dart`.
    - Implemented `InteractiveViewer` to provide pinch-to-zoom and panning capabilities with a maximum scale of 5.0.
    - Added double-tap gesture support to reset the zoom level via a `TransformationController`.
    - Integrated `Hero` animation support to allow smooth transitions from gallery or list views.
- **Styling and Navigation**:
    - Designed a premium-styled interface with a black background and a semi-transparent floating back button.
    - Integrated with `AppNav` for standard back navigation.
    - Utilized the project's internal `CommonImage` component to handle both URL and file-based image rendering.

## 0.0.19
- **New Widget**:
    - Created `CommonImageCropper` in `lib/widgets/common_image_cropper.dart` to handle image manipulation and cropping.
    - Added support for both `BoxShape.circle` (for avatars) and `BoxShape.rectangle` cropping areas.
    - Implemented `InteractiveViewer` to allow users to pan and zoom images within the viewport.
    - Added image processing logic using `RepaintBoundary` to capture the cropped area and save it as a temporary PNG file.
    - Integrated localization-ready strings for titles, buttons, and error messages.
- **Library Exports**:
    - Exported `CommonImageCropper` in `lib/uikit.dart` to make the widget accessible to consumers of the library.

## 0.0.18
- **CommonImage Enhancements**:
    - Added support for Base64 encoded images by detecting data URI schemes (e.g., `data:image/...;base64,`).
    - Implemented `_buildBase64Image` to decode Base64 strings and render them using `Image.memory`.
    - Integrated Base64 detection into the main image building logic, prioritizing it alongside SVG and GIF handling.
- **Project Metadata**:
    - Bumped package version to `0.0.18` in `pubspec.yaml`.
- **Dependency Management**:
    - Updated `listen_core` dependency from `^0.0.37` to `^0.0.42`.

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
