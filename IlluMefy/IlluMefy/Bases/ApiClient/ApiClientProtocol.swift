//
//  ApiClientProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/10.
//
import Alamofire
/// API通信に必要なクライアントプロトコル
///
protocol ApiClientProtocol {
    func makeHeader() async throws -> HTTPHeaders
    func makeEncoding(method: HTTPMethod) -> any ParameterEncoding
    func request<T: Codable>(
        /** エンドポイントURL(ドメイン部分は不要) */
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: Any]?,
        responseType: T.Type,
        isRequiredAuth: Bool
    ) async throws -> T
}
