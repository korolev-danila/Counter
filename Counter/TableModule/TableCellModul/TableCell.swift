//
//  TableCell.swift
//  Counter
//
//  Created by Данила on 21.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class TableCell: UITableViewCell {
    
    var viewModel: TableCellViewModel!

    let disposeBag = DisposeBag()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name label"
        label.font = UIFont.systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.2
        label.baselineAdjustment = .alignBaselines
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "999"
        label.font = UIFont.systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.2
        label.baselineAdjustment = .alignBaselines
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(countLabel)
        
        nameLabel.frame = CGRect(x: 16,
                                     y: contentView.center.y,
                                     width: 88, height: 20)
        
        countLabel.frame = CGRect(x: contentView.center.x - 8,
                                     y: contentView.center.y,
                                     width: 20, height: 20)
    }
    
    private func bindViewModel() {
        viewModel.name
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.count
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setViewModel(_ viewModel: TableCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
}
