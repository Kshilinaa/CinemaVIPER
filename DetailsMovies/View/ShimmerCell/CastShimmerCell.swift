// CastShimmerCell.swift
// Copyright © RoadMap. All rights reserved.

//
//  CastShimmerCell.swift
//  CinemaStar
import UIKit

/// Ячейка с актерами (шиммер)
final class CastShimmerCell: UITableViewCell {
    // MARK: Constants

    static var identifier: String {
        String(describing: self)
    }

    // MARK: Visual Components

    private let titleLabel: UIView = {
        let label = UIView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(named: "shimmer")
        label.layer.cornerRadius = 10
        return label
    }()

    private let languageTitleLabel: UIView = {
        let label = UIView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(named: "shimmer")
        label.layer.cornerRadius = 10
        return label
    }()

    private let languageNameLabel: UIView = {
        let label = UIView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(named: "shimmer")
        label.layer.cornerRadius = 10
        return label
    }()

    private lazy var mainCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.setupCollectionLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(ActorShimmerCell.self, forCellWithReuseIdentifier: ActorShimmerCell.identifier)
        collection.dataSource = self
        collection.backgroundColor = .clear
        return collection
    }()

    // MARK: Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHierarchy()
        setupConstraints()
    }

    // MARK: Public Methods

    func startShimmers() {
        layoutIfNeeded()
        titleLabel.startShimmeringAnimation(animationSpeed: 2.0)
        languageTitleLabel.startShimmeringAnimation(animationSpeed: 2.0)
        languageNameLabel.startShimmeringAnimation(animationSpeed: 2.0)
    }

    // MARK: Private Methods

    private func setupHierarchy() {
        [
            titleLabel,
            mainCollectionView,
            languageTitleLabel,
            languageNameLabel
        ].forEach { contentView.addSubview($0) }
    }

    private func setupConstraints() {
        contentView.heightAnchor.constraint(equalToConstant: 220).isActive = true

        setupTitleLabelConstraint()
        setupMainCollectionViewConstraint()
        setupLanguageTitleLabelConstraint()
        setupLanguageNameLabelConstraint()
    }

    private func setupCollectionLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumLineSpacing = 1.5
        flowLayout.minimumInteritemSpacing = 1.5
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }

    private func setupTitleLabelConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: -25
            ),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupMainCollectionViewConstraint() {
        NSLayoutConstraint.activate([
            mainCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainCollectionView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 5
            ),
            mainCollectionView.heightAnchor.constraint(equalToConstant: 120),
            mainCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupLanguageTitleLabelConstraint() {
        NSLayoutConstraint.activate([
            languageTitleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            languageTitleLabel.topAnchor.constraint(
                equalTo: mainCollectionView.bottomAnchor,
                constant: -30
            ),
            languageTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            languageTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupLanguageNameLabelConstraint() {
        NSLayoutConstraint.activate([
            languageNameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            languageNameLabel.topAnchor.constraint(
                equalTo: languageTitleLabel.bottomAnchor,
                constant: 7
            ),
            languageNameLabel.heightAnchor.constraint(equalToConstant: 20),
            languageNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

/// PersonsListShimmerViewCell + UICollectionViewDataSource
extension CastShimmerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ActorShimmerCell.identifier,
                for: indexPath
            ) as? ActorShimmerCell
        else { return UICollectionViewCell() }
        cell.startShimmers()
        return cell
    }
}
