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
        method: Alamofire.HTTPMethod,
        parameters: [String : Any]?,
        responseType: T.Type,
        isRequiredAuth: Bool = true
    ) async throws -> T where T : Decodable, T : Encodable {
        // TODO: あとで環境切り替えを行うこと
        let url = "http://127.0.0.1:5001/illumefy-dev/asia-northeast1/api" + endpoint
        var headers: HTTPHeaders = [:]
        if isRequiredAuth { headers = try await makeHeader() }
        return try await AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
            headers: headers)
            .serializingDecodable(responseType)
            .value
    }
    
    func makeHeader() async throws -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        guard let user = Auth.auth().currentUser else {
            throw APIError.notAuthenticated
        }
        let idToken = try await user.getIDToken()
        headers["Authorization"] = "Bearer \(idToken)"
        return headers
    }
}
