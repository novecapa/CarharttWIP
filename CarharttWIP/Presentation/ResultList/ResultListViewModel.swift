//
//  ResultListViewModel.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import SwiftUI

@Observable
final class ResultListViewModel {

    enum Constants {
        static let timeToHideToast: CGFloat = 2.5
    }

    var isToast: Bool = false
    private var taskTimer: Timer?

    private var finalItemList: [LikeItem]
    init(finalItemList: [LikeItem]) {
        self.finalItemList = finalItemList
    }
}
extension ResultListViewModel {
    var likeItems: [LikeItem] {
        finalItemList.filter { $0.like != .disLike }
    }

    var titleText: String {
        "\("Final articles list".localized()) (\(likeItems.count)/\(finalItemList.count))"
    }

    func likeMenuOptions(_ item: LikeItem) -> some View {
        return VStack {
            if item.like == .like {
                Button {
                    self.updateValue(item, like: .superLike)
                } label: {
                    Label("Superlike".localized(),
                          image: .superLike)
                }
            } else if item.like == .superLike {
                Button {
                    self.updateValue(item, like: .like)
                } label: {
                    Label("Like".localized(),
                          image: .like)
                }
            }
            Button {
                self.updateValue(item, like: .disLike)
            } label: {
                Label("Delete from list".localized(),
                      image: .disLike)
            }
        }
    }

    func updateValue(_ item: LikeItem, like: LikeType) {
        if let index = finalItemList.firstIndex(of: item) {
            finalItemList[index].like = like
        }
    }

    var showButtonAddCart: Bool {
        !likeItems.isEmpty
    }

    func showAndHideToast() {
        isToast = true
        taskTimer?.invalidate()
        taskTimer = Timer.scheduledTimer(withTimeInterval: Constants.timeToHideToast,
                                         repeats: false) { _ in
            withAnimation {
                self.isToast = false
            }
        }
    }

    var totalProductsAdded: String {
        "\("You added".localized()) \(likeItems.count) \("articles".localized())"
    }
}
