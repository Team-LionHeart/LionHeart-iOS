//
//  MyPageModel.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/14.
//

import Foundation

// MARK: DummyData

struct MyPageAppData: AppData {
    let badgeImage: String
    let nickname: String
    let isAlarm: String
}

extension MyPageAppData {
    static let empty: Self = .init(badgeImage: "", nickname: "", isAlarm: "")
}

// MARK: LocalData

struct MyPageLocalData: AppData {
    let titleLabel: String
}

extension MyPageLocalData {
    static let myPageServiceLabelList = [MyPageLocalData(titleLabel: "공지사항"), MyPageLocalData(titleLabel: "FAQ"),
                                         MyPageLocalData(titleLabel: "1:1 문의"), MyPageLocalData(titleLabel: "서비스 피드백"),
                                         MyPageLocalData(titleLabel: "이용약관"), MyPageLocalData(titleLabel: "개인보호 정책")]
    
    static let myPageSectionLabelList = [MyPageLocalData(titleLabel: "고객센터"), MyPageLocalData(titleLabel: "앱 설정")]
}

struct MyPageAppSettinLocalgData: AppData {
    var appSettingtext: String
    var showSwitch: Bool
}

extension MyPageAppSettinLocalgData {
    static let myPageAppSettingDataList = [MyPageAppSettinLocalgData(appSettingtext: "알림 설정", showSwitch: true), MyPageAppSettinLocalgData(appSettingtext: "앱 버전", showSwitch: false)]
}
