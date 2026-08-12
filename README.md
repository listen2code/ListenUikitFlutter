# Listen UI Kit

## English

ListenUiKit is the reusable widget layer built on top of `listen_core`.
It focuses on common presentation, input, feedback, and list helpers shared across app modules.
It is not a full design system, app shell, or complete screen solution.

### Links

- [pub.dev](https://pub.dev/packages/listen_uikit)
- [GitHub Repository](https://github.com/listen2code/ListenUikitFlutter)
- [Reference App](https://github.com/listen2code/ListenPortfolioFlutter)

### Positioning

This README prioritizes:

- Current exported widgets and helpers
- Clear package boundaries with `listen_core`
- Honest limitations instead of idealized claims

### Current Package Scope

#### Included today

- `UIKitConfig` for injected strings such as OK / Cancel / Retry / Loading
- Common widgets for text, image, button, divider, inkwell, text field, switch, card, badge, chip, and list items
- Feedback helpers such as `CommonDialog`, `CommonLoading`, `CommonToast`, `CommonSkeleton`, `CommonEmptyView`, and `CommonRefreshList`
- Practical integration with `listen_core` navigation context for overlay and dialog style utilities

#### Not the responsibility of ListenUiKit

- App-specific pages or business widgets
- Theme tokens, semantic color system, or brand-level design strategy
- Application lifecycle, routing, crash management, or networking
- A complete visual documentation site or design system runtime

### Boundary Comparison

| Layer | Primary responsibility | Not responsible for | Typical examples |
|-------|------------------------|---------------------|------------------|
| `ListenCore` | Application infrastructure primitives and runtime foundations | App page composition, reusable visual component set, brand theme strategy | `BaseViewModel`, `ApiClient`, `AppNav`, `ZoneManager` |
| `ListenUiKit` | Reusable presentation, input, and feedback widgets | Lifecycle, networking, crash protection, environment setup | `CommonButton`, `CommonDialog`, `CommonEmptyView` |
| App / shared layer | Business features, page composition, feature-specific flows, product rules | Re-defining generic infrastructure or generic widget packages inside shared libraries | Feature pages, app-specific view models, domain workflows |

### Installation

```yaml
dependencies:
  listen_uikit: ^0.0.32
  listen_core: ^0.0.51
```

### Getting Started

Initialize shared strings through `UIKitConfig`:

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

If you use `CommonDialog` or `CommonLoading`, make sure your app has already set up the navigation context from `listen_core`.

### Exported Widget Map

- Basic: `CommonText`, `CommonImage`, `CommonAvatar`, `CommonButton`, `CommonIconButton`, `CommonClickable`, `CommonDivider`
- Input: `CommonTextField`, `CommonSwitch`
- Container / Presentation: `CommonCard`, `CommonBadge`, `CommonChip`, `CommonListItem`, `CommonWebView`
- Feedback: `CommonToast`, `CommonLoading`, `CommonDialog`, `CommonBottomSheet`, `CommonSkeleton`, `CommonEmptyView`, `CommonRefreshList`
- Media: `CommonImageCropper`, `CommonImagePreview`

### CommonWebView Usage

A commercial-grade WebView wrapper based on `flutter_inappwebview`. It supports:
- Fullscreen page style (with system AppBar) or inline layout (embedded into any parent layout).
- Custom progress bar, pull-to-refresh, and customized retry error screen (`CommonEmptyView`).
- **Auto-height Adaptation (`shrinkWrap` mode)**: Easily display inside dialogs (e.g. `CommonDialog.showCustom`), sensing actual HTML height dynamically via `ResizeObserver` and setting scrollbars when hitting maximum constraints.
- **Advanced Navigation Interception**: Differentiate between user-clicked link navigation and client-side programmatic redirects using `shouldOverrideUrlLoadingWithAction` and the gesture properties in `NavigationAction`.

### CommonIconButton / CommonButton Usage

Both `CommonButton` and `CommonIconButton` support built-in debouncing, haptic feedback, and loading indicators:
- **Debouncing**: Prevents rapid double-tapping based on a configurable `debounceDuration` (defaulting to 500ms).
- **Haptic Feedback**: Triggers native micro-vibrations upon tap when `useHaptic` is enabled (defaulting to true).
- **Loading State**: Displays a `CircularProgressIndicator` inside the button and disables interaction automatically when `isLoading` is set to true.

`CommonIconButton` supports three button styles via `IconButtonType`:
- `IconButtonType.plain`: Transparent background, icon-only style.
- `IconButtonType.filled`: Solid background using primary color.
- `IconButtonType.outlined`: Outlined border around the icon.

### Current Limitations

- Some utilities such as `CommonDialog` and `CommonLoading` depend on `listen_core` navigation context.
- The package does not yet provide a standalone theme token system or preset themes.
- It focuses on common reusable widgets, not complex data-dense components.
- Detailed examples should follow the actual exported API in code.

### Target State

- Add clearer theme token and preset layering without pushing app-specific branding into the package
- Provide a dedicated gallery and visual docs app
- Expand higher-level reusable widgets only when they remain business-agnostic

### Pending Cleanup Backup

- Older README versions described this package as a complete UI solution.
- Older README versions mixed current widgets with aspirational theme, gallery, and design-system claims.
- The current document intentionally narrows the narrative to what is already exported and reusable today.

---

## 中文

ListenUiKit 是建立在 `listen_core` 之上的可复用组件层。
它当前聚焦于通用展示、输入、反馈和列表辅助组件，而不是完整设计系统、App 壳层或整页解决方案。

### 链接

- [pub.dev](https://pub.dev/packages/listen_uikit)
- [GitHub 仓库](https://github.com/listen2code/ListenUikitFlutter)
- [参考应用](https://github.com/listen2code/ListenPortfolioFlutter)

### 定位

本 README 优先强调：

- 当前已经导出的组件与辅助能力
- 与 `listen_core` 的清晰边界
- 当前限制，而不是理想化表述

### 当前包范围

#### 已包含

- `UIKitConfig`：注入 OK / Cancel / Retry / Loading 等通用文案
- 通用文本、图片、按钮、分割线、点击容器、文本输入、开关、卡片、徽标、标签、列表项等组件
- `CommonDialog`、`CommonLoading`、`CommonToast`、`CommonSkeleton`、`CommonEmptyView`、`CommonRefreshList` 等反馈辅助能力
- 与 `listen_core` 导航上下文配合的 overlay 和 dialog 类工具

#### 不属于 ListenUiKit 的职责

- App 专属页面或业务组件
- 主题 token、语义色体系或品牌设计策略
- 应用生命周期、路由、崩溃保护或网络基础设施
- 完整的可视化组件站点或设计系统运行时

### 模块边界对照

| 层级 | 主要职责 | 不负责什么 | 典型示例 |
|------|----------|------------|----------|
| `ListenCore` | 应用基础设施原语与运行时底座 | 页面组装、可复用视觉组件集、品牌主题策略 | `BaseViewModel`、`ApiClient`、`AppNav`、`ZoneManager` |
| `ListenUiKit` | 可复用展示、输入、反馈组件 | 生命周期、网络、崩溃保护、环境初始化 | `CommonButton`、`CommonDialog`、`CommonEmptyView` |
| App / shared 层 | 业务功能、页面组装、特性流程、产品规则 | 在共享库中重新定义通用基础设施或通用组件包 | 功能页面、App 专属 ViewModel、领域流程编排 |

### 安装

```yaml
dependencies:
  listen_uikit: ^0.0.32
  listen_core: ^0.0.51
```

### 快速开始

通过 `UIKitConfig` 注入通用文案：

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

如果你要使用 `CommonDialog` 或 `CommonLoading`，请先确保应用已经完成 `listen_core` 提供的导航上下文配置。

### 导出组件概览

- 基础类：`CommonText`、`CommonImage`、`CommonAvatar`、`CommonButton`、`CommonIconButton`、`CommonClickable`、`CommonDivider`
- 输入类：`CommonTextField`、`CommonSwitch`
- 容器 / 展示类：`CommonCard`、`CommonBadge`、`CommonChip`、`CommonListItem`、`CommonWebView`
- 反馈类：`CommonToast`、`CommonLoading`、`CommonDialog`、`CommonBottomSheet`、`CommonSkeleton`、`CommonEmptyView`、`CommonRefreshList`
- 媒体类：`CommonImageCropper`、`CommonImagePreview`

### CommonWebView 使用指南

基于 `flutter_inappwebview` 封装的商用级 WebView。主要特点：
- 全屏页面模式（内置导航栏）与嵌入式布局（可作为普通 Widget 嵌入任何画面）。
- 自定义进度条、下拉刷新以及美观的错误重试兜底页（`CommonEmptyView`）。
- **高度自适应（`shrinkWrap` 模式）**：适用于弹窗（如 `CommonDialog.showCustom`），通过 `ResizeObserver` 自动计算并适配网页真实高度，达到最大高度限制时自动显现滚动条。
- **高级跳转拦截**：通过 `shouldOverrideUrlLoadingWithAction` 回调，结合手势标志位，精准区分用户手动点击触发的跳转与 HTML 内部脚本重定向跳转。

### CommonIconButton / CommonButton 使用指南

`CommonButton` 与 `CommonIconButton` 均内置了防抖保护、触觉反馈以及加载状态指示：
- **防抖保护 (Bounce)**：基于可配置的 `debounceDuration`（默认 500ms）自动拦截快速连续的重复点击。
- **触觉反馈 (Haptic)**：开启 `useHaptic`（默认 true）时，轻触按钮即可触发原生微弱的震动。
- **加载状态 (Loading)**：将 `isLoading` 设为 true 时，按钮会自动置灰禁止交互，并在中心渲染 `CircularProgressIndicator` 进度环。

`CommonIconButton` 支持三种样式类型：
- `IconButtonType.plain`：透明背景的纯图标形式。
- `IconButtonType.filled`：实色背景（默认主题 primary 色）。
- `IconButtonType.outlined`：带描边线框的图标按钮。

### 当前限制

- `CommonDialog`、`CommonLoading` 等部分能力依赖 `listen_core` 的导航上下文。
- 目前没有独立的 theme token 系统或预置主题方案。
- 当前定位是通用可复用组件，不覆盖复杂数据密集型组件。
- 详细示例应以代码中真实导出的 API 为准。

### 目标态

- 在不引入 App 专属品牌逻辑的前提下，补充更清晰的主题 token 与 preset 分层
- 提供独立的 gallery 与可视化文档应用
- 只在保持业务无关前提下扩展更高层的可复用组件

### 待删除备份区

- 旧版 README 曾把该包描述成完整 UI 解决方案。
- 旧版 README 混合了当前组件与尚未落地的主题、画廊、设计系统叙事。
- 当前文档刻意收窄为今天已经真实导出、可复用的能力。

---

## 日本語

ListenUiKit は `listen_core` の上に構築された再利用可能なウィジェット層です。
現時点では共通の表示、入力、フィードバック、リスト補助ウィジェットに焦点を当てており、完全なデザインシステム、App シェル、画面全体の解決策ではありません。

### リンク

- [pub.dev](https://pub.dev/packages/listen_uikit)
- [GitHub リポジトリ](https://github.com/listen2code/ListenUikitFlutter)
- [参照アプリ](https://github.com/listen2code/ListenPortfolioFlutter)

### 位置づけ

この README では次を優先します：

- 現在エクスポートされているウィジェットと補助機能
- `listen_core` との明確な境界
- 理想化ではなく、現在の制約を正直に書くこと

### 現在のパッケージ範囲

#### 現在含まれるもの

- `UIKitConfig`：OK / Cancel / Retry / Loading などの共通文字列注入
- テキスト、画像、ボタン、区切り線、タップ領域、テキスト入力、スイッチ、カード、バッジ、チップ、リスト項目などの共通ウィジェット
- `CommonDialog`、`CommonLoading`、`CommonToast`、`CommonSkeleton`、`CommonEmptyView`、`CommonRefreshList` などのフィードバック補助
- `listen_core` のナビゲーションコンテキストと連携する overlay と dialog 系ユーティリティ

#### ListenUiKit の責務ではないもの

- App 固有ページやビジネスウィジェット
- テーマ token、セマンティックカラー体系、ブランド設計戦略
- アプリのライフサイクル、ルーティング、クラッシュ保護、ネットワーク基盤
- 完全なビジュアルドキュメントサイトやデザインシステム実行基盤

### 境界比較

| レイヤー | 主な責務 | 責務ではないもの | 代表例 |
|----------|----------|------------------|--------|
| `ListenCore` | アプリ基盤のプリミティブと実行時基盤 | 画面構成、再利用 UI 部品集、ブランドテーマ戦略 | `BaseViewModel`、`ApiClient`、`AppNav`、`ZoneManager` |
| `ListenUiKit` | 再利用可能な表示・入力・フィードバック部品 | ライフサイクル、ネットワーク、クラッシュ保護、環境初期化 | `CommonButton`、`CommonDialog`、`CommonEmptyView` |
| App / shared レイヤー | ビジネス機能、画面構成、機能フロー、プロダクトルール | 共通ライブラリ内で汎用基盤や汎用 UI パッケージを再定義すること | 機能ページ、App 固有 ViewModel、ドメインフロー |

### インストール

```yaml
dependencies:
  listen_uikit: ^0.0.32
  listen_core: ^0.0.51
```

### スタートガイド

共通文字列は `UIKitConfig` から注入します：

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

`CommonDialog` や `CommonLoading` を使う場合は、先に `listen_core` のナビゲーションコンテキスト設定が完了している必要があります。

### 主要コンポーネント

- 基本：`CommonText`、`CommonImage`、`CommonAvatar`、`CommonButton`、`CommonIconButton`、`CommonClickable`、`CommonDivider`
- 入力：`CommonTextField`、`CommonSwitch`
- コンテナ / 表示：`CommonCard`、`CommonBadge`、`CommonChip`、`CommonListItem`、`CommonWebView`
- フィードバック：`CommonToast`、`CommonLoading`、`CommonDialog`、`CommonBottomSheet`、`CommonSkeleton`、`CommonEmptyView`、`CommonRefreshList`
- メディア：`CommonImageCropper`、`CommonImagePreview`

### CommonWebView の使用方法

`flutter_inappwebview` に基づく商用グレードの WebView ラッパー。以下をサポート：
- フルスクリーンページ（内置ナビゲーションバー）またはインラインレイアウト（ウィジェットとして任意の画面に埋め込み可能）。
- カスタム進行状況バー、プルダウン更新、および美しくデザインされたエラーリトライ画面（`CommonEmptyView`）。
- **高さ自動調整（`shrinkWrap` モード）**：ダイアログ（例：`CommonDialog.showCustom`）などでの埋め込みに最適。`ResizeObserver` を介してコンテンツの長さを動的に検知・調整し、最大高さ制限に達すると自動的にスクロールバーを表示。
- **高度な遷移制御**：`shouldOverrideUrlLoadingWithAction` コールバックとジェスチャー判定を利用し、ユーザーのタップによる遷移か、HTML 内部の自動/リダイレクトによる遷移かを正確に識別。

### CommonIconButton / CommonButton の使用方法

`CommonButton` と `CommonIconButton` は、どちらもクリック防抖（重複防止）、触覚フィードバック、およびローディングインジケータを標準でサポートしています：
- **防抖処理 (Debounce)**：設定可能な `debounceDuration`（デフォルト 500ms）に基づいて、短時間での高速ダブルタップを自動で防止します。
- **触覚フィードバック (Haptic)**：`useHaptic`（デフォルト true）が有効な場合、タップ時にネイティブのマイクロバイブレーションを発生させます。
- **ローディング状態 (Loading)**：`isLoading` を true に設定すると、ボタンが自動的に無効化され、中央に `CircularProgressIndicator` を表示します。

`CommonIconButton` は `IconButtonType` を通じて3つのボタンスタイルをサポートします：
- `IconButtonType.plain`：透明な背景、アイコンのみのスタイル。
- `IconButtonType.filled`：プライマリカラーを使用した塗りつぶし背景。
- `IconButtonType.outlined`：アイコンの周囲にアウトライン枠線を表示。

### 現在の制約

- `CommonDialog` や `CommonLoading` など一部機能は `listen_core` のナビゲーションコンテキストに依存します。
- 独立した theme token システムやプリセットテーマはまだありません。
- 現在の焦点は共通再利用ウィジェットであり、複雑でデータ密度の高い部品群までは含みません。
- 詳細例はコード中の実際の API を優先してください。

### 目標状態

- App 固有のブランドロジックを持ち込まずに、より明確な theme token と preset レイヤーを追加する
- 独立した gallery とビジュアルドキュメントアプリを用意する
- ビジネス非依存を維持できる範囲でのみ、高レベルな再利用部品を拡張する

### 保留中のバックアップ

- 以前の README では、このパッケージを完全な UI ソリューションと表現していました。
- 以前の README では、現在の実装と未実装のテーマ、ギャラリー、デザインシステム構想が混在していました。
- 現在の文書は、今すでにエクスポートされている再利用可能な能力に絞っています。

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
