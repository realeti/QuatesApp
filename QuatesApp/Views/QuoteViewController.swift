//
//  QuoteViewController.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import UIKit
import SnapKit

class QuoteViewController: UIViewController {
    
    // MARK: - UI
    private let closeButton = UIButton(type: .system)
    private let randomImageView = UIImageView()
    
    private let randomQuoteLabel = UILabel(
        text: K.randomQuote,
        font: UIFont(name: K.fontMontserrat400, size: 36)
    )
    
    private let containerView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private lazy var quoteStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        return view
    }()
    
    private lazy var quoteTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isScrollEnabled = false
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
    
    private let heartButton = UIButton(type: .system)
    
    // MARK: - Public Properties
    var viewModel: QuoteViewModel?
    var category: String?
    
    // MARK: - Private Properties
    private var quote: Quote?
    private var isInitialImage = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchQuote()
        configureUI()
        setupConstraints()
    }
    
    // MARK: - Set Views
    private func setupUI() {
        view.addSubview(closeButton)
        view.addSubview(randomImageView)
        view.addSubview(randomQuoteLabel)
        view.addSubview(containerView)
        containerView.addSubview(activityIndicator)
        containerView.addSubview(quoteStackView)
        quoteStackView.addArrangedSubview(quoteTextView)
        quoteStackView.addArrangedSubview(authorLabel)
        containerView.addSubview(heartButton)
    }
    
    // MARK: - Fetch Quote
    private func fetchQuote() {
        guard let viewModel = viewModel, let selectedCategory = category else {
            return
        }
        
        viewModel.fetchQuote(for: selectedCategory)
    }
    
    private func displayQuote() {
        guard let quote else { return }

        quoteTextView.text = quote.quote
        authorLabel.text = "- \(quote.author)"
    }
}

extension QuoteViewController: QuoteViewModelDelegate {
    func didFetchQuote(_ quote: Quote) {
        DispatchQueue.main.async { [weak self] in
            self?.quote = quote
            self?.displayQuote()
        }
    }

    func didFailFetchingQuote(_ error: Error) {
        let alert = UIAlertController(title: K.alertError, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: K.alertOk, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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

extension QuoteViewController {
    // MARK: - Configure UI

    private func configureUI() {
        view.backgroundColor = .snow
        configureRandomImageView()
        configureContainerView()
        configureCloseButton()
        configureHeartButton()
    }
    
    private func configureRandomImageView() {
        let image = UIImage(resource: .redo)
            .withTintColor(.heavyGray.withAlphaComponent(0.1))
        randomImageView.image = image
    }
    
    private func configureContainerView() {
        containerView.backgroundColor = .snow
        containerView.layer.cornerRadius = 25
        containerView.makeShadow(color: .heavyGray)
        containerView.clipsToBounds = false
    }
    
    private func configureCloseButton() {
        let image = UIImage(systemName: K.systemCloseButton)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.black)
        
        closeButton.setBackgroundImage(image, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
    }
    
    private func configureHeartButton() {
        let image = UIImage(resource: .heartOutline)
        heartButton.setBackgroundImage(image, for: .normal)
        
        heartButton.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
    }
}

extension QuoteViewController {
    // MARK: - Actions
    
    @objc private func heartButtonPressed(_ sender: UIButton) {
        changeHeartButtonImage()
        isInitialImage.toggle()
    }
    
    @objc private func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func changeHeartButtonImage() {
        let image: ImageResource = isInitialImage ? .heartFilled : .heartOutline
        let newImage = UIImage(resource: image)
        
        UIView.transition(with: heartButton, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.heartButton.setBackgroundImage(newImage, for: .normal)
        }, completion: nil)
    }
}

extension QuoteViewController {
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        closeButtonSetupConstraints()
        randomImageViewSetupConstraints()
        randomQuoteLabelSetupConstraints()
        containerViewSetupConstraints()
        activityIndicatorSetupConstraints()
        quoteStackViewSetupConstraints()
        heartButtonSetupConstraints()
    }
    
    private func closeButtonSetupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(22)
        }
    }
    
    private func randomImageViewSetupConstraints() {
        randomImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.leading.equalTo(randomQuoteLabel.snp.leading).offset(22)
            make.width.height.equalTo(85)
        }
    }
    
    private func randomQuoteLabelSetupConstraints() {
        randomQuoteLabel.snp.makeConstraints { make in
            make.top.equalTo(randomImageView.snp.bottom).offset(-18)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
    }
    
    private func containerViewSetupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(randomQuoteLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.greaterThanOrEqualTo(400)
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
            make.bottom.equalTo(heartButton.snp.top).offset(10).priority(.low)
        }
    }
    
    private func heartButtonSetupConstraints() {
        heartButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(15).priority(.low)
            make.height.width.equalTo(32)
        }
    }
}