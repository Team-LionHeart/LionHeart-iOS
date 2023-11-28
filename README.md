# 🦁 하루 10분, 좋은 아빠가 되는 방법
![LionHeart_MainImage](https://github.com/Team-LionHeart/LionHeart-iOS/assets/86944161/6825a86c-2f81-4084-88cd-aa0b46a721fa)

> 라이온하트는 ‘**사자의 용기**’를 의미합니다. <br>
태어나 처음으로 아빠가 된 어른들이 강하고 똑똑한 부모가 될 수 있도록, <br>
세상에서 가장 쉬운 방법을 제공합니다. <br>


<br>

## 프로젝트 기간
- **2023.12 ~ 4차 리팩터링 (진행 예정) (모듈화(Tuist 도입))** <br>
- **2023.11 ~ 3차 리팩터링 (진행 중🚧) (Unit test도입 및 모듈화(tuist도입))** <br>
- **[2023.10 ~ 2021.11 2차 리팩터링 (MVC-C -> MVVM-C(+Combine))](#2차-리팩터링)** <br>
- **[2023.08 ~ 2023.10 1차 리팩터링(MVC -> MVC-C)](#1차-리팩터링)** <br>
- **[2023.06 ~ 2023.07 UI 설계 및 구현(1차 프로젝트)](#UI-설계-및-구현)** <br>

<br>

![LionHeart_Flow](https://github.com/Team-LionHeart/LionHeart-iOS/assets/86944161/4006340f-a1af-4ce2-841e-6780ee683b4f)

<br>

# 리팩터링 참여 인원
<img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/61596b76-5a50-4b29-9d0b-b62bb6a86b8f" width="165"> | <img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/2bfbb1fe-2c2a-42b2-a589-cdd01b113e30" width="165"> | <img src="https://github.com/gosopt-LionHeart/LionHeart-iOS/assets/113027703/1423bb08-4f33-41b9-8caa-56432794ecca" width="165">|
:---------:|:----------:|:---------:
[ffalswo2](https://github.com/ffalswo2) | [kimscastle](https://github.com/kimscastle) |[cchanmi](https://github.com/cchanmi) |

<br>

# 2차 리팩터링
기존 MVC-C패턴에서 완전한 로직분리를 위한 MVVM-C패턴으로 리팩터링, 데이터 바인딩의 경우엔 combine을 활용

## Lion Heart MVVM 리팩터링 원칙
### viewModel은 input과 output의 구조로 설계후 combine을 활용해 data binding을 구현
- 이때 ViewController쪽에서 받는 Publisher의 errortype은 항상 Never type으로 구성했습니다.
그 이유로 UI는 error를 알필요가 없이 단순히 action으로 ViewModel에 값만 넘겨주면되며, ViewController에서 completion에 해당하는 error를 받게되면 stream이 끊어지고, 끊어진 stream에서 본래 받고자 하는 user input은 화면을 재진입하지 않는 이상 어떠한 요청도 받지 못하게 되기 때문입니다.
- navigation을 관리하는 publisher를 ViewModel내부에서 구현하고 특정 input에따라 화면전환 타입을 넘겨주고 navigation publisher가 타입에따라 화면전환담당 객체인 coordintor의 메서드 호출하는 구조를 가집니다.
- error를 관리하는 publisher를 ViewModel내부에서 구현하고 error가 발생했을시 ViewModel에서 에러처리에 관련한 로직을 수행합니다.

### 여전히 ViewModel을 의존성주입하는 이유
DIP의 본질은 “변화하지 않는 것에 의존한다”이며 이 뜻은 “추상화”에 의존한다는 뜻입니다. 그리고 Swift에서 추상화를 위한 도구로 protocol을 제공합니다.
레이어상으로 UI에 가장가까운 ViewModel의 경우 변화에 민감할수있기에, ViewModel의 DIP를 위한 protocol 또한 변화에 민감합니다. 이는 DIP의 본질에 맞지 않습니다.
따라서 상대적으로 변화가 잦은 UI와 직접적으로 영향을 받는 ViewModel을 서로 구체 타입을 바라보게끔 하는 구조도 고려를 했습니다. 하지만 해당 프로젝트에서는 Input-Output구조를 채택하고있으며 Input, Output 구조체 타입과 transform이라는 메서드로 추상화된 ViewModel protocol은 기획이 변하더라도 “변하지 않는 것”이라고 판단했습니다. 따라서 해당 프로젝트에서는 ViewController와 ViewModel또한 DIP를 통해 객체간 결합도를 낮추는 방향으로 프로젝트를 구성하기로 결정했습니다.

---------------------------------------
<br>

## 기존 async/await을 통한 네트워킹 + Combine 결합
### async / await과 Combine을 같이 쓰는 이유
< 향후 PR 링크 추가 >

<br>

### async / await과 Combine을 결합한 네트워크 방법
1. 네트워킹시 completion을 통해 상위 stream의 끊어짐을 방지하기 위해 flatmap operator를 사용하고, 내부적으로는 비동기 적으로 stream을 생성하기 위한 future를 사용해서 async/await과 Combine을 혼합해서 사용했습니다.
```swift
let curriculumMonth = input.viewWillAppear
    .flatMap { _ -> AnyPublisher<(userInfo: UserInfoData, monthData: [CurriculumMonthData]), NetWorkError> in
        return Future<(userInfo: UserInfoData, monthData: [CurriculumMonthData]), NetworkError> { promise in
            Task {
                do {
                    let userInfo = try await self.getCurriculumData()
                    promise(.success((userInfo: userInfo, monthData: CurriculumMonthData.dummy())))
                } catch {
                    promise(.failure(error as! NetworkError))
                }
            }
        }
				.eraseToAnyPublisher()
```

<br>

2. 네트워크 통신시 발생하는 error를 combine의 catch operator를 통해서 최종적으로는 error를 never type으로하는 stream으로 바꿉니다.
```swift
let curriculumMonth = input.viewWillAppear
    .flatMap { _ -> AnyPublisher<(userInfo: UserInfoData, monthData: [CurriculumMonthData]), Never> in
        return Future<(userInfo: UserInfoData, monthData: [CurriculumMonthData]), NetworkError> { promise in
            Task {
                do {
                    let userInfo = try await self.getCurriculumData()
                    promise(.success((userInfo: userInfo, monthData: CurriculumMonthData.dummy())))
                } catch {
                    promise(.failure(error as! NetworkError))
                }
            }
        }.catch { error in
            self.errorSubject.send(error)
            let empty = UserInfoData(userWeekInfo: 0, userDayInfo: 0, progress: 0, remainingDay: 0)
            let emptyMonth = CurriculumMonthData(month: "1", weekDatas: [])
            return Just((userInfo: empty, monthData: [emptyMonth]))
        }
        .eraseToAnyPublisher()
    }
    .eraseToAnyPublisher()
```
해당 과정을 통해 catch가 없을때의 코드와 달라진점은 flaMap을 통해 return해주는 Publisher의 Error Type을 Never로 만들어줄 수 있어 1번 원칙에서의 ***UI는 error를 알필요가없다*** 라는 원칙을 지킬 수 있습니다.
<br>
<br>
💡 해당 방식이 유의미한 이유는 어떤 error가 발생했을때 UI/UX적인 관점에서 유저에게 보여줄수있는 최소한의 UI는 구성을 해야하기에 default값을 넣어줘 유저가 보기에는 UI가 깨지지않은 view를 볼수있고, 내부적으로 error를 handling해주는 stream을 통해 에러에 대한 처리를 해주면 유저입장에서는 에러가 발생한 사실을 모르게 처리해줄수있어 긍정적인 사용자 경험을 얻을수 있게 됩니다.

<br>

3. 기존의 delegate pattern대신 combine의 stream을 활용한 data passing방식으로 통일
> cell 내부의 button action을 처리할때 datasource로 인해 생성되는 data stream이 누적되는 문제와 cell내부에서 data stream이 생성되는 문제를 prepareForReuse와 stream을 저장하는 위치를 조정함으로써 해결합니다.
- [[REFACTOR] CurriculumView Diffable 및 MVVM(Combine)-C로 리팩터링 (#179)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/187)
 
<br>

---------------------------------------

## 기존 TableView, CollectionView를 DiffableDataSource로 변경
- 해당 앱에서는 데이터의 변화에 따른 애니메이션이 필요한 상황이 존재하고 해당 경우에 Snapshot을 활용해 UI/UX적으로 보다 나은 경험을 제공해주는 DiffableDataSource를 활용해 보다 더 나은 유저 경험을 제공할 수 있는 방향으로 리팩터링했습니다.

### cell reuse
- [[REFACTOR] CurriculumView Diffable 및 MVVM(Combine)-C로 리팩터링 (#179)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/187)

### MVVM 원칙
- [[REFACTOR] LoginViewController MVVM-C로 변경 (#162)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/163)
- [[REFACTOR] Auth관련 VC들 MVVM(Combine)-C으로 변경 (#164)](https://github.com/Team-LionHeart/LionHeart-iOS/pull/165)

### ResultType을 통한 error처리에 대한 고민
- [[REFACTOR] ChallengeVC를 DiffableDataSource와 MVVM(Combine)으로 리팩터링](https://github.com/Team-LionHeart/LionHeart-iOS/pull/170)

<br>

---------------------------------------

<br>

# 1차 리팩터링
기존 MVC 패턴에서 ViewController의 책임을 분리하기 위한 여러가지 디자인패턴 및 구조 적용


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
