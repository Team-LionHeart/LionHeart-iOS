# 🦁 하루 10분, 좋은 아빠가 되는 방법
![LionHeart_MainImage](https://github.com/Team-LionHeart/LionHeart-iOS/assets/86944161/6825a86c-2f81-4084-88cd-aa0b46a721fa)

> 라이온하트는 ‘**사자의 용기**’를 의미합니다. <br>
태어나 처음으로 아빠가 된 어른들이 강하고 똑똑한 부모가 될 수 있도록, <br>
세상에서 가장 쉬운 방법을 제공합니다. <br>


<br>

## 프로젝트 기간
- **2023.10 ~ 2차 리팩터링 (진행 중 🚧) (MVC-C -> MVVM-C(+Combine))** <br>
- **[2023.08 ~ 2023.10 1차 리팩터링(MVC -> MVC-C)](#1차-리팩터링)** <br>
- **[2023.06 ~ 2023.07 UI 설계 및 구현(1차 프로젝트)](#UI-설계-및-구현)** <br>

<br>

![LionHeart_Flow](https://github.com/Team-LionHeart/LionHeart-iOS/assets/86944161/4006340f-a1af-4ce2-841e-6780ee683b4f)

<br>

# 1차 리팩터링
기존 MVC 패턴에서 ViewController의 책임을 분리하기 위한 여러가지 디자인패턴 및 구조 적용

<br>

### 참여 인원
<img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/61596b76-5a50-4b29-9d0b-b62bb6a86b8f" width="165"> | <img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/2bfbb1fe-2c2a-42b2-a589-cdd01b113e30" width="165"> | <img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/1423bb08-4f33-41b9-8caa-56432794ecca" width="165">|
:---------:|:----------:|:---------:
[ffalswo2](https://github.com/ffalswo2) | [kimscastle](https://github.com/kimscastle) |[cchanmi](https://github.com/cchanmi) |

<br>

### 1. 기존 네트워크 레이어를 singleton에서 의존성주입방식(Dependency Injectcion)으로 변경
추후에 Unit Test 도입을 고려하여 응집도는 높고 결합도는 낮은 객체 설계를 목표로 설계에 임했습니다. 기존의 싱글톤 방식은 SRP 원칙과 OCP 원칙에 위반되고 특정 값에 대한 테스트를 진행하는데 어려움이 있으며 Data race의 위험성 또한 존재할 수 있습니다. 따라서 기존 싱글톤에서 Dependency Injection을 통한 의존성 주입 방식을 도입 및 적용했습니다.

<p align="center">
<img src="https://github.com/Team-LionHeart/LionHeart-iOS/assets/86944161/9b82b692-94ca-4029-bed1-d00232caac8f" width="800"/>
</p>

- [[REFACTOR] API 레이어 분리 (#127)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/128)
- [[REFACTOR] 북마크 네트워크 레이어 분리(#129)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/130)
- [[REFACTOR]전체 DI적용(#131)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/132)

<br>

### 2. 전체 UI 컴포넌트 분리, 디자인시스템 구축 및 적용
팀 내에서 반복해서 쓰이는 UIComponent의 경우에 반복되는 코드가 많아지는 상황이 발생해 가독성 측면에서 피로도가 너무 심해졌습니다. 자주 쓰이는 Component들에서 공통적으로 쓰이는 파라미터들을 인자로 받아 편하게 사용할 수 있도록 라이온하트의 디자인시스템을 구축하고 적용했습니다.

- [[REFACTOR]라이온하트 디자인시스템 구축 및 적용(#133)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/134)

<br>

### 3. ViewController의 화면 전환 책임을 담당해 줄 Coordinator Pattern 도입
ViewController는 UI 관련 객체이기 때문에, 사용자 흐름을 처리하는것은 역할 범위(scope)를 벗어난다고 생각했습니다. 또한, MVC의 단점인 ViewController의 역할이 비대해지는 문제를 해결하기 위해 화면전환 책임 전담을 위한 Coordintor Pattern을 도입 및 적용했습니다.

<p align="center">
<img src=https://github.com/Team-LionHeart/LionHeart-iOS/assets/86944161/ecf3a0e3-231c-4820-94f1-c8ff09126041" width="800"/>
</p>

- [[REFACTOR] Coordinator Pattern 적용 (#139)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/140)

<br>

### 4. Coodinator 객체 내에서 ViewController 객체 생성 책임 분리를 위한 Factory Pattern 도입
DI로인해 ViewController 객체 생성시 외부 객체 생성 및 주입의 불편함이 발생했습니다. 이를 해결하기 위해 Custom DI Container, Swinject, Factory Pattern 같은 여러 방법론을 통한 문제 해결을 고민했습니다. 결론적으로 Factory Pattern이 라이온하트 프로젝트 규모와 구조를 고려했을 때, 가장 적합하다고 생각해 도입 및 적용했습니다.

<p align="center">
<img src=https://github.com/Team-LionHeart/LionHeart-iOS/assets/86944161/0bfe7475-5f0b-469a-87b5-48601341fdce" width="800"/>
</p>

- [[REFACTOR] Factory Pattern도입(#149)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/150)
- [[REFACTOR] ArticleCategory, Challenge, Bookmark Factory Pattern 적용(#143](https://github.com/Team-LionHeart/LionHeart-iOS/pull/146)
- [[REFACTOR] Curriculum, MyPage, Article Coordinator에 Factory Pattern 적용 (#145)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/147)
- [[REFACTOR] Auth, Splash, Today factory pattern 적용 (#144)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/148)

<br>

### 5. ViewController와 Coordinator간의 완전한 관심사 분리 및 캡슐화를 위한 Adaptor Pattern 도입
Delegate 패턴으로인해 Coordinator가 ViewController에서의 User Action을 추론할 수 있게 되었고 따라서 완전한 관심사 분리가 불가능하게 되었습니다. Coordinator는 flow에 대한 책임만을 가지고 있어야 한다고 생각했고, Coordinator와 ViewController의 완전한 관심사 분리를 위해 두 가지 Interface를 연결해 주는 Adaptor Pattern을 도입 및 적용했습니다.

<p align="center">
<img src=https://github.com/Team-LionHeart/LionHeart-iOS/assets/86944161/9800ebc9-0c2a-4385-91ee-a35f7dc5a5d5" width="800"/>
</p>

- [[REFACTOR] Adaptor Pattern 도입 (#153)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/161)
- [[REFACTOR] today coordinator에 adaptor pattern 적용 (#152)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/154)
- [[REFACTOR] Splash, Auth, ArticleCategory Coordinator에 Adaptor Pattern적용(#156)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/157)
- [[REFACTOR] Curriculum, Challenge, Bookmark Adaptor Pattern 적용 (#155)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/158)
- [[REFACTOR] My Page, Article Detail Coordinator에 Adaptor Pattern 적용 (#159)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/160)

<br>

-----

# UI 설계 및 구현

<details>
<summary>UI 설계 및 구현(1차 프로젝트)</summary>

<br><br>
##  🍎 LionHeart-iOS Developers
<img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/61596b76-5a50-4b29-9d0b-b62bb6a86b8f" width="165"> | <img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/2bfbb1fe-2c2a-42b2-a589-cdd01b113e30" width="165"> | <img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/57f07e0c-ce1e-406f-b9cd-b49edc8d7485" width="165"> | <img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/4d70bfae-0ef8-4388-8d5b-a734a0a10184" width="165"> |<img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/1423bb08-4f33-41b9-8caa-56432794ecca" width="165">|
:---------:|:----------:|:---------:|:---------:|:---------:|
김민재 | 김의성 | 김동현 | 곽성준 | 황찬미 |
[ffalswo2](https://github.com/ffalswo2) | [kimscastle](https://github.com/kimscastle) | [BrickSky](https://github.com/BrickSky) | [sjk4618](https://github.com/sjk4618) |[cchanmi](https://github.com/cchanmi) |
| **프로젝트 설계** <br> **로그인 유저 플로우** <br> **스플래시 뷰** <br> **아티클 상세뷰** | **프로젝트 설계** <br> **온보딩** <br> **메인 뷰** <br> **디자인시스템**|**탐색 뷰**<br> **챌린지 뷰** | **커리큘럼 뷰**<br> **주차별 리스트 뷰** | **북마크 뷰** <br> **마이페이지 뷰** |

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

</details>
