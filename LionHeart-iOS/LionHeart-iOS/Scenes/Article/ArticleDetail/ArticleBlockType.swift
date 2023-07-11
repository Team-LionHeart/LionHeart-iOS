//
//  ArticleBlockType.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/11.
//

import UIKit

// MARK: - DTO

struct ArticleDetail: Response, DTO {
    let title: String
    let author: String
    let mainImageUrl: String
    let mainImageCaption: String
    let isMarked: Bool
    let contents: [ArticleBlock]
}

struct ArticleBlock: Response, DTO {
    let type: String
    let content: String
    let caption: String?
}

@frozen
enum BlockType: String {
    /// Title
    case generalTitle = "GENERAL_TITLE"
    case chapterTitle = "CHAPTER_TITLE"
    /// Editor
    case editorNote = "EDITOR_NOTE"
    /// Body
    case body = "BODY"
    /// Image
    case image = "IMAGE"
}

// MARK: - AppData

struct ArticleBlockData: AppData {
    let content: String
    let caption: String? // 표제
}

enum BlockTypeAppData {
    // image: String, caption: String?)
    case thumbnail(model: ArticleBlockData)
    // title: String, author: String
    case articleTitle(model: ArticleBlockData)
    // title: String, body: String
    case editorNote(model: ArticleBlockData)
    // title: String
    case chapterTitle(model: ArticleBlockData)
    // body: String, caption: String?
    case body(model: ArticleBlockData)
    // title: String
    case generalTitle(model: ArticleBlockData)
    // content: String, caption: String?
    case image(model: ArticleBlockData)

    var bottomInset: CGFloat {
        switch self {
        case .thumbnail:
            return 22
        case .articleTitle:
            return 60
        case .editorNote:
            return 75
        case .chapterTitle:
            return 36
        case .body:
            return 68
        case .generalTitle:
            return 28
        case .image:
            return 72
        }
    }
}


// MARK: DTO -> AppData

extension ArticleDetail {

    func toAppData() -> [BlockTypeAppData?] {
        let thumbNailModel = ArticleBlockData(content: self.mainImageUrl, caption: self.mainImageCaption)
        let thumbNail = BlockTypeAppData.thumbnail(model: thumbNailModel)

        let titleModel = ArticleBlockData(content: self.title, caption: self.author)
        let title = BlockTypeAppData.articleTitle(model: titleModel)

        var blockTypeDatas: [BlockTypeAppData?] = [
            thumbNail, title
        ]

        self.contents.forEach { articleBlock in
            guard let block = BlockType(rawValue: articleBlock.type) else { return }

            var type: BlockTypeAppData?

            switch block {
            case .generalTitle:
                let generalTitleModel = ArticleBlockData(content: articleBlock.content, caption: nil)
                type = .generalTitle(model: generalTitleModel)
            case .chapterTitle:
                let chapterTitle = ArticleBlockData(content: articleBlock.content, caption: nil)
                type = .chapterTitle(model: chapterTitle)
            case .editorNote:
                guard let caption = articleBlock.caption else { return }
                let editorNote = ArticleBlockData(content: articleBlock.content, caption: caption)
                type = .editorNote(model: editorNote)
            case .body:
                let bodyModel = ArticleBlockData(content: articleBlock.content, caption: articleBlock.caption)
                type = .body(model: bodyModel)
            case .image:
                let imageModel = ArticleBlockData(content: articleBlock.content, caption: articleBlock.caption)
                type = .image(model: imageModel)
            }

            blockTypeDatas.append(type)
        }

        return blockTypeDatas
    }

}


extension ArticleDetail {
    static func dummy() -> ArticleDetail {
        return ArticleDetail(
            title: "출산카드 신청하기 A to Z",
            author: "똑게유아 저자<로리>",
            mainImageUrl: "https://fastly.picsum.photos/id/1015/1000/1000.jpg?hmac=wXOEk3ji7xYdDAiL84drLIJpFh7VuqcFYOpx9LPMos0",
            mainImageCaption: "임신 바우처 신청 모습 copyright/ unsplash",
            isMarked: false,
            contents: [
                .init(type: "EDITOR_NOTE", content: "안녕하세요, 아기사자님!\n라이온하트에서 오늘은 출산카드와 관련된 이야기를 들려드리려고 해요.", caption: "Editor's Note"),
                .init(type: "CHAPTER_TITLE", content: "Chapter 1.\n아빠가 되는 시작,\n임신바우처 신청의 모든 것이\n궁금한 당신께", caption: nil),
                .init(type: "BODY", content: "농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼", caption: nil),
                .init(type: "GENERAL_TITLE", content: "출산카드? 임신바우처를 알려드려요", caption: nil),
                .init(type: "BODY", content: "농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처럼농담처", caption: "* 2023년 7월을 기준으로 총 4개 카드사에서 발급받을 수 있어요!"),
                .init(type: "IMAGE", content: "https://fastly.picsum.photos/id/1015/1000/1000.jpg?hmac=wXOEk3ji7xYdDAiL84drLIJpFh7VuqcFYOpx9LPMos0", caption: "caption copyright"),
            ])
    }
}
