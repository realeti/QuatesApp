//
//  PresentViewController.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import UIKit
import SnapKit

class PresentViewController: UIViewController {
    
    // MARK: - UI
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: K.systemCloseButton)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.black)
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var randomImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(resource: .redo)
            .withTintColor(.heavyGray.withAlphaComponent(0.12))
        imageView.image = image
        return imageView
    }()
    
    private let sectionLabel = UILabel(
        text: K.randomQuote,
        textColor: .dark,
        font: UIFont(name: K.fontMontserrat400, size: 36)
    )
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .snow
        view.layer.cornerRadius = 25
        view.makeShadow(color: .heavyGray)
        view.clipsToBounds = false
        return view
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let quoteStackView = UIStackView(axis: .vertical, spacing: 20)
    
    private lazy var quoteTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isScrollEnabled = false
        view.textColor = .dark
        view.textAlignment = .center
        view.font = UIFont(name: K.fontPTSerifItalic, size: 22)
        view.backgroundColor = .clear
        return view
    }()
    
    private let authorLabel = UILabel(
        textColor: .heavyGray,
        alignment: .center,
        font: UIFont(name: K.fontPTSerifItalic, size: 19)
    )
    
    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .heartOutline)
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Public Properties
    var viewModel: QuoteViewModel?
    
    // MARK: - Private Properties
    private var isInitialImage = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUI()
        fetchData()
        setupConstraints()
    }
    
    // MARK: - Set Views
    private func setupUI() {
        view.addSubview(closeButton)
        view.addSubview(randomImageView)
        view.addSubview(sectionLabel)
        view.addSubview(containerView)
        containerView.addSubview(activityIndicator)
        containerView.addSubview(quoteStackView)
        quoteStackView.addArrangedSubview(quoteTextView)
        quoteStackView.addArrangedSubview(authorLabel)
        containerView.addSubview(heartButton)
    }
}

// MARK: - Configure UI
extension PresentViewController {
    private func configureUI() {
        view.backgroundColor = .snow
        configureSectionLabel()
    }
    
    private func configureSectionLabel() {
        guard let viewModel else { return }
        
        switch viewModel.sectionType {
        case .quote:
            sectionLabel.text = K.randomQuote
        default:
            sectionLabel.text = K.randomJoke
        }
    }
}

// MARK: - Fetch Data
extension PresentViewController {
    private func fetchData() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.fetchData()
    }
}

// MARK: - Quote ViewModel Delegate
extension PresentViewController: QuoteViewModelDelegate {
    func didFetchData(_ section: SectionType) {
        DispatchQueue.main.async { [weak self] in
            self?.configureUI(for: section)
        }
    }

    func didFailFetching(_ error: Error) {
        let alert = UIAlertController(title: K.alertError, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: K.alertOk, style: .default))
        present(alert, animated: true)
    }
    
    func didChangeLoadingState(isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
            }
        }
    }
}

// MARK: - Configure UI For Section
extension PresentViewController {
    private func configureUI(for section: SectionType) {
        guard let viewModel else { return }
        
        switch section {
        case .quote:
            guard let quote = viewModel.quote else { return }
            configureSection(
                text: quote.quote,
                author: "- \(quote.author)"
            )
        case .joke:
            guard let joke = viewModel.joke else { return }
            configureSection(
                text: joke.joke,
                author: "- \(K.authorRandomJoke)"
            )
        case .chucknorris:
            guard let chuckNorrisJoke = viewModel.chuckNorrisJoke else { return }
            configureSection(
                text: chuckNorrisJoke.joke,
                author: "- \(K.authorChuckNorrisJoke)"
            )
        }
    }
    
    private func configureSection(text: String, author: String) {
        quoteTextView.text = text
        authorLabel.text = author
    }
}

// MARK: - Actions
extension PresentViewController {
    @objc private func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func heartButtonPressed(_ sender: UIButton) {
        guard let viewModel else { return }
        
        viewModel.saveData()
        changeHeartButtonImage()
        isInitialImage.toggle()
    }
    
    private func changeHeartButtonImage() {
        let image: ImageResource = isInitialImage ? .heartFilled : .heartOutline
        let newImage = UIImage(resource: image)
        
        UIView.transition(with: heartButton, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.heartButton.setBackgroundImage(newImage, for: .normal)
        }, completion: nil)
    }
}

// MARK: - Setup Constraints
extension PresentViewController {
    private func setupConstraints() {
        closeButtonSetupConstraints()
        randomImageViewSetupConstraints()
        sectionLabelSetupConstraints()
        containerViewSetupConstraints()
        activityIndicatorSetupConstraints()
        quoteStackViewSetupConstraints()
        heartButtonSetupConstraints()
    }
    
    private func closeButtonSetupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(Metrics.closeButtonHeight)
        }
    }
    
    private func randomImageViewSetupConstraints() {
        randomImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.leading.equalTo(sectionLabel.snp.leading).offset(22)
            make.width.height.equalTo(Metrics.randomImageViewHeight)
        }
    }
    
    private func sectionLabelSetupConstraints() {
        sectionLabel.snp.makeConstraints { make in
            make.top.equalTo(randomImageView.snp.bottom).offset(-18)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
    }
    
    private func containerViewSetupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.greaterThanOrEqualTo(Metrics.containerViewHeight)
        }
    }
    
    private func activityIndicatorSetupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func quoteStackViewSetupConstraints() {
        quoteStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(heartButton.snp.top).offset(-10).priority(.low)
        }
    }
    
    private func heartButtonSetupConstraints() {
        heartButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
            make.height.width.equalTo(Metrics.heartButtonHeight)
        }
    }
}

fileprivate struct Metrics {
    static let closeButtonHeight: CGFloat = 22.0
    static let randomImageViewHeight: CGFloat = 85.0
    static let containerViewHeight: CGFloat = 400.0
    static let heartButtonHeight: CGFloat = 32.0
    
    private init () {}
}
