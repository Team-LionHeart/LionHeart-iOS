//
//  ViewControllerServiceable.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/15.
//

import UIKit


/// 네트워크 요청을 하는 ViewController가 채택하는 프로토콜
protocol ViewControllerServiceable where Self: UIViewController {

    /// 네트워크 통신을 do-catch문으로 감싸고 catch문에서 호출하는 메서드
    /// - Parameter error: 네트워크 통신 중 throw된 에러
    func handleError(_ error: NetworkError)
    func showLoading()
    func hideLoading()
}

extension ViewControllerServiceable {

    func showLoading() {
        if let loadingView = getLoadingView() {
            loadingView.startAnimating()
            return
        }
        let loadingView = LHLoadingView()
        loadingView.startAnimating()

        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func hideLoading() {
        getLoadingView()?.stopAnimating()
        getLoadingView()?.removeFromSuperview()
    }

    private func getLoadingView() -> LHLoadingView? {
        return view.subviews.compactMap { $0 as? LHLoadingView }.first
    }
}
