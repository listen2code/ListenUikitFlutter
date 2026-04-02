---

# 🇺🇸 English

# Listen UI Kit

A professional, consistent, and highly customizable UI component library for Flutter. Designed to accelerate development by providing a set of standardized widgets that follow Material Design 3 specifications with built-in support for internationalization and themes.

---

## 🎨 Design Philosophy

### Core Principles
- **Consistency**: Unified visual style and interaction patterns across all components.
- **Customizability**: Flexible theming and style configurations for every widget.
- **Internationalization (i18n)**: Built-in support for dynamic text management.
- **Modern Design**: Adheres to Material Design 3.0 guidelines.
- **Developer Friendly**: Clean APIs with comprehensive configuration options.

---

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  listen_uikit: ^0.0.4
  listen_core: ^0.0.4
```

**🔗 Important Links:**
- **Listen Core**: https://pub.dev/packages/listen_core
- **Listen UI Kit**: https://pub.dev/packages/listen_uikit
- **Complete Example App**: https://github.com/listen2code/ListenCoreFlutter

---

## 🚀 Getting Started

### 1. Initialization & Internationalization

Set up the global configuration and inject your translation logic via `UIKitConfig`.

```dart
void main() {
  UIKitConfig.init(
    stringProvider: (key) {
      final map = {
        UIKitConfig.kOk: 'OK',
        UIKitConfig.kCancel: 'Cancel',
        UIKitConfig.kRetry: 'Retry',
      };
      return map[key] ?? key;
    },
  );
  runApp(const MyApp());
}
```

### 2. Basic Usage

#### Button & Toast
```dart
CommonButton.filled(
  text: 'Submit',
  onPressed: () => CommonToast.success('Action Completed'),
  isLoading: false,
)
```

#### Dialogs
```dart
final confirmed = await CommonDialog.showConfirm(
  title: 'Delete Item',
  message: 'Are you sure you want to proceed?',
);
```

#### Images
```dart
CommonImage.url(
  'https://example.com/image.jpg',
  borderRadius: 8.0,
  fit: BoxFit.cover,
)
```

---

## 🧩 Components Documentation

### 1. Basic Components

#### **CommonText**
Standardized text with auto-scaling and theme-aware coloring.

```dart
CommonText(
  'Hello World',
  style: CommonTextStyles.headline1,
  color: Colors.primary,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

#### **CommonImage**
Unified image handling for Assets, Network (cached), Local files, SVG, and GIF.

```dart
// Network Image
CommonImage.url(
  'https://example.com/image.jpg',
  borderRadius: 8.0,
  fit: BoxFit.cover,
  placeholder: (context) => CommonLoading(),
)

// Asset Image
CommonImage.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
)

// SVG Image
CommonImage.svg(
  'assets/icons/icon.svg',
  color: Colors.blue,
  size: 24,
)
```

#### **CommonButton**
Versatile buttons (Filled, Outlined, Text) with built-in loading states and icon support.

```dart
// Filled Button
CommonButton.filled(
  text: 'Submit',
  onPressed: () => print('Pressed'),
  isLoading: false,
  icon: Icons.send,
)

// Outlined Button
CommonButton.outlined(
  text: 'Cancel',
  onPressed: () => print('Cancel'),
)

// Text Button
CommonButton.text(
  text: 'Learn More',
  onPressed: () => print('Learn More'),
)
```

---

### 2. Input Components

#### **CommonTextField**
Form input with labels, validation, and custom styling.

```dart
CommonTextField(
  label: 'Email',
  hint: 'Enter your email',
  controller: _emailController,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Please enter email';
    return null;
  },
  keyboardType: TextInputType.emailAddress,
)
```

#### **CommonSwitch**
Clean, labeled toggle switches with haptic feedback.

```dart
CommonSwitch(
  label: 'Enable Notifications',
  value: _notificationsEnabled,
  onChanged: (value) {
    setState(() => _notificationsEnabled = value);
  },
)
```

---

### 3. Container & Presentation

#### **CommonCard**
Standardized containers with shadow, border, and gesture support.

```dart
CommonCard(
  child: Column(
    children: [
      CommonText('Card Title', style: CommonTextStyles.headline6),
      CommonText('Card content goes here...'),
      CommonButton.filled(
        text: 'Action',
        onPressed: () {},
      ),
    ],
  ),
  elevation: 4,
  margin: EdgeInsets.all(16),
)
```

#### **CommonBadge**
Notification badges for counts or status indicators.

```dart
CommonBadge(
  count: 5,
  child: Icon(Icons.notifications),
)

CommonBadge.dot(
  color: Colors.red,
  child: Icon(Icons.mail),
)
```

#### **CommonChip**
Selectable and deletable tags for filters or labels.

```dart
CommonChip(
  label: 'Flutter',
  onDeleted: () => print('Deleted'),
  selected: true,
  onSelected: (selected) => print('Selected: $selected'),
)
```

#### **CommonListItem**
Standardized row layouts for settings or data lists.

```dart
CommonListItem(
  title: 'Settings',
  subtitle: 'Manage your preferences',
  leading: Icon(Icons.settings),
  trailing: Icon(Icons.chevron_right),
  onTap: () => print('Tapped'),
)
```

#### **CommonDivider**
Standardized divider with customizable thickness and spacing.

```dart
CommonDivider(),
CommonDivider.thick(),
CommonDivider.withSpacing(height: 20),
```

---

### 4. Feedback & Loading

#### **CommonToast**
Global message alerts (Success, Error, Info) with smooth animations.

```dart
CommonToast.success('Operation completed successfully!');
CommonToast.error('Something went wrong');
CommonToast.info('Please check your input');
CommonToast.show('Custom message', type: ToastType.warning);
```

#### **CommonLoading**
Global and inline loading indicators with custom messaging.

```dart
// Global loading overlay
CommonLoading.show(context, message: 'Loading...');
CommonLoading.hide(context);

// Inline loading widget
CommonLoading(
  message: 'Processing...',
  size: LoadingSize.small,
)
```

#### **CommonDialog**
Centralized dialog utility for confirmations, selections, and custom content.

```dart
// Confirmation dialog
final confirmed = await CommonDialog.showConfirm(
  title: 'Delete Item',
  message: 'Are you sure you want to delete this item?',
);

// Alert dialog
CommonDialog.showAlert(
  title: 'Information',
  message: 'Operation completed successfully',
);

// Custom dialog
CommonDialog.show(
  title: 'Custom Dialog',
  content: CommonText('Custom content'),
  actions: [
    CommonButton.text(text: 'Close', onPressed: () => Navigator.pop(context)),
  ],
)
```

#### **CommonSkeleton**
Placeholder animations for content loading states.

```dart
CommonSkeleton(
  height: 100,
  width: double.infinity,
),

CommonSkeleton.avatar(),
CommonSkeleton.text(lines: 3),
```

#### **CommonEmptyView**
Standardized views for "No Data", "Network Error", or "No Results".

```dart
CommonEmptyView.noData(
  message: 'No items found',
  onRetry: () => _loadData(),
),

CommonEmptyView.networkError(
  message: 'Connection failed',
  onRetry: () => _loadData(),
),

CommonEmptyView.noResults(
  message: 'No results found for your search',
)
```

---

### 5. Advanced Components

#### **CommonInkWell**
Customizable ink well with better touch feedback control.

```dart
CommonInkWell(
  onTap: () => print('Tapped'),
  borderRadius: BorderRadius.circular(8),
  child: Container(
    padding: EdgeInsets.all(16),
    child: CommonText('Touchable Area'),
  ),
)
```

#### **CommonRefreshList**
List view with pull-to-refresh functionality.

```dart
CommonRefreshList<String>(
  onRefresh: _loadData,
  itemCount: _items.length,
  itemBuilder: (context, index) {
    return CommonListItem(
      title: _items[index],
      onTap: () => print('Selected: ${_items[index]}'),
    );
  },
)
```

---

## 📊 Component Statistics

| Category | Count | Primary Purpose |
|----------|-------|-----------------|
| Basic | 3 | Text, Image, Button |
| Input | 2 | Forms, Toggles |
| Container | 5 | Layout, Cards, Lists |
| Feedback | 6 | Dialogs, Loading, Toasts |
| Advanced | 2 | Touch, Refresh |
| **Total** | **18** | **Complete UI Solution** |

---

## 🔮 Roadmap
- [ ] Support for advanced charts and data tables.
- [ ] Enhanced animation library for transitions.
- [ ] Theme preset templates (Dark, Light, High Contrast).
- [ ] Visual documentation and component gallery app.

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

---

# 🇨🇳 中文

# Listen UI Kit

一个专业、一致且高度可定制的 Flutter UI 组件库。旨在通过提供遵循 Material Design 3 规范的标准化组件来加速开发，内置国际化和主题支持。

---

## 🎨 设计理念

### 核心原则
- **一致性**: 所有组件的统一视觉风格和交互模式。
- **可定制性**: 每个组件的灵活主题和样式配置。
- **国际化**: 内置动态文本管理支持。
- **现代设计**: 遵循 Material Design 3.0 指南。
- **开发者友好**: 具有全面配置选项的简洁API。

---

## 📦 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  listen_uikit: ^0.0.X
  listen_core: ^0.0.X
```

**🔗 重要链接:**
- **Listen Core**: https://pub.dev/packages/listen_core
- **Listen UI Kit**: https://pub.dev/packages/listen_uikit
- **完整示例应用**: https://github.com/listen2code/ListenCoreFlutter

---

## 🚀 快速开始

### 1. 初始化与国际化

通过 `UIKitConfig` 设置全局配置并注入翻译逻辑。

```dart
void main() {
  UIKitConfig.init(
    stringProvider: (key) {
      final map = {
        UIKitConfig.kOk: '确定',
        UIKitConfig.kCancel: '取消',
        UIKitConfig.kRetry: '重试',
      };
      return map[key] ?? key;
    },
  );
  runApp(const MyApp());
}
```

### 2. 基础使用

#### 按钮与提示
```dart
CommonButton.filled(
  text: '提交',
  onPressed: () => CommonToast.success('操作完成'),
  isLoading: false,
)
```

#### 对话框
```dart
final confirmed = await CommonDialog.showConfirm(
  title: '删除项目',
  message: '确定要继续吗？',
);
```

#### 图片
```dart
CommonImage.url(
  'https://example.com/image.jpg',
  borderRadius: 8.0,
  fit: BoxFit.cover,
)
```

---

## 🧩 组件文档

### 1. 基础组件

#### **CommonText** | 标准文本
标准化文本，具有自动缩放和主题感知颜色功能。

```dart
CommonText(
  '你好世界',
  style: CommonTextStyles.headline1,
  color: Colors.primary,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

#### **CommonImage** | 统一图片处理
统一的图片处理，支持资源、网络（缓存）、本地文件、SVG和GIF。

```dart
// 网络图片
CommonImage.url(
  'https://example.com/image.jpg',
  borderRadius: 8.0,
  fit: BoxFit.cover,
  placeholder: (context) => CommonLoading(),
)

// 本地资源图片
CommonImage.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
)

// SVG 图片
CommonImage.svg(
  'assets/icons/icon.svg',
  color: Colors.blue,
  size: 24,
)
```

#### **CommonButton** | 统一按钮
多功能按钮（填充、轮廓、文本），内置加载状态和图标支持。

```dart
// 填充按钮
CommonButton.filled(
  text: '提交',
  onPressed: () => print('点击'),
  isLoading: false,
  icon: Icons.send,
)

// 轮廓按钮
CommonButton.outlined(
  text: '取消',
  onPressed: () => print('取消'),
)

// 文本按钮
CommonButton.text(
  text: '了解更多',
  onPressed: () => print('了解更多'),
)
```

---

### 2. 输入组件

#### **CommonTextField** | 表单输入
具有标签、验证和自定义样式的表单输入。

```dart
CommonTextField(
  label: '邮箱',
  hint: '请输入邮箱',
  controller: _emailController,
  validator: (value) {
    if (value?.isEmpty ?? true) return '请输入邮箱';
    return null;
  },
  keyboardType: TextInputType.emailAddress,
)
```

#### **CommonSwitch** | 开关切换
整洁的标签切换开关，支持触觉反馈。

```dart
CommonSwitch(
  label: '启用通知',
  value: _notificationsEnabled,
  onChanged: (value) {
    setState(() => _notificationsEnabled = value);
  },
)
```

---

### 3. 容器与展示

#### **CommonCard** | 标准卡片
标准化容器，具有阴影、边框和手势支持。

```dart
CommonCard(
  child: Column(
    children: [
      CommonText('卡片标题', style: CommonTextStyles.headline6),
      CommonText('卡片内容...'),
      CommonButton.filled(
        text: '操作',
        onPressed: () {},
      ),
    ],
  ),
  elevation: 4,
  margin: EdgeInsets.all(16),
)
```

#### **CommonBadge** | 徽章标识
用于计数或状态指示的通知徽章。

```dart
CommonBadge(
  count: 5,
  child: Icon(Icons.notifications),
)

CommonBadge.dot(
  color: Colors.red,
  child: Icon(Icons.mail),
)
```

#### **CommonChip** | 标签选择
用于过滤器或标签的可选择和可删除标签。

```dart
CommonChip(
  label: 'Flutter',
  onDeleted: () => print('删除'),
  selected: true,
  onSelected: (selected) => print('选中: $selected'),
)
```

#### **CommonListItem** | 列表项
用于设置或数据列表的标准化行布局。

```dart
CommonListItem(
  title: '设置',
  subtitle: '管理您的偏好设置',
  leading: Icon(Icons.settings),
  trailing: Icon(Icons.chevron_right),
  onTap: () => print('点击'),
)
```

#### **CommonDivider** | 分割线
标准化分割线，具有可定制的厚度和间距。

```dart
CommonDivider(),
CommonDivider.thick(),
CommonDivider.withSpacing(height: 20),
```

---

### 4. 反馈与加载

#### **CommonToast** | 消息提示
全局消息提醒（成功、错误、信息），具有流畅动画。

```dart
CommonToast.success('操作成功完成！');
CommonToast.error('出现错误');
CommonToast.info('请检查您的输入');
CommonToast.show('自定义消息', type: ToastType.warning);
```

#### **CommonLoading** | 加载指示器
全局和内联加载指示器，具有自定义消息。

```dart
// 全局加载遮罩
CommonLoading.show(context, message: '加载中...');
CommonLoading.hide(context);

// 内联加载组件
CommonLoading(
  message: '处理中...',
  size: LoadingSize.small,
)
```

#### **CommonDialog** | 对话框
用于确认、选择和自定义内容的集中对话框工具。

```dart
// 确认对话框
final confirmed = await CommonDialog.showConfirm(
  title: '删除项目',
  message: '确定要删除这个项目吗？',
);

// 警告对话框
CommonDialog.showAlert(
  title: '信息',
  message: '操作成功完成',
);

// 自定义对话框
CommonDialog.show(
  title: '自定义对话框',
  content: CommonText('自定义内容'),
  actions: [
    CommonButton.text(text: '关闭', onPressed: () => Navigator.pop(context)),
  ],
)
```

#### **CommonSkeleton** | 骨架屏
内容加载状态的占位符动画。

```dart
CommonSkeleton(
  height: 100,
  width: double.infinity,
),

CommonSkeleton.avatar(),
CommonSkeleton.text(lines: 3),
```

#### **CommonEmptyView** | 空状态视图
"无数据"、"网络错误"或"无结果"的标准化视图。

```dart
CommonEmptyView.noData(
  message: '未找到项目',
  onRetry: () => _loadData(),
),

CommonEmptyView.networkError(
  message: '连接失败',
  onRetry: () => _loadData(),
),

CommonEmptyView.noResults(
  message: '未找到搜索结果',
)
```

---

### 5. 高级组件

#### **CommonInkWell** | 水波纹效果
可定制的墨水涟漪，具有更好的触觉反馈控制。

```dart
CommonInkWell(
  onTap: () => print('点击'),
  borderRadius: BorderRadius.circular(8),
  child: Container(
    padding: EdgeInsets.all(16),
    child: CommonText('可触摸区域'),
  ),
)
```

#### **CommonRefreshList** | 下拉刷新
具有下拉刷新功能的列表视图。

```dart
CommonRefreshList<String>(
  onRefresh: _loadData,
  itemCount: _items.length,
  itemBuilder: (context, index) {
    return CommonListItem(
      title: _items[index],
      onTap: () => print('选中: ${_items[index]}'),
    );
  },
)
```

---

## 📊 组件统计

| 类别 | 数量 | 主要用途 |
|------|------|----------|
| 基础 | 3 | 文本、图片、按钮 |
| 输入 | 2 | 表单、开关 |
| 容器 | 5 | 布局、卡片、列表 |
| 反馈 | 6 | 对话框、加载、提示 |
| 高级 | 2 | 触摸、刷新 |
| **总计** | **18** | **完整UI解决方案** |

---

## 🔮 路线图
- [ ] 高级图表和数据表格支持。
- [ ] 增强的过渡动画库。
- [ ] 主题预设模板（深色、浅色、高对比度）。
- [ ] 可视化文档和组件展示应用。

---

## 📄 许可证
本项目采用 MIT 许可证 - 详情请参阅 [LICENSE](LICENSE) 文件。

---

---

# 🇯🇵 日本語

# Listen UI Kit

Flutter用のプロフェッショナルで一貫性があり、高度にカスタマイズ可能なUIコンポーネントライブラリ。Material Design 3仕様に準拠した標準化ウィジェットセットを提供し、国際化とテーマの組み込みサポートにより開発を加速させることを目的としています。

---

## 🎨 デザイン哲学

### コア原則
- **一貫性**: すべてのコンポーネントで統一された視覚スタイルとインタラクションパターン。
- **カスタマイズ性**: すべてのウィジェットの柔軟なテーマとスタイル設定。
- **国際化**: 動的テキスト管理の組み込みサポート。
- **モダンデザイン**: Material Design 3.0ガイドラインに準拠。
- **開発者フレンドリー**: 包括的な設定オプションを持つクリーンなAPI。

---

## 📦 インストール

`pubspec.yaml`に依存関係を追加：

```yaml
dependencies:
  listen_uikit: ^0.0.4
  listen_core: ^0.0.4
```

**🔗 重要なリンク:**
- **Listen Core**: https://pub.dev/packages/listen_core
- **Listen UI Kit**: https://pub.dev/packages/listen_uikit
- **完全なサンプルアプリ**: https://github.com/listen2code/ListenCoreFlutter

---

## 🚀 スタートガイド

### 1. 初期化と国際化

`UIKitConfig`を介してグローバル設定をセットアップし、翻訳ロジックを注入します。

```dart
void main() {
  UIKitConfig.init(
    stringProvider: (key) {
      final map = {
        UIKitConfig.kOk: 'OK',
        UIKitConfig.kCancel: 'キャンセル',
        UIKitConfig.kRetry: '再試行',
      };
      return map[key] ?? key;
    },
  );
  runApp(const MyApp());
}
```

### 2. 基本的な使用方法

#### ボタンとトースト
```dart
CommonButton.filled(
  text: '送信',
  onPressed: () => CommonToast.success('操作が完了しました'),
  isLoading: false,
)
```

#### ダイアログ
```dart
final confirmed = await CommonDialog.showConfirm(
  title: 'アイテムの削除',
  message: '続行してもよろしいですか？',
);
```

#### 画像
```dart
CommonImage.url(
  'https://example.com/image.jpg',
  borderRadius: 8.0,
  fit: BoxFit.cover,
)
```

---

## 🧩 コンポーネントドキュメント

### 1. 基本コンポーネント

#### **CommonText** | 標準テキスト
自動スケーリングとテーマ対応の色付けを備えた標準化されたテキスト。

```dart
CommonText(
  'こんにちは世界',
  style: CommonTextStyles.headline1,
  color: Colors.primary,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

#### **CommonImage** | 統一画像処理
アセット、ネットワーク（キャッシュ）、ローカルファイル、SVG、GIFの統一画像処理。

```dart
// ネットワーク画像
CommonImage.url(
  'https://example.com/image.jpg',
  borderRadius: 8.0,
  fit: BoxFit.cover,
  placeholder: (context) => CommonLoading(),
)

// アセット画像
CommonImage.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
)

// SVG画像
CommonImage.svg(
  'assets/icons/icon.svg',
  color: Colors.blue,
  size: 24,
)
```

#### **CommonButton** | 統一ボタン
読み込み状態とアイコンサポートを内蔵した多機能ボタン（塗りつぶし、アウトライン、テキスト）。

```dart
// 塗りつぶしボタン
CommonButton.filled(
  text: '送信',
  onPressed: () => print('押された'),
  isLoading: false,
  icon: Icons.send,
)

// アウトラインボタン
CommonButton.outlined(
  text: 'キャンセル',
  onPressed: () => print('キャンセル'),
)

// テキストボタン
CommonButton.text(
  text: '詳細を見る',
  onPressed: () => print('詳細を見る'),
)
```

---

### 2. 入力コンポーネント

#### **CommonTextField** | フォーム入力
ラベル、検証、カスタムスタイルを備えたフォーム入力。

```dart
CommonTextField(
  label: 'メール',
  hint: 'メールを入力してください',
  controller: _emailController,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'メールを入力してください';
    return null;
  },
  keyboardType: TextInputType.emailAddress,
)
```

#### **CommonSwitch** | スイッチ
触覚フィードバックを備えたクリーンなラベル付きトグルスイッチ。

```dart
CommonSwitch(
  label: '通知を有効にする',
  value: _notificationsEnabled,
  onChanged: (value) {
    setState(() => _notificationsEnabled = value);
  },
)
```

---

### 3. コンテナと表示

#### **CommonCard** | 標準カード
影、境界線、ジェスチャーサポートを備えた標準化されたコンテナ。

```dart
CommonCard(
  child: Column(
    children: [
      CommonText('カードタイトル', style: CommonTextStyles.headline6),
      CommonText('カードのコンテンツ...'),
      CommonButton.filled(
        text: 'アクション',
        onPressed: () {},
      ),
    ],
  ),
  elevation: 4,
  margin: EdgeInsets.all(16),
)
```

#### **CommonBadge** | バッジ
カウントまたは状態インジケーター用の通知バッジ。

```dart
CommonBadge(
  count: 5,
  child: Icon(Icons.notifications),
)

CommonBadge.dot(
  color: Colors.red,
  child: Icon(Icons.mail),
)
```

#### **CommonChip** | チップ
フィルターまたはラベル用の選択可能および削除可能なタグ。

```dart
CommonChip(
  label: 'Flutter',
  onDeleted: () => print('削除'),
  selected: true,
  onSelected: (selected) => print('選択: $selected'),
)
```

#### **CommonListItem** | リスト項目
設定またはデータリスト用の標準化された行レイアウト。

```dart
CommonListItem(
  title: '設定',
  subtitle: '設定を管理',
  leading: Icon(Icons.settings),
  trailing: Icon(Icons.chevron_right),
  onTap: () => print('タップ'),
)
```

#### **CommonDivider** | 区切り線
カスタマイズ可能な太さと間隔を備えた標準化された区切り線。

```dart
CommonDivider(),
CommonDivider.thick(),
CommonDivider.withSpacing(height: 20),
```

---

### 4. フィードバックと読み込み

#### **CommonToast** | トースト
滑らかなアニメーションを備えたグローバルメッセージアラート（成功、エラー、情報）。

```dart
CommonToast.success('操作が正常に完了しました！');
CommonToast.error('エラーが発生しました');
CommonToast.info('入力を確認してください');
CommonToast.show('カスタムメッセージ', type: ToastType.warning);
```

#### **CommonLoading** | 読み込みインジケーター
カスタムメッセージを備えたグローバルおよびインライン読み込みインジケーター。

```dart
// グローバル読み込みオーバーレイ
CommonLoading.show(context, message: '読み込み中...');
CommonLoading.hide(context);

// インライン読み込みウィジェット
CommonLoading(
  message: '処理中...',
  size: LoadingSize.small,
)
```

#### **CommonDialog** | ダイアログ
確認、選択、カスタムコンテンツ用の中央設定ダイアログユーティリティ。

```dart
// 確認ダイアログ
final confirmed = await CommonDialog.showConfirm(
  title: 'アイテムの削除',
  message: 'このアイテムを削除してもよろしいですか？',
);

// アラートダイアログ
CommonDialog.showAlert(
  title: '情報',
  message: '操作が正常に完了しました',
);

// カスタムダイアログ
CommonDialog.show(
  title: 'カスタムダイアログ',
  content: CommonText('カスタムコンテンツ'),
  actions: [
    CommonButton.text(text: '閉じる', onPressed: () => Navigator.pop(context)),
  ],
)
```

#### **CommonSkeleton** | スケルトン
コンテンツ読み込み状態用のプレースホルダーアニメーション。

```dart
CommonSkeleton(
  height: 100,
  width: double.infinity,
),

CommonSkeleton.avatar(),
CommonSkeleton.text(lines: 3),
```

#### **CommonEmptyView** | 空状態ビュー
「データなし」「ネットワークエラー」「結果なし」用の標準化されたビュー。

```dart
CommonEmptyView.noData(
  message: 'アイテムが見つかりません',
  onRetry: () => _loadData(),
),

CommonEmptyView.networkError(
  message: '接続に失敗しました',
  onRetry: () => _loadData(),
),

CommonEmptyView.noResults(
  message: '検索結果が見つかりませんでした',
)
```

---

### 5. 高度なコンポーネント

#### **CommonInkWell** | インクウェル
より良いタッチフィードバック制御を備えたカスタマイズ可能なインクウェル。

```dart
CommonInkWell(
  onTap: () => print('タップ'),
  borderRadius: BorderRadius.circular(8),
  child: Container(
    padding: EdgeInsets.all(16),
    child: CommonText('タッチ可能な領域'),
  ),
)
```

#### **CommonRefreshList** | プルツーリフレッシュ
プルツーリフレッシュ機能を備えたリストビュー。

```dart
CommonRefreshList<String>(
  onRefresh: _loadData,
  itemCount: _items.length,
  itemBuilder: (context, index) {
    return CommonListItem(
      title: _items[index],
      onTap: () => print('選択: ${_items[index]}'),
    );
  },
)
```

---

## 📊 コンポーネント統計

| カテゴリ | 数量 | 主な目的 |
|----------|-------|-------------|
| 基本 | 3 | テキスト、画像、ボタン |
| 入力 | 2 | フォーム、トグル |
| コンテナ | 5 | レイアウト、カード、リスト |
| フィードバック | 6 | ダイアログ、読み込み、トースト |
| 高度 | 2 | タッチ、リフレッシュ |
| **合計** | **18** | **完全なUIソリューション** |

---

## 🔮 ロードマップ
- [ ] 高度なチャートとデータテーブルのサポート。
- [ ] 遷移用の強化されたアニメーションライブラリ。
- [ ] テーマプリセットテンプレート（ダーク、ライト、ハイコントラスト）。
- [ ] ビジュアルドキュメントとコンポーネントギャラリーアプリ。

---

## 📄 ライセンス
このプロジェクトはMITライセンスの下でライセンスされています - 詳細は[LICENSE](LICENSE)ファイルを参照してください。
