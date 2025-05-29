//
//  FirebaseTestSetup.swift
//  IlluMefyTests
//
//  テスト用のFirebaseセットアップ
//

import Foundation
import FirebaseCore

class FirebaseTestSetup {
    static func configure() {
        // テスト実行時のみFirebaseを初期化
        if FirebaseApp.app() == nil {
            // テスト用の設定でFirebaseを初期化
            let options = FirebaseOptions(googleAppID: "test", gcmSenderID: "test")
            options.projectID = "test-project"
            FirebaseApp.configure(options: options)
        }
    }
}