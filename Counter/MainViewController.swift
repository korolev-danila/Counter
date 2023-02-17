//
//  MainViewController.swift
//  Counter
//
//  Created by Данила on 15.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    
    private let disposeBag = DisposeBag()
    
    var count = 0
    
    private let digitsLabel: UILabel = {
        let label = UILabel()
        label.text = "99999"
        label.font = UIFont.systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.2
        label.baselineAdjustment = .alignBaselines
        label.textAlignment  = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print(count)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(digitsLabel)
        view.addSubview(tapButton)
        
        tapButton.backgroundColor = .red
        
        NSLayoutConstraint.activate([
            digitsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            digitsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            tapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapButton.topAnchor.constraint(equalTo: digitsLabel.bottomAnchor)
        ])
    }
    
    private func setupBinding() {
        
        tapButton.rx
            .tap
            .throttle(.milliseconds(50), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.count += 1
                self?.digitsLabel.text = "\(self?.count ?? 0)"
            })
            .disposed(by: disposeBag)
    }
}
