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
        },
        canMoveRowAtIndexPath: { _, _ in
            return true
        }
    )
    
    private let disposeBag = DisposeBag()
    
    var showCounter: (Model, IndexPath) -> () = { _,_ in }
    var showAdd: () -> () = {}
    
    // MARK: - UIView
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
        navigationController?.isNavigationBarHidden = false
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
    
    private func setupNavBar() {
        let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addNewItem))
        self.navigationItem.rightBarButtonItem = addButton
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editItems))
        self.navigationItem.leftBarButtonItem = editButton
    }
    @objc func showAddScreen() {
        showAdd()
    }
    @objc func addNewItem() {
   //     viewModel.addCounter()
    }
    @objc func editItems() {
        let editMode = tableView.isEditing
        tableView.setEditing(!editMode, animated: true)
    }
}

// MARK: - Binding
extension TableViewController {
    private func setupBinding() {
        setupDataSource()
        modelSelected()
        deleteBind()
        itemMoved()
        addButton.addTarget(self, action: #selector(showAddScreen), for: .touchUpInside)
    }
    
    private func setupDataSource() {
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func modelSelected() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Model.self))
            .bind { [unowned self] indexPath, model in
                showCounter(model, indexPath)
                print("Selected " + "\(model.count)" + " at \(indexPath)")
            }
            .disposed(by: disposeBag)
    }
    
    private func deleteBind() {
        tableView.rx.itemDeleted
            .subscribe(onNext: { [unowned self] indexPath in
                viewModel.deleteItem(at: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    private func itemMoved() {
        tableView.rx.itemMoved
            .subscribe(onNext: { [unowned self] indexPaths in
                viewModel.itemMoved(at: indexPaths)
            })
            .disposed(by: disposeBag)
    }
}

