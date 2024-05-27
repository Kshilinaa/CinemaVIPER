// MoviesViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Экран со списком фильмов
final class MoviesViewController: UIViewController {
    // MARK: - Constants

    enum Constants {
        static let titleLabelDescription = "Смотри исторические \nфильмы на "
        static let titleLabelCinemaName = "CINEMA STAR"
        static let topInset: CGFloat = 64
        static let leading: CGFloat = 16
        static let trailing: CGFloat = -16
        static let titleHeight: CGFloat = 50
        static let inset: CGFloat = 15
        static let moviesCollectionViewIdentifier = "moviesCollectionViewIdentifier"
    }

    /// ViewModel списка фильмов
    let moviesViewModel: MoviesViewModel?
    /// Массив фильмов
    var movies: [Movie]?

    // MARK: - Visual Components

    private let gradientLayer = CAGradientLayer()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        let attributedText = NSMutableAttributedString(string: Constants.titleLabelDescription, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)
        ])
        let cinemaStarAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ]
        let cinemaStar = NSMutableAttributedString(
            string: Constants.titleLabelCinemaName,
            attributes: cinemaStarAttributes
        )
        attributedText.append(cinemaStar)
        label.attributedText = attributedText
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.accessibilityIdentifier = Constants.moviesCollectionViewIdentifier
        return collectionView
    }()

    // MARK: - Initializers

    init(moviesViewModel: MoviesViewModel?) {
        self.moviesViewModel = moviesViewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        moviesViewModel?.fetchMovies {
            self.collectionView.reloadData()
        }
        makeGradientBackgroundColor()
        setupSubviews()
        configureCollectionView()
        makeLabelConstraints()
        makeCollectionConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
    }

    private func makeGradientBackgroundColor() {
        gradientLayer.colors = [
            UIColor(named: "topColor")?.cgColor ?? UIColor.clear.cgColor,
            UIColor(named: "bottonColor")?.cgColor ?? UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func configureCollectionView() {
        collectionView.register(
            MoviesCollectionViewCell.self,
            forCellWithReuseIdentifier: MoviesCollectionViewCell().identifier
        )
        collectionView.register(
            MoviesShimmerCollectionViewCell.self,
            forCellWithReuseIdentifier: MoviesShimmerCollectionViewCell.identifier
        )
    }

    private func makeLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: Constants.topInset
        ).isActive = true
        titleLabel.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: Constants.leading
        ).isActive = true
        titleLabel.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: Constants.trailing
        ).isActive = true
        titleLabel.bottomAnchor.constraint(
            equalTo: collectionView.topAnchor,
            constant: -Constants.inset
        ).isActive = true
    }

    private func makeCollectionConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(
            equalTo: titleLabel.bottomAnchor,
            constant: Constants.inset
        ).isActive = true
        collectionView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: Constants.leading
        ).isActive = true
        collectionView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: Constants.trailing
        ).isActive = true
        collectionView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor
        ).isActive = true
    }
}

// MARK: - MoviesViewController + UICollectionViewDataSource

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch moviesViewModel?.state {
        case .loading:
            return 6
        case let .data(movies):
            return movies.count
        default:
            return 1
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch moviesViewModel?.state {
        case .loading:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MoviesShimmerCollectionViewCell.identifier,
                for: indexPath
            ) as? MoviesShimmerCollectionViewCell else { return UICollectionViewCell() }
            cell.startShimming()
            return cell
        case let .data(movies):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MoviesCollectionViewCell.identifier,
                for: indexPath
            ) as? MoviesCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(movie: movies[indexPath.item])

            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
}

// MARK: - MoviesViewController + UICollectionViewDelegateFlowLayout

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: 170,
            height: 250
        )
    }
}

// MARK: - MoviesViewController + UICollectionViewDelegate

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movies = moviesViewModel?.movies[indexPath.item] else { return }
        moviesViewModel?.moveToMovieDetailScreen(
            id: movies.id
        )
    }
}
