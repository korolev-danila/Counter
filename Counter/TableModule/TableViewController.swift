//
//  TableViewController.swift
//  Counter
//
//  Created by Данила on 21.02.2023.
//

import UIKit
import RxSwift

final class TableViewController: UIViewController {
    
    private let viewModel: TableViewModel
    
    private let disposeBag = DisposeBag()
    
    var showCounter: (Model) -> () = { _ in }
    private func pushCounter(_ model: Model) {
        showCounter(model)
    }

    private let tableView: UITableView = {
        let tv = UITableView(frame: CGRect(), style: .plain)
        tv.register(TableCell.self, forCellReuseIdentifier: "cell")
        tv.backgroundColor = .systemBackground
        return tv
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle", withConfiguration:
                                    UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .label
        return button
    }()
    
    // MARK: - init
    init(viewModel: TableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear table")
        viewModel.fetchModels()
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        tableView.frame = CGRect(x: 0, y: 0,
                                 width: view.frame.size.width,
                                 height: view.frame.size.height)
        addButton.frame = CGRect(x: view.frame.size.width - 100,
                                 y: view.frame.size.height - 100,
                                 width: 44, height: 44)
    }
    
    private func setupBinding() {
        viewModel.models.bind(to: tableView.rx.items(cellIdentifier: "cell")) { row, item, cell in
            guard let cell = cell as? TableCell else { return }
            cell.setModel(item)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Model.self).subscribe( onNext: { [weak self] model in
            guard let self = self else { return }
            self.pushCounter(model)
        }).disposed(by: disposeBag)
        
        addButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.addCounter()
            }).disposed(by: disposeBag)
    }
}

