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
    
    private var changePlusButtonCenter: CGPoint!
    private var goToTableButtonCenter: CGPoint!
    private var zeroingButtonCenter: CGPoint!
    private var buttonsHidden = false {
        didSet {
            UIView.transition(with: view, duration: 0.4, options: .transitionCrossDissolve) {
                self.shuffleButton.isHidden = !self.buttonsHidden
                self.changePlusButton.isHidden = self.buttonsHidden
                self.goToTableButton.isHidden = self.buttonsHidden
                self.zeroingButton.isHidden = self.buttonsHidden
            }
        }
    }
    
    private let digitsLabel: UILabel = {
        let label = UILabel()
        label.text = "121212"
        label.font = UIFont.systemFont(ofSize: 144)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.02
        label.baselineAdjustment = .alignBaselines
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let shuffleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus.circle", withConfiguration:
                                    UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)), for: .normal) // minus.circle
        button.contentMode = .scaleAspectFit
        button.tintColor = .label
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
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
        viewModel.zeroingCount()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    // MARK: - Private method
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(digitsLabel)
        view.addSubview(tapButton)
        
        view.addSubview(shuffleButton)
        view.addSubview(changePlusButton)
        view.addSubview(goToTableButton)
        view.addSubview(zeroingButton)
        
        digitsLabel.frame = CGRect(x: 16, y: 0,
                                   width: view.frame.size.width / 1.1,
                                   height: view.frame.size.height / 1.1)
        tapButton.frame = CGRect(x: 16, y: 128,
                                 width: view.frame.size.width - 32,
                                 height: view.frame.size.height / 1.5)
        
        shuffleButton.frame = CGRect(x: view.center.x - 32,
                                     y: view.frame.size.height - 128,
                                     width: 64, height: 64)
        
        changePlusButton.frame = CGRect(x: view.center.x - 96,
                                     y: view.frame.size.height - 136,
                                     width: 64, height: 64)
        goToTableButton.frame = CGRect(x: view.center.x - 32,
                                     y: view.frame.size.height - 136,
                                     width: 64, height: 64)
        zeroingButton.frame = CGRect(x: view.center.x + 32,
                                     y: view.frame.size.height - 136,
                                     width: 64, height: 64)

        changePlusButtonCenter = changePlusButton.center
        goToTableButtonCenter = goToTableButton.center
        zeroingButtonCenter = zeroingButton.center
        
        changePlusButton.center = shuffleButton.center
        goToTableButton.center = shuffleButton.center
        zeroingButton.center = shuffleButton.center
        
        buttonsHidden = true
    }
    
    private func animateButtons() {
        if buttonsHidden {
            UIView.animate(withDuration: 0.4) {
                self.buttonsHidden = false
                self.changePlusButton.center = self.changePlusButtonCenter
                self.goToTableButton.center = self.goToTableButtonCenter
                self.zeroingButton.center = self.zeroingButtonCenter
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.changePlusButton.center = self.shuffleButton.center
                self.goToTableButton.center = self.shuffleButton.center
                self.zeroingButton.center = self.shuffleButton.center
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(40) ) {
                self.buttonsHidden = true
            }
        }
    }
    
    private func setupBinding() {
        tapButton.rx
            .tap
            .throttle(.milliseconds(50), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.updateCount()
            })
            .disposed(by: disposeBag)
        
        shuffleButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.animateButtons()
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
                self?.animateButtons()
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
