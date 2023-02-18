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
    
    private let digitsLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 120)
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
    
    private let changePlusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle", withConfiguration:
                                    UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)), for: .normal) // minus.circle
        button.contentMode = .scaleAspectFit
        button.tintColor = .label
        return button
    }()
    
    private let goToTableButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrowshape.turn.up.left.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .label
        return button
    }()
    
    private let zeroingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "c.circle", withConfiguration:
                                    UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .label
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
        viewModel.zeroingCount()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(digitsLabel)
        view.addSubview(tapButton)
        view.addSubview(changePlusButton)
        view.addSubview(goToTableButton)
        view.addSubview(zeroingButton)
                
        NSLayoutConstraint.activate([
            digitsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            digitsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            tapButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tapButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tapButton.heightAnchor.constraint(equalTo: view.widthAnchor, constant: 64)
        ])
        NSLayoutConstraint.activate([
            changePlusButton.topAnchor.constraint(equalTo: goToTableButton.topAnchor),
            changePlusButton.trailingAnchor.constraint(equalTo: goToTableButton.leadingAnchor, constant: -16),
            changePlusButton.heightAnchor.constraint(equalToConstant: 44),
            changePlusButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        NSLayoutConstraint.activate([
            goToTableButton.topAnchor.constraint(equalTo: tapButton.bottomAnchor, constant: 32),
            goToTableButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToTableButton.heightAnchor.constraint(equalToConstant: 44),
            goToTableButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        NSLayoutConstraint.activate([
            zeroingButton.topAnchor.constraint(equalTo: goToTableButton.topAnchor),
            zeroingButton.leadingAnchor.constraint(equalTo: goToTableButton.trailingAnchor, constant: 16),
            zeroingButton.heightAnchor.constraint(equalToConstant: 44),
            zeroingButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupBinding() {
        tapButton.rx
            .tap
            .throttle(.milliseconds(50), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.updateCount()
            })
            .disposed(by: disposeBag)
        
        changePlusButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.changePlus()
            })
            .disposed(by: disposeBag)
        goToTableButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.updateCount()
            })
            .disposed(by: disposeBag)
        zeroingButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.zeroingCount()
            })
            .disposed(by: disposeBag)
        
        viewModel.countSubj
            .bind(to: digitsLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
