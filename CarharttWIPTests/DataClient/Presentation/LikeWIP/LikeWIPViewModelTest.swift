//
//  LikeWIPViewModelTest.swift
//  CarharttWIPTests
//
//  Created by Josep Cerdá Penadés on 19/9/24.
//

import SwiftUI
import XCTest
@testable import CarharttWIP

final class LikeWIPViewModelTest: XCTestCase {

    enum Constants {
        static let waitText: String = "Wait for it..."
        static let waitSec: CGFloat = 1.5
    }

    var localClient: LocalClientProtocol!
    var dataLocal: InputDataLocalProtocol!
    var repository: InputDataRepositoryProtocol!
    var useCase: InputDataUseCaseProtocol!
    var viewModel: LikeWIPViewModel!

    override func tearDown() {
        localClient = nil
        dataLocal = nil
        repository = nil
        useCase = nil
        viewModel = nil
    }

    func test_view_model_fetch_products_almost_ten() {
        // Given
        localClient = LocalClientTest()
        dataLocal = InputDataLocal(client: localClient)
        repository = InputDataRepository(local: dataLocal)
        useCase = InputDataUseCase(repository: repository)
        viewModel = LikeWIPViewModel(useCase: useCase)

        // When
        viewModel.fetchData()

        // Then
        let expectation = XCTestExpectation(description: Constants.waitText)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
            XCTAssertGreaterThan(self.viewModel.itemList.count, 9)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Constants.waitSec)
    }

    func test_view_model_fetch_products_less_than_ten() {
        // Given
        localClient = LocalClientLessThanTenTest()
        dataLocal = InputDataLocal(client: localClient)
        repository = InputDataRepository(local: dataLocal)
        useCase = InputDataUseCase(repository: repository)
        viewModel = LikeWIPViewModel(useCase: useCase)
        
        // When
        viewModel.fetchData()

        // Then
        let expectation = XCTestExpectation(description: Constants.waitText)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
            XCTAssertLessThan(self.viewModel.itemList.count, 10)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Constants.waitSec)
    }

    func test_view_model_fetch_products_empty() {
        // Given
        localClient = LocalClientEmptyTest()
        dataLocal = InputDataLocal(client: localClient)
        repository = InputDataRepository(local: dataLocal)
        useCase = InputDataUseCase(repository: repository)
        viewModel = LikeWIPViewModel(useCase: useCase)
        
        // When
        viewModel.fetchData()

        // Then
        let expectation = XCTestExpectation(description: Constants.waitText)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
            XCTAssertEqual(self.viewModel.itemList.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Constants.waitSec)
    }

    func test_view_model_fetch_products_bad_path() {
        // Given
        localClient = LocalClientBadPathTest()
        dataLocal = InputDataLocal(client: localClient)
        repository = InputDataRepository(local: dataLocal)
        useCase = InputDataUseCase(repository: repository)
        viewModel = LikeWIPViewModel(useCase: useCase)
        
        // When
        viewModel.fetchData()

        // Then
        let expectation = XCTestExpectation(description: Constants.waitText)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
            XCTAssertEqual(self.viewModel.itemList.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Constants.waitSec)
    }

    // MARK: Test add to like list
    func test_add_item_to_products_like_list() {
        // Given
        localClient = LocalClientTest()
        dataLocal = InputDataLocal(client: localClient)
        repository = InputDataRepository(local: dataLocal)
        useCase = InputDataUseCase(repository: repository)
        viewModel = LikeWIPViewModel(useCase: useCase)

        // When
        viewModel.fetchData()

        let superLikeTranslation = CGSize(width: 0, height: -400)
        viewModel.setLikeItem(superLikeTranslation, item: .init(title: "", image: ""))
    
        let disLikeTranslation = CGSize(width: -200, height: 0)
        viewModel.setLikeItem(disLikeTranslation, item: .init(title: "", image: ""))

        let likeTranslation = CGSize(width: 200, height: 0)
        viewModel.setLikeItem(likeTranslation, item: .init(title: "", image: ""))

        let noneTranslation = CGSize(width: 0, height: 0)
        viewModel.setLikeItem(noneTranslation, item: .init(title: "", image: ""))

        viewModel.resetOffset()
        let extpectedItemsCounr = 3
    
        // Then
        let expectation = XCTestExpectation(description: Constants.waitText)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
            XCTAssertEqual(self.viewModel.finalItemList.count, extpectedItemsCounr)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Constants.waitSec)
    }

    func test_current_offset_XY_not_zero() {
        // Given
        localClient = LocalClientTest()
        dataLocal = InputDataLocal(client: localClient)
        repository = InputDataRepository(local: dataLocal)
        useCase = InputDataUseCase(repository: repository)
        viewModel = LikeWIPViewModel(useCase: useCase)

        // When
        viewModel.fetchData()

        let expedtedOffset = CGSize(width: 10, height: 10)
        viewModel.offset = expedtedOffset

        // We have the item list complete
        // In that case, index is the first product (reversed)
        let currentIndex = 9

        let expectation = XCTestExpectation(description: Constants.waitText)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
            XCTAssertEqual(self.viewModel.currentOffsetX(currentIndex), expedtedOffset.width)
            XCTAssertEqual(self.viewModel.currentOffsetX(currentIndex), expedtedOffset.height)
            XCTAssertEqual(self.viewModel.currentOffsetY(currentIndex), expedtedOffset.width)
            XCTAssertEqual(self.viewModel.currentOffsetY(currentIndex), expedtedOffset.height)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Constants.waitSec)
    }

    func test_current_offset_XY_zero() {
        // Given
        localClient = LocalClientTest()
        dataLocal = InputDataLocal(client: localClient)
        repository = InputDataRepository(local: dataLocal)
        useCase = InputDataUseCase(repository: repository)
        viewModel = LikeWIPViewModel(useCase: useCase)

        // When
        viewModel.fetchData()

        let expedtedOffset = CGSize(width: 10, height: 10)
        viewModel.offset = expedtedOffset

        // To check offset = .zero
        // index must be 0
        let currentIndex = 1

        let expectation = XCTestExpectation(description: Constants.waitText)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
            XCTAssertLessThan(self.viewModel.currentOffsetX(currentIndex), expedtedOffset.width)
            XCTAssertLessThan(self.viewModel.currentOffsetX(currentIndex), expedtedOffset.height)
            XCTAssertLessThan(self.viewModel.currentOffsetY(currentIndex), expedtedOffset.width)
            XCTAssertLessThan(self.viewModel.currentOffsetY(currentIndex), expedtedOffset.height)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Constants.waitSec)
    }

    func test_current_angle_not_zero() {
        // Given
        localClient = LocalClientTest()
        dataLocal = InputDataLocal(client: localClient)
        repository = InputDataRepository(local: dataLocal)
        useCase = InputDataUseCase(repository: repository)
        viewModel = LikeWIPViewModel(useCase: useCase)

        // When
        viewModel.fetchData()

        let expedtedAngle: Angle = .degrees(10.0)
        viewModel.angle = expedtedAngle

        // We have the item list complete
        // In that case, index is the first product (reversed)
        let currentIndex = 9

        let expectation = XCTestExpectation(description: Constants.waitText)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
            XCTAssertEqual(self.viewModel.currentAngle(currentIndex), expedtedAngle)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Constants.waitSec)
    }

    func test_current_angle_zero() {
        // Given
        localClient = LocalClientTest()
        dataLocal = InputDataLocal(client: localClient)
        repository = InputDataRepository(local: dataLocal)
        useCase = InputDataUseCase(repository: repository)
        viewModel = LikeWIPViewModel(useCase: useCase)

        // When
        viewModel.fetchData()

        let expedtedAngle: Angle = .degrees(10.0)
        viewModel.angle = expedtedAngle

        // We have the item list complete
        // In that case, index is the first product (reversed)
        let currentIndex = 1

        let expectation = XCTestExpectation(description: Constants.waitText)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitSec) {
            XCTAssertLessThan(self.viewModel.currentAngle(currentIndex), expedtedAngle)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: Constants.waitSec)
    }

    func test_image_like() {
        // Given
        localClient = LocalClientTest()
        dataLocal = InputDataLocal(client: localClient)
        repository = InputDataRepository(local: dataLocal)
        useCase = InputDataUseCase(repository: repository)
        viewModel = LikeWIPViewModel(useCase: useCase)

        // When
        viewModel.fetchData()
        viewModel.currentTypeLike = .superLike

        let expectedImage = viewModel.imageLikeResult

        // Then
        XCTAssertNotNil(expectedImage)
    }
}
