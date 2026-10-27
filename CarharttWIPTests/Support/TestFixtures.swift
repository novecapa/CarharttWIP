//
//  TestFixtures.swift
//  CarharttWIPTests
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import Foundation
@testable import CarharttWIP

enum TestFixtures {
    static func items(_ count: Int) -> [Item] {
        (0..<count).map { Item(title: "Product \($0)", image: "https://example.com/\($0).png") }
    }
}

struct StubRepository: InputDataRepositoryProtocol {
    let result: Result<[Item], LocalClientError>
    func getData() async throws -> [Item] { try result.get() }
}

actor ControlledRepository: InputDataRepositoryProtocol {
    private var continuation: CheckedContinuation<[Item], any Error>?
    private var requestWaiter: CheckedContinuation<Void, Never>?
    private(set) var callCount = 0

    func getData() async throws -> [Item] {
        callCount += 1
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            requestWaiter?.resume()
            requestWaiter = nil
        }
    }

    func waitUntilRequested() async {
        guard continuation == nil else { return }
        await withCheckedContinuation { requestWaiter = $0 }
    }

    func complete(with result: Result<[Item], LocalClientError>) {
        continuation?.resume(with: result.mapError { $0 as any Error })
        continuation = nil
    }
}
