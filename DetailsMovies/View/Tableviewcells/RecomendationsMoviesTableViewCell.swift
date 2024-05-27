// RecomendationsMoviesTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

//
//  SimilarMoviesTableViewCell.swift
//  CinemaStar
//
//  Created by Ксения Шилина on 27.04.2024.
import UIKit

/// Ячейка с похожиии фильмами
final class RecomendationsMoviesTableViewCell: UITableViewCell {
    // MARK: - Constants

    enum Constants {
        static let identifier = "RecomendationsMoviesTableViewCell"
        static let titleLabel = "Смотрите также"
        static let verticalInset: CGFloat = 13
        static let leading: CGFloat = 6
    }

    // MARK: - Visual Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.text = Constants.titleLabel
        label.textColor = .white
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 18
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    // MARK: - Private Properties

    private var similarMovies: [Movie]?

    // MARK: - Initalizers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
        configureCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        configureCollectionView()
    }

    // MARK: - Public Methods

    /// Настройка ячейки с данными
    func configureCell(info: MovieDetail) {
        similarMovies = info.similarMovies
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
    }

    private func configureCollectionView() {
        collectionView.register(
            RecomendationsMoviesCollectionViewCell.self,
            forCellWithReuseIdentifier: RecomendationsMoviesCollectionViewCell().identifier
        )
    }

    private func setupConstraints() {
        makeTitleLabelConstraints()
        makeCollectionViewConstraints()
    }

    private func makeCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(
            equalTo: titleLabel.bottomAnchor,
            constant: Constants.verticalInset
        ).isActive = true
        collectionView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor
        ).isActive = true
        collectionView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor
        ).isActive = true
        collectionView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor
        ).isActive = true
        collectionView.heightAnchor.constraint(
            equalToConstant: 200
        ).isActive = true
        collectionView.widthAnchor.constraint(
            equalToConstant: 300
        ).isActive = true
    }

    private func makeTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor
        ).isActive = true
        titleLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor
        ).isActive = true
        titleLabel.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor
        ).isActive = true
        titleLabel.heightAnchor.constraint(
            equalToConstant: 20
        ).isActive = true
    }
}

// MARK: - SimilarMoviesTableViewCell + UICollectionViewDataSource

extension RecomendationsMoviesTableViewCell: UICollectionViewDataSource {
    /// Количество ячеек в коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let similarMovies = similarMovies else { return 1 }
        return similarMovies.count
    }

    /// Минимальный интервал между ячейками в коллекции
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecomendationsMoviesCollectionViewCell().identifier,
            for: indexPath
        ) as? RecomendationsMoviesCollectionViewCell
        else { return UICollectionViewCell() }

        if let similarMovies = similarMovies {
            cell.configureWith(data: similarMovies[indexPath.row])
        }

        return cell
    }
}

// MARK: - SimilarMoviesTableViewCell + UICollectionViewDelegateFlowLayout

extension RecomendationsMoviesTableViewCell: UICollectionViewDelegateFlowLayout {
    /// Размер ячейки коллекции
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 170, height: 248)
    }

    /// Настройка ячейки коллекции
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        100
    }
}
