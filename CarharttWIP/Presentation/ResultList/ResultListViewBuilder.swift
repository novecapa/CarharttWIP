//
//  ResultListViewBuilder.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

final class ResultListViewBuilder {
    func build(_ finalItemList: [LikeItem]) -> ResultListView {
        let viewModel = ResultListViewModel(finalItemList: finalItemList)
        let view = ResultListView(viewModel: viewModel)
        return view
    }
}
