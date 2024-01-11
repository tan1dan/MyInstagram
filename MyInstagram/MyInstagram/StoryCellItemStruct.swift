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
