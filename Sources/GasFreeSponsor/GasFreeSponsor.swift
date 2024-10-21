//
//  GasFreeSponsor.swift
//
//
//  Created by mathwallet on 2022/6/29.
//

import Foundation

public class GasFreeSponsor {
    public var url: URL
    public var headers: [String: String]
    public var session: URLSession = {() -> URLSession in
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        let urlSession = URLSession(configuration: config)
        return urlSession
    }()
    
    public init(_ url: URL, userAgent: String) {
        self.url = url
        self.headers = ["User-Agent": userAgent]
    }
    
    public func getSponsor(with transaction: Transaction) async throws -> Sponsor {
        let request = APIRequest.isSponsorable(transaction)
        let result: APIResponse<Sponsor> = try await APIRequest.send(request.method, parameters: request.parameters, headers: self.headers, sponsor: self)
        return result.result
    }
    
    public func getTransactionCount(with address: String, blockTag: BlockTag = .pending) async throws -> String {
        let request = APIRequest.getTransactionCount(address, blockTag)
        let result: APIResponse<String> = try await APIRequest.send(request.method, parameters: request.parameters, headers: self.headers, sponsor: self)
        return result.result
    }
    
    public func sendRawTransaction(with raw: String) async throws -> String {
        let request = APIRequest.sendRawTransaction(raw)
        let result: APIResponse<String> = try await APIRequest.send(request.method, parameters: request.parameters, headers: self.headers, sponsor: self)
        return result.result
    }
}
