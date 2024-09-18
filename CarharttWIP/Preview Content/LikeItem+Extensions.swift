//
//  LikeItem+Extensions.swift
//  CarharttWIP
//
//  Created by Josep Cerdá Penadés on 18/9/24.
//

import Foundation

// MARK: Mock data
extension Array where Element == LikeItem {
    static let mockItemsLike: [LikeItem] = [
        LikeItem(item: Item(title: "OG Detroit Jacket (Winter)",
                            image: "https://cdn.media.amplience.net/i/carhartt_wip/I027358_00E_3K-OF-01/og-detroit-jacket-black-black-aged-canvas-1464.png?$pdp_03_zoom$"),
                 like: .like),
        LikeItem(item: Item(title: "S/S American Script T-Shirt",
                            image: "https://cdn.media.amplience.net/i/carhartt_wip/I029956_02_XX-OF-01/s-s-american-script-t-shirt-white-44.png?$pdp_03_zoom$"),
                 like: .superLike)
    ]

    static let mockItemsRandom: [LikeItem] = [
        LikeItem(item: Item(title: "OG Detroit Jacket (Winter)",
                            image: "https://cdn.media.amplience.net/i/carhartt_wip/I027358_00E_3K-OF-01/og-detroit-jacket-black-black-aged-canvas-1464.png?$pdp_03_zoom$"),
                 like: .like),
        LikeItem(item: Item(title: "S/S American Script T-Shirt",
                            image: "https://cdn.media.amplience.net/i/carhartt_wip/I029956_02_XX-OF-01/s-s-american-script-t-shirt-white-44.png?$pdp_03_zoom$"),
                 like: .superLike),
        LikeItem(item: Item(title: "W' S/S Pocket T-Shirt",
                            image: "https://cdn.media.amplience.net/i/carhartt_wip/I032215_29N_XX-OF-01/w-s-s-pocket-t-shirt-duck-green-854.png?$pdp_03_zoom$"),
                 like: .disLike)
    ]
}
