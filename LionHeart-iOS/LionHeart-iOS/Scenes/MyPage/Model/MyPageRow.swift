//
//  MyPageRow.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/20.
//

import Foundation

enum MyPageRow: Hashable {
    case customerServiceSetion(section: MyPageSectionModel)
    case appSettingSection(section: MyPageSectionModel)
    
    static let customSerive: [MyPageRow] = [.customerServiceSetion(section: .init(cellTitle: "공지사항")), .customerServiceSetion(section: .init(cellTitle: "FAQ")), .customerServiceSetion(section: .init(cellTitle: "1:1문의")), .customerServiceSetion(section: .init(cellTitle: "서비스피드백")), .customerServiceSetion(section: .init(cellTitle: "이용약관")), .customerServiceSetion(section: .init(cellTitle: "개인보호 정책"))]
    static let appSettingService: [MyPageRow] = [.appSettingSection(section: .init(cellTitle: "알림 설정")), .appSettingSection(section: .init(cellTitle: "앱 버전"))]
}
