//
//  GasFreeSponsorError.swift
//  GasFreeSponsor
//
//  Created by mathwallet on 2024/10/21.
//

import Foundation

public enum GasFreeSponsorError: LocalizedError {
    case serverError(code: Int)
    case clientError(code: Int)
    
    public var errorDescription: String? {
        switch self {
        case let .serverError(code: code):
            return "Server error: \(code)"
        case let .clientError(code: code):
            return "Client error: \(code)"
        }
    }
}
