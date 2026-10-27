//
//  LocalClientTests.swift
//  CarharttWIPTests
//
//  Created by Josep Cerdá Penadés on 27/10/26.
//

import Foundation
import Testing
@testable import CarharttWIP

struct LocalClientTests {
    @Test func productionCatalogMapsAndKeepsStableIdentityAcrossLoads() async throws {
        let useCase = AppDependencies.live().inputDataUseCase
        let first = try await useCase.getItems()
        let second = try await useCase.getItems()
        #expect(first.count == 10)
        #expect(first == second)
        #expect(Set(first.map(\.id)).count == first.count)
        #expect(first.first?.title == "OG Detroit Jacket (Winter)")
    }

    @Test func missingResourceHasActionableError() async {
        let client = LocalClient()
        await #expect(throws: LocalClientError.badPath) {
            try await client.getData(type: DataDTO.self, resource: "does-not-exist")
        }
    }

    @Test func realDecoderAcceptsEmptyAndSmallCatalogs() async throws {
        let client = LocalClient(bundle: Bundle(for: TestBundleToken.self))
        let empty = try await client.getData(type: DataDTO.self, resource: "DataEmptyDTO")
        let small = try await client.getData(type: DataDTO.self, resource: "DataLessTahnTenDTO")
        #expect(empty.items.isEmpty)
        #expect(!small.items.isEmpty && small.items.count < 10)
    }

    @Test func invalidJSONReportsDecodeError() async {
        let client = LocalClient(bundle: Bundle(for: TestBundleToken.self))
        await #expect(throws: LocalClientError.decodeError) {
            try await client.getData(type: DataDTO.self, resource: "Malformed")
        }
    }

    @Test func repositoryPropagatesInfrastructureFailure() async {
        let local = InputDataLocal(client: FailingClient())
        let useCase = InputDataUseCase(repository: InputDataRepository(local: local))
        await #expect(throws: LocalClientError.readError) { try await useCase.getItems() }
    }
}

private final class TestBundleToken: NSObject {}

private struct FailingClient: LocalClientProtocol {
    func getData<T: Decodable & Sendable>(type: T.Type, resource: String) async throws -> T {
        throw LocalClientError.readError
    }
}
