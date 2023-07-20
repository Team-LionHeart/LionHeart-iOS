//
//  TableViewCellRegisterDequeueProtocol.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//

import UIKit

protocol TableViewCellRegisterDequeueProtocol where Self: UITableViewCell {
    static func register(to tableView: UITableView)
    static func dequeueReusableCell(to tableView: UITableView) -> Self
    static var reuseIdentifier: String { get }
}

extension TableViewCellRegisterDequeueProtocol {
    static func register(to tableView: UITableView) {
        tableView.register(Self.self, forCellReuseIdentifier: self.reuseIdentifier)
    }
    
    static func dequeueReusableCell(to tableView: UITableView) -> Self {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier), let returnCell = cell as? Self else { fatalError("Error! \(self.reuseIdentifier)") }
        return returnCell
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
