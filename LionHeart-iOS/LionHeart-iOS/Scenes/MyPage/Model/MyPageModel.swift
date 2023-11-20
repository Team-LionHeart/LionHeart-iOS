//
//  MyPageModel.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/14.
//

import Foundation

// MARK: DummyData

enum MyPageSection: String {
    case customerServiceSetion = "고객센터"
    case appSettingSection = "앱 설정"
}

enum MyPageRow: Hashable {
    case customerServiceSetion(section: MyPageSectionModel)
    case appSettingSection(section: MyPageSectionModel)
//
//    static let sectionArray: [MyPageSection] = [.badgeSection,
//                                               .customerServiceSetion(section: MyPageSectionModel(sectionTitle: "고객센터",
//                                                                                                  cellTitle: ["공지사항","FAQ", "1:1 문의", "서비스 피드백", "이용약관", "개인보호 정책"])),
//                                               .appSettingSection(section: MyPageSectionModel(sectionTitle: "앱 설정",
//                                                                                              cellTitle: ["알림 설정", "앱 버전"]))]
    static let customSerive: [MyPageRow] = [.customerServiceSetion(section: .init(cellTitle: "공지사항")), .customerServiceSetion(section: .init(cellTitle: "FAQ")), .customerServiceSetion(section: .init(cellTitle: "1:1문의")), .customerServiceSetion(section: .init(cellTitle: "서비스피드백")), .customerServiceSetion(section: .init(cellTitle: "이용약관")), .customerServiceSetion(section: .init(cellTitle: "개인보호 정책"))]
    static let appSettingService: [MyPageRow] = [.appSettingSection(section: .init(cellTitle: "알림 설정")), .appSettingSection(section: .init(cellTitle: "앱 버전"))]
}

struct MyPageSectionModel: Hashable {
//    let sectionTitle: String
    let cellTitle: String
    
}

// MARK: BadgeProfileAppData

struct BadgeProfileAppData: AppData, Hashable {
    let badgeImage: String
    let nickname: String
    let isAlarm: String
}

extension BadgeProfileAppData {
    static let empty: Self = .init(badgeImage: "", nickname: "", isAlarm: "")
}
