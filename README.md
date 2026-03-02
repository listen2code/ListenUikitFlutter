# ListenUiKit

ListenUiKit is a lightweight and easy-to-use UI component library designed for Flutter. It aims to provide a set of commonly used, customizable, and beautiful widgets to help you build consistent user interfaces quickly.

## Features

- **`CommonButton`**: A versatile button supporting filled, outlined, and text styles. Includes built-in loading indicators, icon support, and full-width/custom sizing.
- **`CommonDialog`**: A centralized dialog utility supporting single-button messages, confirmations, selection lists, and custom content. Features singleton management to prevent overlapping dialogs.
- **`CommonToast`**: A global toast utility supporting Info, Success, and Error types with smooth animations.
- **`CommonImage`**: A unified image component supporting Assets, Network (with caching), Local Files, SVG, and GIF. Built-in elegant gradient placeholders.
- **`CommonLoading`**: A global loading indicator with support for custom messages.
- **`CommonText`**: An enhanced Text component supporting `FittedBox` auto-scaling and built-in Container configuration.
- **`CommonTextField`**: A text input field with labels and custom validation support.
- **`CommonSwitch`**: A clean, labeled switch component.
- **`UIKitConfig`**: A global configuration center that supports internationalization through string provider injection.

## Installation

Add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  listen_uikit:
    git:
      url: https://github.com/listen2code/ListenUikitFlutter.git
  listen_core: # Dependency
    git:
      url: https://github.com/listen2code/ListenCoreFlutter.git
```

## Getting Started

### 1. Localization (Optional)

Before using the components, you can set up custom strings or connect to your i18n system via `UIKitConfig`.

```dart
import 'package:listen_uikit/uikit.dart';

void main() {
  UIKitConfig.setup(
    stringProvider: (key) {
      final map = {
        UIKitConfig.kOk: 'OK',
        UIKitConfig.kCancel: 'Cancel',
        UIKitConfig.kLoading: 'Loading...',
      };
      return map[key] ?? key;
    },
  );
  runApp(const MyApp());
}
```

### 2. Basic Usage

#### Button: CommonButton
```dart
CommonButton(
  text: 'Submit',
  onPressed: () => print('Button Tapped'),
  type: ButtonType.filled,
  icon: Icons.send,
)
```

#### Dialog: CommonDialog
```dart
// Confirmation Dialog
final result = await CommonDialog.showConfirm(
  title: 'Delete Notice',
  message: 'Are you sure you want to delete this record?',
);

// Switch/Selection Dialog
CommonDialog.showSwitchDialog(
  title: 'Select Language',
  items: [
    DialogSwitchItem(label: 'Chinese', value: true, onChanged: (v) => {}),
    DialogSwitchItem(label: 'English', value: false, onChanged: (v) => {}),
  ],
);
```

#### Alerts: CommonToast & CommonLoading
```dart
// Show Toast
CommonToast.show('Saved successfully', type: ToastType.success);

// Show/Hide Loading
CommonLoading.show(message: 'Uploading...');
CommonLoading.hide();
```

#### Image: CommonImage
```dart
// Cached Network Image
CommonImage.url('https://example.com/image.jpg', borderRadius: 8)

// SVG Support
CommonImage.asset('assets/icons/logo.svg', width: 40)
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## todo
* demo
