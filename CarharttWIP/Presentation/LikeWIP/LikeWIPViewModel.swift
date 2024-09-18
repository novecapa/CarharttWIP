//
//  LikeWIPViewModel.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import SwiftUI

@Observable
final class LikeWIPViewModel {

    private enum Constants {
        static let maxLikeItems: Int = 10
        static let rotationAdjust: CGFloat = 50
        static let swipeAccept: CGFloat = 250
        // Swipe offsets
        static let negativeAdjust: CGFloat = -100
        static let positiveAdjust: CGFloat = 100
        // Animated like icon
        static let frameSizeLikeIcon: CGFloat = 60
        static let paddingLikeIcon: CGFloat = 16
        static let cornerRadiusLikeIcon: CGFloat = 30
        static let scaleEffect2LikeIcon: CGFloat = 0.6
        static let timeToHideLikeIcon: CGFloat = 1.25
    }

    // Item list
    var itemList: [Item] = [] {
        didSet {
            if itemList.isEmpty {
                showProductList.toggle()
            }
        }
    }
    var finalItemList: [LikeItem] = []
    var currentTypeLike: LikeType = .none
    var showProductList: Bool = false
    var showAlert: Bool = false
    var alertError: String = ""

    // Animation
    var showLikeIcon = false
    var angle: Angle = .degrees(0.0)
    var offset: CGSize = .zero
    var taskTimer: Timer?

    private let useCase: InputDataUseCaseProtocol
    init(useCase: InputDataUseCaseProtocol) {
        self.useCase = useCase
    }

    private func handleError(_ error: Error) {
        alertError = error.localizedDescription
        showAlert.toggle()
    }
}
// MARK: Private Methods
private extension LikeWIPViewModel {
    func checkLikeType(_ translation: CGSize) -> LikeType {
        if translation.height < Constants.negativeAdjust {
            return .superLike
        }
        if translation.width < Constants.negativeAdjust &&
            translation.height > Constants.negativeAdjust &&
            translation.height < Constants.positiveAdjust {
            return .disLike
        }
        if translation.width > Constants.positiveAdjust &&
            translation.height > Constants.negativeAdjust &&
            translation.height < Constants.positiveAdjust {
            return .like
        }
        return .none
    }
}
// MARK: Public Methods
extension LikeWIPViewModel {
    func fetchData() {
        Task {
            do {
                itemList = try useCase.getItems().reversed()
            } catch {
                handleError(error)
            }
        }
    }

    func resetData() {
        finalItemList.removeAll()
    }

    var productName: String {
        (itemList.last?.title ?? "").capitalizingFirstLetter()
    }

    var reactionString: String {
        "\("React to".localized()) \(itemList.count) \("articles".localized())"
    }

    func setLikeItem(_ translation: CGSize, item: Item) {
        guard finalItemList.count < Constants.maxLikeItems else { return }
        currentTypeLike = checkLikeType(translation)
        guard currentTypeLike != .none else { return }
        finalItemList.append(
            LikeItem(item: item, like: currentTypeLike)
        )
    }
}
// MARK: Animation methods
extension LikeWIPViewModel {
    func currentOffsetX(_ index: Int) -> CGFloat {
        CGFloat(index == itemList.count - 1 ? offset.width : 0)
    }

    func currentOffsetY(_ index: Int) -> CGFloat {
        CGFloat(index == itemList.count - 1 ? offset.height : 0)
    }

    func currentAngle(_ index: Int) -> Angle {
        index == itemList.count - 1 ? angle : .degrees(0.0)
    }

    func resetOffset() {
        offset = .zero
        angle = .degrees(0.0)
    }

    func setRotation(_ translation: CGSize) {
        let rotationAngle = Angle(radians: Double(translation.width / Constants.rotationAdjust) / Constants.rotationAdjust)
        angle = rotationAngle
        offset = translation
    }

    func setGestureSwipe(_ translation: CGSize,
                         item: Item,
                         index: Int) {
        if abs(translation.width) > Constants.swipeAccept ||
            abs(translation.height) > Constants.swipeAccept {
            setLikeItem(translation, item: item)
            withAnimation(.easeInOut) {
                showLikeIcon = true
                resetOffset()
                itemList.remove(at: index)
                hideLikeIcon()
            }
        }
        resetOffset()
    }

    var imageLikeResult: some View {
        Image(currentTypeLike.rawValue)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(Constants.paddingLikeIcon)
            .background(.white)
            .frame(width: Constants.frameSizeLikeIcon,
                   height: Constants.frameSizeLikeIcon)
            .cornerRadius(Constants.cornerRadiusLikeIcon)
            .scaleEffect(showLikeIcon ? 1.0 : Constants.scaleEffect2LikeIcon)
            .animation(.easeInOut(duration: 1.0), value: showLikeIcon)
            .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
    }

    private func hideLikeIcon() {
        taskTimer?.invalidate()
        taskTimer = Timer.scheduledTimer(withTimeInterval: Constants.timeToHideLikeIcon,
                                         repeats: false) { _ in
            self.showLikeIcon = false
        }
    }
}
