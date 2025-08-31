# IlluMefy iOS

IlluMefyゲーマークリエイター発見プラットフォームのiOSアプリケーション。

## このアプリについて
IlluMefyは、主に効率的にゲーマークリエイター(YouTuber/Streamerなど)を検索するためのアプリです。
現代のSNSやプラットフォームでは、複数の条件を組み合わせた具体的なAND検索(例. #Apex, #関西弁, #プロゲーマー, #レイス専, これら全て満たす検索)が困難です。  
そこで、本アプリではクリエイターに対してユーザー手動orAIによってタグを付けることで、複数の条件を満たすクリエイターを発見するためのアプリです。
また、ユーザーのタグ付けは、Bot(IlluMefy-Guardian)や運営側による監視・品質管理により、高品質なデータを維持しています。(PerspectiveAPI使用)  
現在は、YouTubeのみを対象としてますが今後はTwitch/niconicoなどへ拡大予定です。

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