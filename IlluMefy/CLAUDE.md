# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

IlluMefy は SwiftUI と Clean Architecture を使用して構築されたクリエイター発見 iOS アプリです。Firebase Authentication、Swinject による依存性注入、SwiftGen によるリソース管理を使用しています。

## 必須開発コマンド

### ビルドとテスト
```bash
# プロジェクトビルド（iPhone 16 シミュレーター）
xcodebuild -scheme IlluMefy -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.2' build

# テスト実行
xcodebuild -scheme IlluMefy -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.2' test

# SwiftLint実行（ビルド時に自動実行されるが手動でも可能）
swiftlint lint
```

### リソース生成
```bash
# SwiftGen でリソースファイル生成（文字列とカラーアセット）
/opt/homebrew/bin/swiftgen config run --config swiftgen.yml

# 文字列のみ生成
/opt/homebrew/bin/swiftgen strings IlluMefy/Resources/Localizable.strings --templateName structured-swift5 --output IlluMefy/Generated/Strings.swift --param enumName=L10n
```

## アーキテクチャ

### Clean Architecture の実装

プロジェクトは厳格な Clean Architecture パターンに従います：

**1. Presentation Layer (`Presentations/`)**
- MVVM パターンを実装
- ViewModels は状態管理とビジネスロジックを担当
- Views は宣言的で状態駆動

**2. Domain Layer (`Domain/`)**
- UseCases: 単一のビジネス操作を実装
- Entities: ドメインオブジェクト
- Repository Protocols: データ層の抽象化

**3. Data Layer (`Data/`)**
- Repository implementations
- DataSources (Local/Remote)
- Firebase との統合

**4. Base Layer (`Bases/`)**
- プロトコルとベースクラス
- 共通機能の実装

### 重要な設計パターン

**依存性注入 (Swinject)**
```swift
// DependencyContainer で管理
container.register(RepositoryProtocol.self) { _ in RepositoryImplementation() }
container.register(UseCaseProtocol.self) { resolver in 
    UseCaseImplementation(repository: resolver.resolve(RepositoryProtocol.self)!)
}
```

**プロトコル指向プログラミング**
- すべての主要コンポーネントはプロトコルで定義
- テストとモックを容易にする
- 実装の柔軟な交換を可能にする

## 重要な制約とルール

### 🚨 絶対禁止事項
1. **ハードコードされた文字列**: `Text("ログイン")` ❌ → `Text(L10n.Common.login)` ✅
2. **直接的な値指定**: `.padding(16)` ❌ → `.padding(Spacing.screenEdgePadding)` ✅
3. **既存プレフィックス混用**: 全て `IlluMefy` プレフィックスを使用

### 必須規則
- **文字列**: 必ず `L10n.` 経由でアクセス
- **定数**: `DesignConstants.swift`, `Spacing.swift` の定数を使用
- **色**: `Asset.Color.*` アセットを使用
- **コンポーネント**: `IlluMefy` プレフィックス必須

## 共有UIコンポーネント

### 既存コンポーネント（優先使用）
```swift
// Utilities/Components/ 配下
- IlluMefyButton           // グラデーションボタン
- IlluMefyCardNormal       // カードコンテナ  
- IlluMefyCheckbox         // チェックボックス
- IlluMefyLoadingDialog    // ローディング表示
- IlluMefyPlainTextField   // 通常テキストフィールド
- IlluMefyConfidentialTextField // セキュアテキストフィールド
```

### 新規コンポーネント作成時
- 場所: `/Utilities/Components/[ComponentType]/`
- 命名: 必ず `IlluMefy` プレフィックス
- DependencyContainer への登録必須

## カラーアセット構造

Netflix ライクなデザインを実現するための包括的なカラーアセット：

```swift
Asset.Color.Application.Background.backgroundPrimary   // メイン背景
Asset.Color.CreatorCard.creatorCardBackground         // クリエイターカード
Asset.Color.FeaturedCreatorCard.*                     // ヒーローセクション
Asset.Color.HomeSection.*                             // セクションタイトル
Asset.Color.Navigation.*                              // タブバー
Asset.Color.Tag.*                                     // タグ表示
```

## ビルド関連の注意点

### 一般的なエラーと解決策
1. **SwiftUI type-checking errors**: 複雑なビューを小さなコンポーネントに分解
2. **Color asset エラー**: `Asset.Color.Application.foreground` は存在しない → `textPrimary` を使用
3. **Firebase Auth エラー**: テスト環境では auth チェックをスキップ

### SwiftLint 対応
- Trailing closure rule: Button で action と label を明示
- TODO warnings: 本番前に解決必要

## Firebase 統合

### 認証フロー
```swift
// 認証状態の永続化
Auth.auth().currentUser // 既存ユーザーチェック
// テスト環境での回避処理
guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else { return }
```

## NetflixライクなUI実装

### デザイン原則
- **ダーク背景**: `backgroundPrimary` (#141414系)
- **アクセントカラー**: #00A3B5 (調整済みブランドカラー)
- **階層構造**: カードベースのレイアウト
- **水平スクロール**: セクションごとのコンテンツ表示

### 実装時の重要ポイント
- ライト・ダークモード統一: 各カラーアセットで自動切り替え
- マイクロインタラクション: ホバーエフェクトと選択状態
- レスポンシブデザイン: 様々な画面サイズに対応

## Git ワークフロー

### ブランチ戦略
- 各 issue に対して1つのブランチのみ
- 形式: `claude/issue-N-YYYYMMDD_HHMMSS`
- 派生ブランチは作成しない

### コミット規則
- Conventional commits 使用 (feat:, fix:, refactor:)
- "AI generated" 等のメッセージは含めない
- lint/typecheck 後にコミット

## 今後の開発方針

### 未実装機能 (TODO.md 参照)
1. **高優先度**: 検索画面、お気に入り画面
2. **中優先度**: アカウント画面、設定画面
3. **低優先度**: 各種履歴画面、規約画面

### パフォーマンス考慮
- 大きなリストの仮想化
- 画像の最適化
- ネットワーク効率化
- メモリ管理