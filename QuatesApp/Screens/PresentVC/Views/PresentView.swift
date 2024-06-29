//
//  PresentView.swift
//  QuatesApp
//
//  Created by Apple M1 on 29.06.2024.
//

import UIKit

final class PresentView: UIView {
    // MARK: - UI
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: K.systemCloseButton)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.black)
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
    
    lazy var randomImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(resource: .redo)
            .withTintColor(.heavyGray.withAlphaComponent(0.12))
        imageView.image = image
        return imageView
    }()
    
    let sectionLabel = UILabel(
        text: K.randomQuote,
        textColor: .dark,
        font: UIFont(name: K.fontMontserrat400, size: 36)
    )
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .snow
        view.layer.cornerRadius = 25
        view.makeShadow(color: .heavyGray)
        view.clipsToBounds = false
        return view
    }()
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let quoteStackView = UIStackView(axis: .vertical, spacing: 20)
    
    lazy var quoteTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isScrollEnabled = false
        view.textColor = .dark
        view.textAlignment = .center
        view.font = UIFont(name: K.fontPTSerifItalic, size: 22)
        view.backgroundColor = .clear
        return view
    }()
    
    let authorLabel = UILabel(
        textColor: .heavyGray,
        alignment: .center,
        font: UIFont(name: K.fontPTSerifItalic, size: 19)
    )
    
    lazy var heartButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(resource: .heartOutline)
        button.isUserInteractionEnabled = false
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set Views
    private func setupUI() {
        addSubview(closeButton)
        addSubview(randomImageView)
        addSubview(sectionLabel)
        addSubview(containerView)
        containerView.addSubview(activityIndicator)
        containerView.addSubview(quoteStackView)
        quoteStackView.addArrangedSubview(quoteTextView)
        quoteStackView.addArrangedSubview(authorLabel)
        containerView.addSubview(heartButton)
    }
}

// MARK: - Configure UI
extension PresentView {
    private func configureUI() {
        backgroundColor = .snow
    }
}

// MARK: - Setup Constraints
extension PresentView {
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
            make.top.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(Metrics.closeButtonHeight)
        }
    }
    
    private func randomImageViewSetupConstraints() {
        randomImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(32)
            make.leading.equalTo(sectionLabel.snp.leading).offset(22)
            make.width.height.equalTo(Metrics.randomImageViewHeight)
        }
    }
    
    private func sectionLabelSetupConstraints() {
        sectionLabel.snp.makeConstraints { make in
            make.top.equalTo(randomImageView.snp.bottom).offset(-18)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(25)
        }
    }
    
    private func containerViewSetupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(10)
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
