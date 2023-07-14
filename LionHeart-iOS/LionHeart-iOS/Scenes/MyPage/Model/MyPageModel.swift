//
//  MyPageModel.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/14.
//

import Foundation

struct MyPageData: AppData {
    var titleLabel: String
}

extension MyPageData {
    static let myPageServiceLabelList = [MyPageData(titleLabel: "공지사항"), MyPageData(titleLabel: "FAQ"),
                                         MyPageData(titleLabel: "1:1 문의"), MyPageData(titleLabel: "서비스 피드백"),
                                         MyPageData(titleLabel: "이용약관"), MyPageData(titleLabel: "개인보호 정책")]
    
    static let myPageSectionLabelList = [MyPageData(titleLabel: "고객센터"), MyPageData(titleLabel: "앱 설정")]
}

struct MyPageAppSettingData: AppData {
    var appSettingtext: String
    var showSwitch: Bool
}

extension MyPageAppSettingData {
    static let myPageAppSettingDataList = [MyPageAppSettingData(appSettingtext: "알림 설정", showSwitch: true), MyPageAppSettingData(appSettingtext: "앱 버전", showSwitch: false)]
}
