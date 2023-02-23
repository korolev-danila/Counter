//
//  TableViewController.swift
//  Counter
//
//  Created by Данила on 21.02.2023.
//

import UIKit

final class TableViewController: UIViewController {
    
    private let viewModel: TableViewModel

    private let tableView: UITableView = {
        let tv = UITableView(frame: CGRect(), style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(TableCell.self, forCellReuseIdentifier: "cell")
        tv.backgroundColor = .clear
        return tv
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
    }
    
    // MARK: - Private methods
    private func setupView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0,
                                 width: view.frame.size.width,
                                 height: view.frame.size.height)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TableCell
        cell.backgroundColor = .green
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // navigationController?.pushViewController(MainViewController(), animated: true)
    }
}
