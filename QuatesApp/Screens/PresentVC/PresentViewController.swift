//
//  PresentViewController.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import SnapKit
import UIKit

final class PresentViewController: UIViewController {
    // MARK: - Public Properties

    var viewModel: QuoteViewModel?

    // MARK: - Private Properties

    private var presentView: PresentView!
    private var isInitialImage = true

    // MARK: - Life Cycle

    override func loadView() {
        super.loadView()

        presentView = PresentView()
        view = presentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchData()
    }
}

// MARK: - Configure UI

extension PresentViewController {
    private func configureUI() {
        configureSectionLabel()

        presentView.closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        presentView.heartButton.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
    }

    private func configureSectionLabel() {
        guard let viewModel else { return }

        switch viewModel.sectionType {
        case .quote:
            presentView.sectionLabel.text = Constants.randomQuote
        default:
            presentView.sectionLabel.text = Constants.randomJoke
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
            self?.presentView.heartButton.isUserInteractionEnabled = true
        }
    }

    func didFailFetching(_ error: Error) {
        let alert = UIAlertController(title: Constants.alertError, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.alertOk, style: .default))
        present(alert, animated: true)
    }

    func didChangeLoadingState(isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isLoading {
                self?.presentView.activityIndicator.startAnimating()
            } else {
                self?.presentView.activityIndicator.stopAnimating()
                self?.presentView.activityIndicator.removeFromSuperview()
            }
        }
    }

    func didSavedData() {
        print("Data saved")
    }

    func didFailSavedData(_ error: any Error) {
        print("Data not saved: \(error)")
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
                author: "- \(Constants.authorRandomJoke)"
            )
        case .chucknorris:
            guard let chuckNorrisJoke = viewModel.chuckNorrisJoke else { return }
            configureSection(
                text: chuckNorrisJoke.joke,
                author: "- \(Constants.authorChuckNorrisJoke)"
            )
        }
    }

    private func configureSection(text: String, author: String) {
        presentView.quoteTextView.text = text
        presentView.authorLabel.text = author
    }
}

// MARK: - Actions

extension PresentViewController {
    @objc private func closeButtonPressed(_: UIButton) {
        dismiss(animated: true)
    }

    @objc private func heartButtonPressed(_: UIButton) {
        guard let viewModel else { return }

        viewModel.saveData()
        changeHeartButtonImage()
        isInitialImage.toggle()
    }

    private func changeHeartButtonImage() {
        let image: ImageResource = isInitialImage ? .heartFilled : .heartOutline
        let newImage = UIImage(resource: image)

        UIView.transition(with: presentView.heartButton, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.presentView.heartButton.setBackgroundImage(newImage, for: .normal)
        }, completion: nil)
    }
}
