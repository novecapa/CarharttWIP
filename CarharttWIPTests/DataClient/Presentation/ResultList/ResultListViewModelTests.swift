//
//  ResultListViewModelTest.swift
//  CarharttWIPTests
//
//  Created by Josep Cerdá Penadés on 27/9/24.
//

import SwiftUI
import XCTest
@testable import CarharttWIP

final class ResultListViewModelTests: XCTestCase {

    enum Constants {
        static let waitText: String = "Wait for it..."
        static let waitSec: CGFloat = 1.5
    }

    var viewModel: ResultListViewModel!

    override func tearDown() {
        viewModel = nil
    }

    func test_view_model_check_items_like() {
        // Given
        // mockItemsLike Has 2 items; 1 like + 1 superlike
        let items: [LikeItem] = .mockItemsLike
        viewModel = ResultListViewModel(finalItemList: items)

        // When
        let likeItems = viewModel.likeItems

        // Then
        XCTAssertEqual(items, likeItems)
    }

    func test_view_model_check_items_random() {
        // Given
        // mockItemsLike Has 3 items; 1 like + 1 superlike + 1 dislike
        let items: [LikeItem] = .mockItemsRandom
        viewModel = ResultListViewModel(finalItemList: items)

        // When
        let likeItems = viewModel.likeItems

        // Then
        XCTAssertEqual(items.filter { $0.like != .disLike }, likeItems)
    }

    func test_view_model_like_menu_options() {
        // Given
        // mockItemsLike Has 3 items; 1 like + 1 superlike + 1 dislike
        let items: [LikeItem] = .mockItemsRandom
        viewModel = ResultListViewModel(finalItemList: items)
        let itemLike: LikeItem = .init(item: .init(title: "", image: ""), like: .like)
        let itemSuperLike: LikeItem = .init(item: .init(title: "", image: ""), like: .superLike)
                                       

        // When
        let menuLike = viewModel.likeMenuOptions(itemLike)
        let menuSuperLike = viewModel.likeMenuOptions(itemSuperLike)
        viewModel.updateValue(itemLike, like: .superLike)
        viewModel.updateValue(itemSuperLike, like: .like)

        // Then
        XCTAssertNotNil(menuLike)
        XCTAssertNotNil(menuSuperLike)
    }
}
