//
//  UIControl+.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//

import UIKit.UIControl

public typealias ButtonAction = (UIButton) -> Void

extension UIControl {
    /// addTarget대신 사용하는 함수 클로저로 action을 정의할 수 있음
    /// - Parameters:
    ///   - controlEvents: touchUpInside로 정의되어있음
    ///   - closure: 버튼action을 정의하는 클로저(sender를 input으로 받을 수 있음(선택사항))
    public func addButtonAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ButtonAction) {
        @objc class ClosureSleeve: NSObject {
            let closure: ButtonAction
            
            init(_ closure: @escaping ButtonAction) {
                self.closure = closure
            }
            
            @objc func invoke(_ sender: UIButton) {
                closure(sender)
            }
        }
        
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke(_:)), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
