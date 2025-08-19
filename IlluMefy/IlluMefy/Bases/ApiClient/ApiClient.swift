//
//  ApiClient.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/10.
//

import Alamofire
import FirebaseAuth

final class ApiClient: ApiClientProtocol {
    /// リクエスト処理
    ///
    /// - parameter T リクエスト型
    /// - parameter endpoint エンドポイントURL
    /// - parameter method メソッド(POST/GETなど)
    /// - parameter parameters API実行時パラメータ
    /// - parameter responseType レスポンスタイプ
    /// - parameter isRequiredAuth 認証必須かどうか
    func request<T>(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: Any]?,
        responseType: T.Type,
        isRequiredAuth: Bool = true
    ) async throws -> T where T: Decodable, T: Encodable {
        // TODO: あとで環境切り替えを行うこと
        let url = "http://192.168.3.8:5001/illumefy-dev/asia-northeast1/api" + endpoint
        var headers: HTTPHeaders = [:]
        if isRequiredAuth { headers = try await makeHeader() }
        let result = try await AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: makeEncoding(method: method),
            headers: headers
        )
        .serializingDecodable(responseType)
        .value
        
        return result
    }
    
    /// ヘッダ作成
    ///
    /// - Returns ヘッダ一覧
    func makeHeader() async throws -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        guard let user = Auth.auth().currentUser else {
            throw APIError.notAuthenticated
        }
        let idToken = try await user.getIDToken()
        headers["Authorization"] = "Bearer \(idToken)"
        return headers
    }
    
    /// エンコーディングの種類を返却
    ///
    /// - Parameter method HTTP操作メソッド
    /// - Returns エンコーディング種類
    func makeEncoding(method: HTTPMethod) -> any ParameterEncoding {
        switch (method) {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
