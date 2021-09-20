//
//  MainViewController.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 18.08.2021.
//

import UIKit
import Combine

class MainViewController: ViewController<MainView> {
    
    // MARK: - Properties
    
    private let viewModel: MainViewModelProtocol
    private lazy var cancellable = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    init(_ vm: MainViewModelProtocol) {
        self.viewModel = vm
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let tabBar = tabBarController else { return }
        tabBar.tabBar.backgroundImage = UIImage()
        tabBar.tabBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let tabBar = tabBarController else { return }
        tabBar.tabBar.backgroundImage = nil
        tabBar.tabBar.shadowImage = nil
    }
    
    // MARK: - Methods
    
    private func bind() {
        viewModel.output.currentTransformerMode
            .sink { [weak self] transformerName in
                self?.mainView.switchModeButton.setTitle(transformerName, for: .normal)
            }
            .store(in: &cancellable)
        
        viewModel.output.currentMode
            .dropFirst()
            .sink { [weak self] mode in
                print(mode)
                switch mode {
                case .content(let initialValue, let content):
                    self?.mainView.contentView.inputTextView.text = initialValue
                    self?.mainView.contentView.outputTextView.text = content
                    self?.mainView.fireButton.setState(to: .still)
                    self?.mainView.sourceInputView.mode.value = .still
                case .error(let error):
                    self?.handleError(error)
                    self?.mainView.fireButton.setState(to: .still)
                case .loading:
                    self?.mainView.fireButton.setState(to: .loading)
                case .empty:
                    self?.mainView.sourceInputView.mode.value = .forced(isOpen: false)
                }
            }
            .store(in: &cancellable)
        
        mainView.sourceInputView.textPublisher
            .sink { [weak self] entry in
                self?.viewModel.input.transformAction.send(entry)
            }
            .store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification, object: nil)
            .sink { [weak self] notification in self?.keyboardWillShow(notification) }
            .store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification, object: nil)
            .sink { [weak self] notification in self?.keyboardWillHide(notification) }
            .store(in: &cancellable)
        
        mainView.switchModeButton.addTarget(self, action: #selector(mode), for: .touchUpInside)
        mainView.fireButton.addTarget(self, action: #selector(fire), for: .touchUpInside)
        mainView.contentView.favouriteButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        mainView.contentView.catsButton.addTarget(self, action: #selector(openCats), for: .touchUpInside)
    }
    
    @objc
    private func fire() {
        switch mainView.sourceInputView.mode.value {
        case .opened, .forced:
            guard let text = mainView.sourceInputView.textView.text else { return }
            viewModel.input.transformAction.send(text)
        default:
            guard let text = mainView.contentView.inputTextView.text else { return }
            viewModel.input.transformAction.send(text)
        }
    }
    
    @objc
    private func mode() {
        viewModel.input.openSettingsAction.send()
    }
    
    @objc
    private func openCats() {
        viewModel.input.openCatsAction.send()
    }
    
    @objc
    private func save() {
        viewModel.input.addToFavouritesAction.send()
    }
    
    private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        
        UIView.animate(withDuration: duration) { [weak self] in
            self?.mainView.keyBoardBinder(keyboardFrame.height)
            self?.mainView.layoutIfNeeded()
        }
    }
    
    private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        
        UIView.animate(withDuration: duration) { [weak self] in
            self?.mainView.keyBoardBinder(0)
            self?.mainView.layoutIfNeeded()
        }
    }
    
    enum InputError: Error {
        case empty
    }
    
    private func handleError(_ error: Error) {
        let alert = UIAlertController(title: "Error occured!", message: "Were so sorry.", preferredStyle: .alert)
        alert.addAction(.init(title: "uwu", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}
