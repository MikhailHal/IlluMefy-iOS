# IlluMefy iOS

IlluMefyクリエイター発見プラットフォームのiOSアプリケーション。

## このアプリについて
現代のSNSやプラットフォームでは、複数の条件を組み合わせた具体的な検索が困難です。  
IlluMefy iOSは、ユーザーが手動でクリエイターにタグを付けることで、より精密で意味のある検索を実現するモバイルアプリケーションです。  
ユーザー主導のタグ付けシステムは、Bot(IlluMefy-Guardian参照)や運営側による監視・品質管理により、高品質なデータを維持しています。  
SwiftUIとClean Architectureで構築され、コミュニティの知恵を活用した直感的なクリエイター発見体験を提供します。

## 🔍 現在のステータス
IlluMefy iOSは活発に開発中です。  
今後のベータリリースに向けてMVP機能が実装されています。

## このアプリで使用されているもの
### 基本情報
IDE: Xcode (Ver 16.2)  
Language: Swift 5
Architecture: Clean Architecture + Router  
Package Manager: SPM (Swift Package Manager)  
Static Analysis: SwiftLint  
CI: GitHub Actions

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
#### Google Cloud
* Google Cloud reCAPTCHA Enterprise

##### Firebase
* Firebase Authentication
* Firebase Cloud Functions
* Firebase Crashlytics
* Firebase Analytics
* Firebase Firestore
* Firebase AppCheck
* Fireabse RemoteConfig

##### Resources
* SwiftGen

##### 単体テスト
* Quick
* Nimble

##### その他
* Alamofire
* Algolia Search Client
* Swinject

### アーキテクチャ
アプリはClean Architecture + Routerパターンに従います：
- **Presentation Layer**: SwiftUIビューとViewModels
- **Domain Layer**: ビジネスロジックとUseCases  
- **Data Layer**: リポジトリとデータソース
- **Base Layer**: 共通プロトコルとユーティリティ