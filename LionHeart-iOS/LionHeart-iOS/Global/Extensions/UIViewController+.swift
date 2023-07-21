//
//  UIViewController+.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//

import UIKit

/**
 
 - Description:
 
 요청하는(OK,취소)버튼만 있는 UIAlertController를 간편하게 만들기 위한 extension입니다.
 
 - parameters:
 - title: 알림창에 뜨는 타이틀 부분입니다.
 - message: 타이틀 밑에 뜨는 메세지 부분입니다.
 - okAction: 확인버튼을 눌렀을 때 동작하는 부분입니다.
 - cancelAction: 취소버튼을 눌렀을 때 동작하는 부분입니다.
 - completion: 해당 UIAlertController가 띄워졌을 때, 동작하는 부분입니다.
 
 
 */
extension UIViewController {
    func makeAlert(title: String,
                   message: String,
                   okAction: ((UIAlertAction) -> Void)? = nil,
                   completion : (() -> Void)? = nil) {
        makeVibrate()
        let alertViewController = UIAlertController(title: title, message: message,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: completion)
    }
}

/**

  - Description:
 
      VC나 View 내에서 해당 함수를 호출하면, 햅틱이 발생하는 메서드입니다.
      버튼을 누르거나 유저에게 특정 행동이 발생했다는 것을 알려주기 위해 다음과 같은 햅틱을 활용합니다.

  - parameters:
    - degree: 터치의 세기 정도를 정의합니다. 보통은 medium,light를 제일 많이 활용합니다?!
          따라서 파라미터 기본값을 . medium으로 정의했습니다.
 
*/

extension UIViewController {
    
  public func makeVibrate(degree: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: degree)
        generator.impactOccurred()
    }
}

/**

  - Description:
    배열 형태로 오는 tag 값들을 GUI에 맞는 형태로 가공하여 반환해 주는 메서드입니다.

  - parameters:
    서버 데이터인 String 타입의 tag 배열을 넣어 줍니다.
 
*/

extension UIViewController {
    public func makeTagString(tagList: [String]) -> String {
        var str = ""
        for tag in tagList.indices {
            str += tag != tagList.count-1 ? tagList[tag] + " ⋅ " : tagList[tag]
        }
        return str
    }
}

/**

  - Description:
    ArticleDetailViewController로 fullscreen으로 present해주는 메서드입니다

  - parameters:
    articleID를 넘겨줍니다
 
*/

extension UIViewController {
    func presentArticleDetailFullScreen(articleID: Int) {
        let articleDetailViewController = ArticleDetailViewController()
        articleDetailViewController.setArticleId(id: articleID)
        articleDetailViewController.isModalInPresentation = true
        articleDetailViewController.modalPresentationStyle = .fullScreen
        self.present(articleDetailViewController, animated: true)
    }
}
