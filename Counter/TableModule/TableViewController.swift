//
//  TableViewController.swift
//  Counter
//
//  Created by Данила on 21.02.2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class TableViewController: UIViewController {
    
    private let viewModel: TableViewModel
    
//    typealias ModelListSectionModel = AnimatableSectionModel<String, Model>
//    var dataSource: RxTableViewSectionedAnimatedDataSource<ModelListSectionModel>!
    
    private var dataSource = RxTableViewSectionedAnimatedDataSource<CounterSection>(
        animationConfiguration: AnimationConfiguration(insertAnimation: .fade,
                                                       reloadAnimation: .fade,
                                                       deleteAnimation: .fade),
        configureCell: { (dataSource, tableView, IndexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath) as! TableCell
            cell.setViewModel(TableCellViewModel(withCounter: item))
            return cell
        },
        canEditRowAtIndexPath: { (dataSource, IndexPath) in
            return true
        }
    )
    
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
        setupNavBar()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear table")
        navigationController?.isNavigationBarHidden = false
        viewModel.fetchModels()
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.addSubview(tableView)
      //  view.addSubview(addButton)
        
        tableView.frame = CGRect(x: 0, y: 0,
                                 width: view.frame.size.width,
                                 height: view.frame.size.height)
//        addButton.frame = CGRect(x: view.frame.size.width - 100,
//                                 y: view.frame.size.height - 100,
//                                 width: 44, height: 44)
    }
    
    private func setupNavBar() {
        
        
        let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addNewItem))
        self.navigationItem.rightBarButtonItem = addButton
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editItems))
        self.navigationItem.leftBarButtonItem = editButton
    }
    @objc func addNewItem() {
        viewModel.addCounter()
    }
    @objc func editItems() {
        let editMode = tableView.isEditing
        tableView.setEditing(!editMode, animated: true)
    }
    
 /*
    private func setupBinding2() {
        
        
        viewModel.models.bind(to: tableView.rx.items(cellIdentifier: "cell")) { row, item, cell in
       //     guard let cell = cell as? TableCell else { return }
        //    cell.setModel(item)

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
  */
}

extension TableViewController {
    private func setupBinding() {
        setupDataSource()
        modelSelected()
        deleteBind()
    }
    
    private func setupDataSource() {
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func modelSelected() {
        tableView.rx.modelSelected(Model.self).subscribe( onNext: { [weak self] model in
            guard let self = self else { return }
            self.pushCounter(model)
        })
        .disposed(by: disposeBag)
    }
    
    private func deleteBind() {
        tableView.rx.itemDeleted
            .subscribe(onNext: { indexPath in
              //  self.colors.remove(at: indexPath.row)
             //   self.sections.accept([ColorSection(items: self.colors)])
            })
            .disposed(by: disposeBag)
    }
}

