//
//  StoryCellItemStruct.swift
//  MyInstagram
//
//  Created by Иван Знак on 27/12/2023.
//

import UIKit

struct CellItem: Hashable {
    var story: StoryItem?
    var post: PostItem?
    var account: AccountItem?
}

struct PostItem: Hashable {
    var image: UIImage?
    var title: String?
    var likeText: NSMutableAttributedString?
    var bodyText: NSMutableAttributedString?
    var isLiked: Bool
    var isBookmark: Bool
}

struct StoryItem: Hashable {
    var image: UIImage?
    var title: String?
}

struct AccountItem: Hashable {
    var id: String
    var image: UIImage
}
