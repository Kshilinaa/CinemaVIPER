// RecommendedShimmerCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка с рекомендациями фильма для отображения заглушек (шиммеров)
class RecommendedShimmerCell: UITableViewCell {
    // MARK: - Constants

    static var identifier: String {
        String(describing: self)
    }

    // MARK: - Visual Components

    private lazy var mainCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.setupCollectionLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(
            RecommendedMovieShimmerCell.self,
            forCellWithReuseIdentifier: RecommendedMovieShimmerCell.identifier
        )
        collection.dataSource = self
        collection.backgroundColor = .clear
        return collection
    }()

    private let titleLabel: UIView = {
        let label = UIView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(named: "shimmer")
        label.layer.cornerRadius = 8
        return label
    }()

    // MARK: - Initializers

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        backgroundColor = .clear
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHierarchy()
        setupConstraints()
    }

    // MARK: - Public Methods

    func startShimmers() {
        layoutIfNeeded()
        titleLabel.startShimmeringAnimation(animationSpeed: 2.0)
    }

    // MARK: Private Methods

    private func setupHierarchy() {
        [
            titleLabel,
            mainCollectionView
        ].forEach { contentView.addSubview($0) }
    }

    private func setupConstraints() {
        contentView.heightAnchor.constraint(equalToConstant: 276).isActive = true

        setupTitleLabelConstraint()
        setupMainCollectionViewConstraint()
    }

    private func setupCollectionLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = .init(width: 170, height: 230)

        return flowLayout
    }

    private func setupTitleLabelConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: -70
            ),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupMainCollectionViewConstraint() {
        NSLayoutConstraint.activate([
            mainCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainCollectionView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 10
            ),
            mainCollectionView.heightAnchor.constraint(equalToConstant: 240),
            mainCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension RecommendedShimmerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedMovieShimmerCell.identifier,
                for: indexPath
            ) as? RecommendedMovieShimmerCell
        else { return UICollectionViewCell() }
        cell.startShimmers(smallLabel: true)
        return cell
    }
}
