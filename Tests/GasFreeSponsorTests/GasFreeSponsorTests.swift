import Testing
import Foundation
@testable import GasFreeSponsor

let url = URL(string: "https://bsc-megafuel.nodereal.io")!
nonisolated(unsafe) let gasFreeSponsor = GasFreeSponsor(url, userAgent: "MathWallet/1.0.0")

@Test func getSponsor() async throws {
    let transaction = Transaction(
        from: "0x9971cbb595c067a00669188a6985943a17d30e7d",
        to: "0x55d398326f99059ff775485246999027b3197955",
        value: "0x0",
        data: "0xa9059cbb0000000000000000000000006bfe3a12dc7d4c380477d4f0dc55bd9e2e74db6a000000000000000000000000000000000000000000000000016345785d8a0000",
        gas: "0x0"
    )
    let sponsor = try await gasFreeSponsor.getSponsor(with: transaction)
    debugPrint(sponsor)
}

@Test func getTransactionCount() async throws {
    let address = "0x9971cbb595c067a00669188a6985943a17d30e7d"
    let nonce = try await gasFreeSponsor.getTransactionCount(with: address, blockTag: .pending)
    debugPrint(nonce)
}

