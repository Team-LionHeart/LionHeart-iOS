//
//  CurriculumListWeekDiffableDataSource.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/21/23.
//

import UIKit


final class CurriculumListWeekDiffableDataSource: UITableViewDiffableDataSource<CurriculumListWeekSection, CurriculumListWeekItem> {
    
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .article(let weekData):
                let cell = CurriculumArticleByWeekTableViewCell.dequeueReusableCell(to: tableView)
                cell.inputData = weekData
                cell.selectionStyle = .none
                cell.backgroundColor = .designSystem(.background)
                return cell
            }
        }
    }
    
}
