//
//  MyPageRow.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/20.
//

import Foundation

enum MyPageRow: Hashable {
    case customerServiceRow(section: MyPageSectionModel)
    case appSettingRow(section: MyPageSectionModel)
}

extension MyPageRow {
    static let customSerive: [MyPageRow] = [.customerServiceRow(section: .init(cellTitle: "공지사항")), .customerServiceRow(section: .init(cellTitle: "FAQ")), .customerServiceRow(section: .init(cellTitle: "1:1문의")), .customerServiceRow(section: .init(cellTitle: "서비스피드백")), .customerServiceRow(section: .init(cellTitle: "이용약관")), .customerServiceRow(section: .init(cellTitle: "개인보호 정책"))]
    
    static let appSettingService: [MyPageRow] = [.appSettingRow(section: .init(cellTitle: "알림 설정")), .appSettingRow(section: .init(cellTitle: "앱 버전"))]
}
