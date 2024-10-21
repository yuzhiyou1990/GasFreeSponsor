//
//  APIReqeust.swift
//  GasFreeSponsor
//
//  Created by mathwallet on 2024/10/21.
//
import Foundation

public enum APIRequest {
    case isSponsorable(Transaction)
    case getTransactionCount(String, BlockTag)
    case sendRawTransaction(String)
    
    var parameters: [Encodable] {
        switch self {
        case .isSponsorable(let tx):
            return [tx]
        case .getTransactionCount(let address, let blockTag):
            return [address, blockTag]
        case .sendRawTransaction(let rawTx):
            return [rawTx]
        }
    }
    
    public var method: String {
        switch self {
        case .isSponsorable:
            return "pm_isSponsorable"
        case .getTransactionCount:
            return "eth_getTransactionCount"
        case .sendRawTransaction:
            return "eth_sendRawTransaction"
        }
    }
}

extension APIRequest {
    static func setupRequest(for body: RequestBody, with url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body.encodedBody
        return urlRequest
    }
    
    public static func send<Result>(_ method: String, parameters: [Encodable], headers: [String: String] = [:], sponsor: GasFreeSponsor) async throws -> APIResponse<Result> {
        let body = RequestBody(method: method, params: parameters)
        var urlRequest = setupRequest(for: body, with: sponsor.url)
        headers.forEach { k, v in urlRequest.setValue(v, forHTTPHeaderField: k)}
        let (data, _response) = try await sponsor.session.data(for: urlRequest)

        guard let response = _response as? HTTPURLResponse else {
            throw GasFreeSponsorError.clientError(code: -1)
        }
        guard 200 ..< 400 ~= response.statusCode else {
            if 400 ..< 500 ~= response.statusCode {
                throw GasFreeSponsorError.clientError(code: response.statusCode)
            } else {
                throw GasFreeSponsorError.serverError(code: response.statusCode)
            }
        }
        
        return try JSONDecoder().decode(APIResponse<Result>.self, from: data)
    }
}
