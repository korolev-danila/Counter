//
//  MainViewController.swift
//  Counter
//
//  Created by Данила on 15.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    
    private let viewModel: MainViewModel
    
    private let disposeBag = DisposeBag()
        
    private var changePlusButtonCenter: CGPoint?
    private var goToTableButtonCenter: CGPoint?
    private var zeroingButtonCenter: CGPoint?
    private var buttonsIsHidden = false {
        didSet {
            changePlusButton.isHidden = buttonsIsHidden
            goToTableButton.isHidden = buttonsIsHidden
            zeroingButton.isHidden = buttonsIsHidden
        }
    }
    
    private var isPlus = true
    private var isFirstPlusChange = true
    
    private let digitsLabel: UILabel = {
        let label = UILabel()
        label.text = "121212"
        label.font = UIFont.systemFont(ofSize: 212)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.02
        label.baselineAdjustment = .alignBaselines
        label.textAlignment = .center
        return label
    }()
    
    private let tapButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let shuffleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle", withConfiguration:
                                    UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .label
        return button
    }()
    
    private let changePlusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle", withConfiguration:
                                    UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .label
        return button
    }()
    
    private let mockPlusImg: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "minus.circle",
                             withConfiguration: UIImage.SymbolConfiguration(pointSize: 44,
                                                                            weight: .regular))
        view.tintColor = .label
        view.contentMode = .scaleToFill
        view.contentMode = .center
        view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
        view.isHidden = true
        return view
    }()
    
    private let goToTableButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.turn.up.left.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .label
        return button
    }()
    
    private let zeroingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "c.circle", withConfiguration:
                                    UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .label
        return button
    }()
    
    // MARK: - init
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
        viewModel.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.viewWillDisappear()
    }
    
    deinit {
        print("deinit \(self)" )
    }
    
    // MARK: - Private method
    private func setupView() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        
        view.addSubview(digitsLabel)
        view.addSubview(tapButton)
        
        view.addSubview(shuffleButton)
        view.addSubview(changePlusButton)
        view.addSubview(mockPlusImg)
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
        mockPlusImg.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        mockPlusImg.center = changePlusButton.center
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
        
        buttonsIsHidden = true
        changePlusButton.alpha = 0
        goToTableButton.alpha = 0
        zeroingButton.alpha = 0
    }
    
    private func changePlusImg() {
        let str = isPlus ? "plus.circle" : "minus.circle"
        shuffleButton.setImage(UIImage(systemName: str, withConfiguration:
                                        UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)), for: .normal)
        changePlusButton.setImage(UIImage(systemName: str, withConfiguration:
                                            UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)), for: .normal)
    }
    
    // MARK: - Animation
    private func animateButtons() {
        guard let goToCenter = goToTableButtonCenter,
              let changeCenter = changePlusButtonCenter,
              let zeroimgCenter = zeroingButtonCenter else { return }
        
        let bool = buttonsIsHidden
        
        if buttonsIsHidden {
            shuffleButton.isEnabled = false
            buttonsIsHidden = false
        } else {
            perform(#selector(hideButtons), with: nil, afterDelay: 0.25)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.changePlusButton.center = bool ? changeCenter : self.shuffleButton.center
            self.goToTableButton.center = bool ? goToCenter : self.shuffleButton.center
            self.zeroingButton.center = bool ? zeroimgCenter : self.shuffleButton.center
            
            self.changePlusButton.alpha = bool ? 1 : 0
            self.goToTableButton.alpha = bool ? 1 : 0
            self.zeroingButton.alpha = bool ? 1 : 0
            self.shuffleButton.alpha = bool ? 0 : 1
        }
    }
    @objc private func hideButtons() {
        buttonsIsHidden = true
        shuffleButton.isEnabled = true
    }
    
    private func animatePlus() {
        if isPlus {
            mockPlusImg.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.25) {
                self.mockPlusImg.isHidden = false
                self.mockPlusImg.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
            }
            perform(#selector(showMockPlus), with: nil, afterDelay: 0.25)
            
        } else {
            UIView.animate(withDuration: 0.25) {
                self.mockPlusImg.isHidden = false
                self.changePlusImg()
                self.mockPlusImg.transform = CGAffineTransform.identity
            }
            perform(#selector(hideMockPlus), with: nil, afterDelay: 0.25)
        }
    }
    @objc private func showMockPlus() {
        changePlusImg()
        mockPlusImg.isHidden = true
    }
    @objc private func hideMockPlus() {
        mockPlusImg.isHidden = true
    }
}

// MARK: - Binding
extension MainViewController {
    private func setupBinding() {
        bindViewModel()
        bindTapButton()
        bindAllButton()
    }
    
    private func bindViewModel() {
        viewModel.countSubj
            .bind(to: digitsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isPlusSubj
            .subscribe({ [unowned self] item in
                guard let bool = item.element else { return }
                isPlus = bool
                
                if !isFirstPlusChange {
                    animatePlus()
                } else {
                    changePlusImg()
                    isFirstPlusChange = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTapButton() {
        tapButton.rx
            .tap
            .throttle(.milliseconds(50), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                viewModel.updateCount()
                if !buttonsIsHidden { animateButtons() }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAllButton() {
        shuffleButton.rx
            .tap
            .subscribe(onNext: { [unowned self] in
                animateButtons()
            })
            .disposed(by: disposeBag)
        
        changePlusButton.rx
            .tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                viewModel.changePlus()
            })
            .disposed(by: disposeBag)
        
        goToTableButton.rx
            .tap
            .subscribe(onNext: { [unowned self] in
                animateButtons()
            })
            .disposed(by: disposeBag)
        
        zeroingButton.rx
            .tap
            .subscribe(onNext: { [unowned self] in
                viewModel.zeroingCount()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
