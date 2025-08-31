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

## 🔍 現在のステータス
IlluMefy iOSは活発に開発中です。  
今後のベータリリースに向けてMVP機能が実装されています。

## このアプリで使用されているもの
### 基本情報
IDE: Xcode (Ver 16.2)  
Language: Swift 5 (SwiftGenの互換性問題が解決されるまでSwift 6にはアップデートしない)  
Architecture: Clean Architecture + Router  
Package Manager: SPM (Swift Package Manager)  
Static Analysis: SwiftLint  
CI/CD: GitHub Actions

### Capabilities
* Background Modes
* Push Notifications

### ライブラリ
#### UI
* SwiftUI
* SwiftfulLoadingIndicators
* SwiftUI Shimmer
* WrappingHStack

#### Logic
##### Firebase
* Firebase Authentication
* Firebase Cloud Functions
* Firebase Crashlytics
* Firebase Analytics
* Firebase Storage

##### Resources
* SwiftGen

##### Logic Test
* Quick
* Nimble

##### UI Test
* hogehoge

##### Other
* Combine

### アーキテクチャ
アプリはClean Architecture + Routerパターンに従います：
- **Presentation Layer**: SwiftUIビューとViewModels
- **Domain Layer**: ビジネスロジックとUseCases  
- **Data Layer**: リポジトリとデータソース
- **Base Layer**: 共通プロトコルとユーティリティ