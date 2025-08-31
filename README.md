# IlluMefy iOS

IlluMefyクリエイター発見プラットフォームのiOSアプリケーション。

## このアプリについて
IlluMefy iOSはクリエイター発見とコミュニティ主導のタグ管理を提供するモバイルアプリケーションです。  
SwiftUIとClean Architectureで構築され、直感的でモダンなユーザーエクスペリエンスを提供します。  
Firebase認証、リアルタイムデータ同期、AIを活用したスマートな検索機能を搭載しています。

## 🌟 主要機能

* **クリエイター発見**: タグベースの高度な検索とフィルタリング
* **お気に入り管理**: パーソナルクリエイターコレクション
* **コミュニティタグ**: ユーザー参加型のタグ編集と管理
* **リアルタイム同期**: 即座のデータ更新とオフライン対応
* **スマート検索**: AI駆動の関連クリエイター推薦
* **ダークモード対応**: システム設定に応じた自動切り替え
* **アクセシビリティ**: VoiceOverとDynamic Type完全対応
* **パフォーマンス最適化**: 画像キャッシングと遅延読み込み

## 🔍 現在のステータス
IlluMefy iOSは活発に開発中です。  
今後のベータリリースに向けてMVP機能が実装されています。

## このアプリで使用されているもの
### 基本情報
Language: Swift 5.9  
Framework: SwiftUI  
Minimum iOS Version: 17.0  
Architecture: Clean Architecture + MVVM  
Dependency Injection: Swinject  
Resource Management: SwiftGen

### サービス・SDK
* Firebase SDK
* Firebase Authentication
* Firebase Firestore
* Firebase Storage
* Firebase Analytics
* Firebase Crashlytics

### ライブラリ
#### UI Framework
* SwiftUI - 宣言的UIフレームワーク

#### アーキテクチャ・依存性注入
* Swinject - Swift用依存性注入コンテナ

#### 非同期処理
* Swift Concurrency - async/awaitとactor model

#### リソース管理
* SwiftGen - 型安全なリソースアクセス生成ツール

#### 開発ツール
* SwiftLint - Swiftコード品質とスタイル管理
* Xcode 15.0+ - 開発環境

### アーキテクチャ
アプリはClean Architecture + MVVMパターンに従います：
- **Presentation Layer**: SwiftUIビューとViewModels
- **Domain Layer**: ビジネスロジックとUseCases  
- **Data Layer**: リポジトリとデータソース
- **Base Layer**: 共通プロトコルとユーティリティ