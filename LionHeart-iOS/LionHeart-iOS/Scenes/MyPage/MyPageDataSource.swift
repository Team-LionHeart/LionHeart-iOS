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
            case .customerServiceSetion(section: let model):
                let cell = MyPageCustomerServiceTableViewCell.dequeueReusableCell(to: tableView)
                cell.selectionStyle = .none
                cell.inputData = model.cellTitle

                return cell
            case .appSettingSection(section: let model):
                let cell = MyPageAppSettingTableViewCell.dequeueReusableCell(to: tableView)
                cell.selectionStyle = .none
                cell.inputData = model.cellTitle
                return cell
            }
        }
        self.makeList()
    }
    
    private func makeList() {
        var snapShot = NSDiffableDataSourceSnapshot<MyPageSection, MyPageRow>()
        snapShot.appendSections([.customerServiceSetion, .appSettingSection])
        snapShot.appendItems(MyPageRow.appSettingService, toSection: .appSettingSection)
        snapShot.appendItems(MyPageRow.customSerive, toSection: .customerServiceSetion)
        self.apply(snapShot)
    }
}
