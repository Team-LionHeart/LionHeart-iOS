//
//  MyPageDataSource.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/11/20.
//

import UIKit

final class MyPageDataSource: UITableViewDiffableDataSource<MyPageSection, MyPageRow> {
    
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .customerServiceRow(section: let model):
                let cell = MyPageCustomerServiceTableViewCell.dequeueReusableCell(to: tableView)
                cell.selectionStyle = .none
                cell.inputData = model.cellTitle
                return cell
            case .appSettingRow(section: let model):
                let cell = MyPageAppSettingTableViewCell.dequeueReusableCell(to: tableView)
                cell.selectionStyle = .none
                cell.inputData = model.cellTitle
                return cell
            }
        }
    }
    
    func makeList(_ appSection: [MyPageRow], _ customServiceSection: [MyPageRow]) {
        var snapShot = NSDiffableDataSourceSnapshot<MyPageSection, MyPageRow>()
        snapShot.appendSections([.customerServiceSetion, .appSettingSection])
        snapShot.appendItems(appSection, toSection: .appSettingSection)
        snapShot.appendItems(customServiceSection, toSection: .customerServiceSetion)
        self.apply(snapShot)
    }
}
