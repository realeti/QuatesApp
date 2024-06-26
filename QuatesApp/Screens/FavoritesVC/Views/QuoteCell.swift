//
//  QuoteCell.swift
//  QuatesApp
//
//  Created by Apple M1 on 25.06.2024.
//

import UIKit

class QuoteCell: UITableViewCell {
    // MARK: - UI
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .white
        return view
    }()
    
    private let quoteStackView = UIStackView(
        axis: .vertical, 
        spacing: 10,
        distribution: .fillProportionally
    )
    
    private lazy var quoteTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isScrollEnabled = false
        view.textColor = .dark
        view.textAlignment = .left
        view.font = UIFont(name: K.fontPTSerifItalic, size: 14)
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        view.backgroundColor = .clear
        return view
    }()
    
    private let authorLabel = UILabel(
        textColor: .heavyGray,
        alignment: .left,
        font: UIFont(name: K.fontPTSerifItalic, size: 12)
    )
    
    // MARK: - Static Properties
    static let reuseIdentifier = K.quoteReuseIdentifier
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        quoteTextView.text = nil
        authorLabel.text = nil
    }
    
    // MARK: - Set Views
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(quoteStackView)
        quoteStackView.addArrangedSubview(quoteTextView)
        quoteStackView.addArrangedSubview(authorLabel)
    }
}

// MARK: - Configure UI
extension QuoteCell {
    private func configureUI() {
        backgroundColor = .snow
        selectionStyle = .none
    }
}

// MARK: - Configure Cell
extension QuoteCell {
    func configure(text: String, author: String) {
        quoteTextView.text = text
        authorLabel.text = "- \(author)"
    }
}

// MARK: - Setup Constraints
extension QuoteCell {
    private func setupConstraints() {
        setupContainerViewConstraints()
        quoteStackViewSetupConstraints()
        authorLabelSetupConstraints()
    }
    
    private func setupContainerViewConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(160)
        }
    }
    
    private func quoteStackViewSetupConstraints() {
        quoteStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    private func authorLabelSetupConstraints() {
        authorLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
}
