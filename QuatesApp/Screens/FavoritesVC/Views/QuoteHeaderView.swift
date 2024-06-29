//
//  QuoteHeaderView.swift
//  QuatesApp
//
//  Created by Apple M1 on 25.06.2024.
//

import UIKit
import SnapKit

final class QuoteHeaderView: UIView {
    // MARK: - UI
    private let sectionImageView = UIImageView()
    private let sectionLabel = UILabel(
        text: K.favoriteQuotes,
        textColor: .dark,
        font: UIFont(name: K.fontMontserrat400, size: 32)
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set Views
    private func setupUI() {
        addSubview(sectionImageView)
        addSubview(sectionLabel)
    }
}

// MARK: - Configure UI
extension QuoteHeaderView {
    func configureUI(image: UIImage, title: String, section: SectionType) {
        setSectionImage(image)
        setSectionTitle(title)
        updateSectionLabelConstraints(for: section)
    }
    
    private func setSectionImage(_ image: UIImage) {
        let image = image
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.heavyGray.withAlphaComponent(0.12))
        
        sectionImageView.image = image
        sectionImageView.contentMode = .scaleAspectFit
    }
    
    private func setSectionTitle(_ title: String) {
        sectionLabel.text = title
    }
}

// MARK: - Setup Constraints
extension QuoteHeaderView {
    private func setupConstraints() {
        setupSectionImageViewConstraints()
        setupSectionLabelConstraints()
    }
    
    private func setupSectionImageViewConstraints() {
        sectionImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(sectionLabel.snp.leading).offset(22)
            make.width.height.equalTo(Metrics.sectionImageHeight)
        }
    }
    
    private func setupSectionLabelConstraints() {
        sectionLabel.snp.makeConstraints { make in
            make.top.equalTo(sectionImageView.snp.bottom).offset(Metrics.quotesTitleOffsetTop)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(25)
            make.bottom.equalToSuperview()
        }
    }
    
    private func updateSectionLabelConstraints(for section: SectionType) {
        sectionLabel.snp.updateConstraints { make in
            switch section {
            case .quote:
                make.top.equalTo(sectionImageView.snp.bottom).offset(Metrics.quotesTitleOffsetTop)
            case .joke:
                make.top.equalTo(sectionImageView.snp.bottom).offset(Metrics.jokesTitleOffsetTop)
            case .chucknorris:
                make.top.equalTo(sectionImageView.snp.bottom).offset(Metrics.chuckTitleOffsetTop)
            }
        }
    }
}

fileprivate struct Metrics {
    static let sectionImageHeight: CGFloat = 85.0
    
    static let quotesTitleOffsetTop: CGFloat = -18
    static let jokesTitleOffsetTop: CGFloat = -12
    static let chuckTitleOffsetTop: CGFloat = -4
    
    private init () {}
}
