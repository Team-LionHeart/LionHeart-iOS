//
//  TableViewCellRegisterDequeueProtocol.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//

import UIKit

protocol TableViewCellRegisterDequeueProtocol where Self: UITableViewCell {
    associatedtype T: AppData
    
    static func register(to tableView: UITableView)
    // MARK: - 여기서 Self는 타입인데 protocol을 채택하는 타입을 이야기함(확장성을 고려할수있게됨)
    // 프로토콜에서 Self는 타입자체를 가리킴
    static func dequeueReusableCell(to tableView: UITableView) -> Self
    static var reuseIdentifier: String { get }
    
    var inputData: T? { get set }
}

// MARK: - TableViewCelled라는 프로토콜은 기본값(defalult)를 가진다 -> 언제? -> UITableViewCell이라는 타입의 클래스에 채택되었을때만!
extension TableViewCellRegisterDequeueProtocol {
    static func register(to tableView: UITableView) {
        // MARK: - 타입속성에서 self를 사용하면, 인스턴스가 아니라 타입의 value(Self.self)를 가리킨다
        // 즉, 타입속성에서 다른 타입속성에 접근하려면 self로 접근해야한다
        // extension에서 Self는 해당 프로토콜을 채택한 "타입"근데 우리는 타입자체를 넣어줄수없기때문에 value를 넣어줘야하니까 Self.self가 맞는데
        // AnyClass는 메타타입 -> 하지만 input으로 타입자체를 넣어줄수없으니 .self로 value화 해주는거임
        // static변수에서 Self.self를 그냥 self라고 써도된다는거임
        tableView.register(Self.self, forCellReuseIdentifier: self.reuseIdentifier)
        //== tableView.register(Self.self, forCellReuseIdentifier: self.reuseIdentifier)
        // MARK: - register에는 AnyClass라는 메타타입의 value값과 CellIdentifier이 들어가야함
        // cellidentifer은 다른 static변수인 reuseIdentifier을 넣어주면됨
        //tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
    }
    
    static func dequeueReusableCell(to tableView: UITableView) -> Self {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier), let returnCell = cell as? Self else { fatalError("Error! \(self.reuseIdentifier)") }
        return returnCell
    }
    
    static var reuseIdentifier: String {
        // 타입속성에서 Self.self와 self는 같은 의미를 가진다
        return String(describing: self)
        //Subject에는 메타타입의 value값을 넣어준다
    }
}
