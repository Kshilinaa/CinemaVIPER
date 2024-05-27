// ActorsTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

//
//  ActorsTableViewCell.swift
//  CinemaStar
import UIKit

/// Ячейка для отображения списка актеров и съемочной группы фильма
final class ActorsTableViewCell: UITableViewCell {
    // MARK: - Constants

    enum Constants {
        static let identifier = "ActorsTableViewCell"
        static let actorsCollectionViewIdentifier = "actorsCollectionViewIdentifier"
        static let titleLabel = "Актеры и съемочная группа "
        static let bottomConstant: CGFloat = 13
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
        collectionView.accessibilityIdentifier = "actorsCollectionViewIdentifier"
        return collectionView
    }()

    // MARK: - Private Properties

    private var actors: [MovieActor]?

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

    /// Настройка ячейки
    func configureCell(info: MovieDetail) {
        actors = info.actors
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
    }

    private func configureCollectionView() {
        collectionView.register(
            ActorsCollectionViewCell.self,
            forCellWithReuseIdentifier: ActorsCollectionViewCell().identifier
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
            constant: Constants.bottomConstant
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
            equalToConstant: 100
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

// MARK: - ActorsTableViewCell + UICollectionViewDataSource

extension ActorsTableViewCell: UICollectionViewDataSource {
    /// Количество ячеек в коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let actors = actors else { return 100 }
        return actors.count
    }

    /// Настройка ячейки коллекции
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ActorsCollectionViewCellIdentifier",
            for: indexPath
        ) as? ActorsCollectionViewCell
        else { return UICollectionViewCell() }

        if let actors = actors {
            print("actors are \(actors)")
            cell.configureWith(data: actors[indexPath.row])
        }

        return cell
    }
}

// MARK: - ActorsTableViewCell + UICollectionViewDelegateFlowLayout

extension ActorsTableViewCell: UICollectionViewDelegateFlowLayout {
    /// Размер ячейки коллекции
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 60, height: 100)
    }

    /// Минимальный интервал между ячейками в коллекции
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        100
    }
}
