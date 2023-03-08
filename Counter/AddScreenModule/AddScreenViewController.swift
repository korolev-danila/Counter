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
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name new counter"
        tf.font = UIFont.systemFont(ofSize: 20)
        tf.backgroundColor = .clear
        tf.layer.cornerRadius = 15.0
        tf.layer.borderWidth = 2.0
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.borderStyle = UITextField.BorderStyle.none
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = UITextField.ViewMode.always
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.keyboardType = UIKeyboardType.default
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextField.ViewMode.whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let modLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a mode:"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let modPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let startCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Start count:"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "0"
        tf.font = UIFont.systemFont(ofSize: 20)
        tf.backgroundColor = .clear
        tf.layer.cornerRadius = 15.0
        tf.layer.borderWidth = 2.0
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.borderStyle = UITextField.BorderStyle.none
        tf.contentMode = .center
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = UITextField.ViewMode.always
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.keyboardType = UIKeyboardType.numberPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let pickerLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a step:"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let valuePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
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
        view.addSubview(nameTextField)
        view.addSubview(cancelButton)
        view.addSubview(modLabel)
        view.addSubview(modPicker)
        view.addSubview(startCountLabel)
        view.addSubview(countTextField)
        view.addSubview(pickerLabel)
        view.addSubview(valuePicker)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            nameTextField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            nameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
        ])
        NSLayoutConstraint.activate([
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            cancelButton.topAnchor.constraint(equalTo: nameTextField.topAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.widthAnchor.constraint(equalToConstant: 66)
        ])
        
        NSLayoutConstraint.activate([
            modLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            modLabel.widthAnchor.constraint(equalToConstant: 144),
            modLabel.heightAnchor.constraint(equalToConstant: 44),
            modLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            modPicker.leadingAnchor.constraint(equalTo: modLabel.trailingAnchor, constant: 16),
            modPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            modPicker.heightAnchor.constraint(equalToConstant: 44),
            modPicker.topAnchor.constraint(equalTo: modLabel.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            startCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startCountLabel.heightAnchor.constraint(equalToConstant: 44),
            startCountLabel.trailingAnchor.constraint(equalTo: modLabel.trailingAnchor),
            startCountLabel.topAnchor.constraint(equalTo: modLabel.bottomAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            countTextField.leadingAnchor.constraint(equalTo: startCountLabel.trailingAnchor, constant: 16),
            countTextField.heightAnchor.constraint(equalToConstant: 44),
            countTextField.widthAnchor.constraint(equalToConstant: 44),
            countTextField.topAnchor.constraint(equalTo: startCountLabel.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pickerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pickerLabel.heightAnchor.constraint(equalToConstant: 44),
            pickerLabel.trailingAnchor.constraint(equalTo: modLabel.trailingAnchor),
            pickerLabel.topAnchor.constraint(equalTo: startCountLabel.bottomAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            valuePicker.leadingAnchor.constraint(equalTo: pickerLabel.trailingAnchor, constant: 8),
            valuePicker.heightAnchor.constraint(equalToConstant: 88),
            valuePicker.widthAnchor.constraint(equalToConstant: 66),
            valuePicker.centerYAnchor.constraint(equalTo: pickerLabel.centerYAnchor)
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
        bindingTextField()
        bindingModPicker()
        bindingValuePicker()
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
    
    private func bindingTextField() {
        nameTextField.rx.text
                    .orEmpty
                    .bind(to: viewModel.nameSubj)
                    .disposed(by: disposeBag)
        viewModel.nameSubj
            .subscribe(onNext: { [unowned self] text in
                viewModel.localModel.name = text
            })
            .disposed(by: disposeBag)

        countTextField.rx.text
                    .orEmpty
                    .bind(to: viewModel.countSubj)
                    .disposed(by: disposeBag)
        viewModel.countSubj
            .subscribe(onNext: { [unowned self] text in
                guard let int = Int(text) else { print("error save count"); return }
                viewModel.localModel.count = int
            })
            .disposed(by: disposeBag)
    }
    
    private func bindingModPicker() {
        Observable.just(["classic", "minimal", "time counter"])
                        .bind(to: modPicker.rx.itemTitles) { _, item in
                            return item
                        }
                        .disposed(by: disposeBag)

        modPicker.rx.itemSelected
                        .subscribe(onNext: { [unowned self] (row, value) in
                            switch row {
                            case 0:
                                viewModel.localModel.type = .classic
                            case 1:
                                viewModel.localModel.type = .minimal
                            case 2:
                                viewModel.localModel.type = .timeCounter
                            default:
                                print("failed to recognize the row modPicker")
                            }
                        })
                        .disposed(by: disposeBag)
    }
    
    private func bindingValuePicker() {
        Observable.just([1, 2, 3, 4, 5, 6, 7, 8, 9])
                        .bind(to: valuePicker.rx.itemTitles) { _, item in
                            return "+\(item)"
                        }
                        .disposed(by: disposeBag)

        valuePicker.rx.itemSelected
                        .subscribe(onNext: { [unowned self] (row, _) in
                            viewModel.localModel.value = row + 1
                        })
                        .disposed(by: disposeBag)
    }
    
}
