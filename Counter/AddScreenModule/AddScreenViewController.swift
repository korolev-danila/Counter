//
//  AddScreenViewController.swift
//  Counter
//
//  Created by Данила on 03.03.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class AddScreenViewController: UIViewController {
    
    private let viewModel: AddScreenViewModel
    
    private let disposeBag = DisposeBag()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name new counter"
        tf.font = UIFont.systemFont(ofSize: 20)
        tf.backgroundColor = .clear
        tf.layer.cornerRadius = 15.0
        tf.layer.borderWidth = 2.0
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = UITextField.BorderStyle.none
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = UITextField.ViewMode.always
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.keyboardType = UIKeyboardType.default
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextField.ViewMode.whileEditing
        return tf
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15.0
        button.contentMode = .scaleAspectFit
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - init
    init(viewModel: AddScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBinding()
    }
    
    deinit {
        print("deinit \(self.self)" )
    }
    
    // MARK: - Private methods
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(textField)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.widthAnchor.constraint(equalToConstant: 66)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            saveButton.widthAnchor.constraint(equalToConstant: 88)
        ])
    }
}

// MARK: - Binding
extension AddScreenViewController {
    private func setupBinding() {
        bindingButtons()
    }
    
    private func bindingButtons() {
        saveButton.rx
            .tap
            .subscribe(onNext: { [unowned self] in
                viewModel.addCounter()
                dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        cancelButton.rx
            .tap
            .subscribe(onNext: { [unowned self] in
                viewModel.dissmisAddScreen(nil)
                dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
}
