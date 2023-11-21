//
//  CurriculumListWeekViewController.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 11/21/23.
//

import UIKit
import Combine

final class CurriculumListWeekViewController: UIViewController {
    
    private let leftButtonTapped = PassthroughSubject<Void, Never>()
    private let rightButtonTapped = PassthroughSubject<Void, Never>()
    private let articleCellTapped = PassthroughSubject<IndexPath, Never>()
    private let bookmarkButtonTapped = PassthroughSubject<IndexPath, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy datasoruce = CurriculumListWeekDiffableDataSource(tableView: curriculumListByWeekTableView)
    
    private let curriculumListByWeekTableView = CurriculumListByWeekTableView()
    
//    var weekCount: Int?
//    var selectedIndexPath: IndexPath?
//    var inputData: CurriculumWeekData? 
//    {
//        didSet {
//            curriculumListByWeekTableView.reloadData()
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setDelegate()
        bindInput()
        bind()
    }
    
    private func bindInput() {
        
        
    }
    
    private func bind() {
        
    }
    
    private func applySnapshot(weekData: CurriculumWeekData) {
        
        var snapshot = NSDiffableDataSourceSnapshot<CurriculumListWeekSection, CurriculumListWeekItem>()
        snapshot.appendSections([.articleListByWeek])
        
        let items = weekData.articleData.map {
            return CurriculumListWeekItem.article(weekData: $0)
        }
        
        snapshot.appendItems(items, toSection: .articleListByWeek)
        self.datasoruce.apply(snapshot)
    }
}


private extension CurriculumListWeekViewController {
    
    enum Size {
        static let weekBackGroundImageSize: CGFloat = (60 / 375) * Constant.Screen.width
    }
    
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        self.view.addSubviews(curriculumListByWeekTableView)
    }
    
    func setLayout() {
        curriculumListByWeekTableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func setDelegate() {
        curriculumListByWeekTableView.delegate = self
    }
}

extension CurriculumListWeekViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.articleCellTapped.send(indexPath)
//        if indexPath.row != 0 {
//            
//            
//            guard let inputData else { return }
//            NotificationCenter.default.post(name: NSNotification.Name("didSelectTableViewCell"), object: inputData.articleData[indexPath.row-1].articleId)
//        }
    }
}



//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let inputData else { return 0 }
//        return inputData.articleData.count + 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let cell = CurriculumArticleByWeekRowZeroTableViewCell.dequeueReusableCell(to: curriculumListByWeekTableView)
//            cell.inputData = inputData?.week
//            return cell
//        } else {
//            let cell = CurriculumArticleByWeekTableViewCell.dequeueReusableCell(to: curriculumListByWeekTableView)
//            cell.inputData = inputData?.articleData[indexPath.row - 1]
//            cell.selectionStyle = .none
//            cell.backgroundColor = .designSystem(.background)
//            return cell
//        }
//    }
