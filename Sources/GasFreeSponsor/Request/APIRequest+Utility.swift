//
//  APIRequest+Utility.swift
//  GasFreeSponsor
//
//  Created by mathwallet on 2024/10/21.
//

import Foundation

/// Global counter object to enumerate JSON RPC requests.
public struct Counter {
    nonisolated(unsafe) public static var counter: UInt = 1
    nonisolated(unsafe) public static var lockQueue = DispatchQueue(label: "counterQueue")
    nonisolated(unsafe) public static func increment() -> UInt {
        defer {
            lockQueue.sync {
                Counter.counter += 1
            }
        }
        return counter
    }
}

public struct Transaction: Encodable {
    public var from: String
    public var to: String
    public var value: String
    public var data: String
    public var gas: String
}

public struct Sponsor: Decodable {
    public var sponsorable: Bool
    public var sponsorName: String
    public var sponsorIcon: String?
    public var sponsorWebsite: String?
}

public enum BlockTag: String, Encodable {
    case pending
    case latest
    case `safe`
    case finalized
    case earliest
}

/// JSON RPC response structure for serialization and deserialization purposes.
public struct APIResponse<Result: Decodable>: Decodable{
    public var id: Int
    public var jsonrpc = "2.0"
    public var result: Result
}

struct RequestBody: Encodable {
    var jsonrpc = "2.0"
    var id = Counter.increment()

    var method: String
    var params: [Encodable]

    enum CodingKeys: String, CodingKey {
        case jsonrpc
        case id
        case method
        case params
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jsonrpc, forKey: .jsonrpc)
        try container.encode(id, forKey: .id)
        try container.encode(method, forKey: .method)

        var paramsContainer = container.superEncoder(forKey: .params).unkeyedContainer()
        try params.forEach { a in
            try paramsContainer.encode(a)
        }
    }

    public var encodedBody: Data {
         return try! JSONEncoder().encode(self)
     }
}
