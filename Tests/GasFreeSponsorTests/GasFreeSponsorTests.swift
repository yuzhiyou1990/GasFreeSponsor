import Testing
import Foundation
@testable import GasFreeSponsor

let url = URL(string: "https://bsc-megafuel.nodereal.io")!
nonisolated(unsafe) let gasFreeSponsor = GasFreeSponsor(url, userAgent: "MathWallet/1.0.0")

@Test func getSponsor() async throws {
    let transaction = Transaction(
        from: "0x306Bb8081C7dD356eA951795Ce4072e6e4bFdC32",
        to: "0x588fAac6b3aa91bb4cD8127Ab357515716541f1B",
        value: "0xedb805ef91655",
        data: "0x",
        gas: "0x5208"
    )
    let sponsor = try await gasFreeSponsor.getSponsor(with: transaction)
    debugPrint(sponsor)
}

@Test func getTransactionCount() async throws {
    let address = "0x9971cbb595c067a00669188a6985943a17d30e7d"
    let nonce = try await gasFreeSponsor.getTransactionCount(with: address, blockTag: .pending)
    debugPrint(nonce)
}

