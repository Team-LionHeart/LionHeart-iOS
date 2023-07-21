# 🦁 LionHeart-iOS

> 하루 10분, 좋은 아빠가 되는 방법


<br><br>
##  🍎 LionHeart-iOS Developers
<img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/61596b76-5a50-4b29-9d0b-b62bb6a86b8f" width="165"> | <img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/2bfbb1fe-2c2a-42b2-a589-cdd01b113e30" width="165"> | <img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/57f07e0c-ce1e-406f-b9cd-b49edc8d7485" width="165"> | <img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/4d70bfae-0ef8-4388-8d5b-a734a0a10184" width="165"> |<img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/1423bb08-4f33-41b9-8caa-56432794ecca" width="165"> |
:---------:|:----------:|:---------:|:---------:|:---------:|
김민재 | 김의성 | 김동현 | 곽성준 | 황찬미 |
[ffalswo2](https://github.com/ffalswo2) | [kimscastle](https://github.com/kimscastle) | [BrickSky](https://github.com/BrickSky) | [sjk4618](https://github.com/sjk4618) |[cchanmi](https://github.com/cchanmi) |
| **프로젝트 설계** <br> **로그인 유저 플로우** <br> **스플래시 뷰** <br> **아티클 상세뷰** | **프로젝트 설계** <br> **온보딩** <br> **메인 뷰** <br> **디자인시스템**|**탐색 뷰**<br> **챌린지 뷰**|**커리큘럼 뷰**<br> **주차별 리스트 뷰**| **북마크 뷰** <br> **마이페이지 뷰**|

## 💻 Development Environment

<img src ="https://img.shields.io/badge/Xcode-14.3-blue?logo=xcode" height="30"> <img src ="https://img.shields.io/badge/iOS-15.0-white.svg" height="30">

<br>

## 📖 Using Library

| Library | Tag | Tool |
| --- | --- | --- |
| **SnapKit** | Layout | SPM |
| **Lottie** | Splash, Animation | SPM |
| **FireBase** | 푸시알림 | SPM 
| **KaKaoOpenSDK** | 소셜로그인 | SPM |

<br>

## 📝 Coding Convention, Git flow
- [Convention and flow](https://maketheworldabetterplace0.notion.site/Convention-d20541f4c52443c7b243733bcd65ad73?pvs=4)


## 📁 Foldering
```
LionHeart-iOS
├── LionHeart-iOS
│   ├── Application
│   │   ├── AppDelegate.swift
│   │   ├── Base.lproj
│   │   │   └── LaunchScreen.storyboard
│   │   └── SceneDelegate.swift
│   ├── Global
│   │   ├── Config.swift
│   │   ├── Extensions
│   │   │   └── Encodable+.swift
│   │   ├── Literals
│   │   ├── Resources
│   │   │   └── Assets.xcassets
│   │   │       ├── AccentColor.colorset
│   │   │       │   └── Contents.json
│   │   │       ├── AppIcon.appiconset
│   │   │       │   └── Contents.json
│   │   │       └── Contents.json
│   │   ├── UIComponents
│   │   └── Utils
│   ├── GoogleService-Info.plist
│   ├── LionHeart-iOSDebug.entitlements
│   ├── Network
│   │   └── Base
│   │       ├── BaseResponse.swift
│   │       └── HTTPHeaderField.swift
│   ├── Scenes
│   │   ├── Article
│   │   │   ├── ArticleCategory
│   │   │   │   ├── Cells
│   │   │   │   ├── ViewControllers
│   │   │   │   └── Views
│   │   │   ├── ArticleDetail
│   │   │   │   ├── Cells
│   │   │   │   ├── ViewControllers
│   │   │   │   └── Views
│   │   │   ├── ArticleListByCategory
│   │   │   │   ├── Cells
│   │   │   │   ├── ViewControllers
│   │   │   │   └── Views
│   │   │   └── ArticleListByWeek
│   │   │       ├── Cells
│   │   │       ├── ViewControllers
│   │   │       └── Views
│   │   ├── BookMark
│   │   │   ├── Cells
│   │   │   ├── ViewControllers
│   │   │   └── Views
│   │   ├── Curriculum
│   │   │   ├── Cells
│   │   │   ├── ViewControllers
│   │   │   └── Views
│   │   ├── Login
│   │   ├── MyPage
│   │   │   ├── ViewControllers
│   │   │   └── Views
│   │   ├── Onboarding
│   │   │   ├── Cells
│   │   │   ├── ViewControllers
│   │   │   └── Views
│   │   ├── Splash
│   │   ├── TabBar
│   │   └── Today
│   │       ├── Cells
│   │       ├── ViewControllers
│   │       └── Views
│   ├── Settings
│   │   ├── Configurations
│   │   │   └── Development.xcconfig
│   │   └── Info.plist
│   
```

<br>

## 🦁 라이온하트 노션이 궁금하다면?
[아요 라이옹 노션](https://www.notion.so/maketheworldabetterplace0/16a3b1bcf37f409dada937cc372add37?pvs=4) <br>

## 💥 Troble Shotting
[김민재 트러블 슈팅 🐨](https://www.notion.so/maketheworldabetterplace0/Trouble-Shooting-9957b52b43e64ec59f254594d7d372fb?pvs=4) <br>
[김의성 트러블 슈팅 🦈](https://www.notion.so/maketheworldabetterplace0/Trouble-Shooting-424bdc5f6a8b42b6839cea70b3d738d6?pvs=4) <br>
[곽성준 트러블 슈팅 🦦](https://www.notion.so/maketheworldabetterplace0/Trouble-Shooting-60f925f9f3ca447f86a4cdeafad1392b?pvs=4) <br>
[김동현 트러클 슈팅 🐙](https://www.notion.so/maketheworldabetterplace0/Troble-Shooting-f6442d53132c4d929fcd245daeaf132e?pvs=4) <br>
[황찬미 트러블 슈팅 🐧](https://www.notion.so/maketheworldabetterplace0/Trouble-Shooting-a5753e05b0c04bddb13d87a4f8274dbf?pvs=4)
