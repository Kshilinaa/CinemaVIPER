// RecommendedMovieShimmerCell.swift
// Copyright © RoadMap. All rights reserved.

//
//  RecommendedMovieShimmerCell.swift
//  CinemaStar
import UIKit

/// Ячейка с рекомендациями фильма для отображения заглушек (шиммеров)
class RecommendedMovieShimmerCell: UICollectionViewCell {
    // MARK: Constants

    static var identifier: String {
        String(describing: self)
    }

    // MARK: Visual Components

    private let mainImageView: UIView = {
        let imageView = UIView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = UIColor(named: "shimmer")
        return imageView
    }()

    private let nameLabel: UIView = {
        let label = UIView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(named: "shimmer")
        label.layer.cornerRadius = 8
        return label
    }()

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMainImageView()
        setupNameLabel()
    }

    // MARK: Public Methods

    func startShimmers(smallLabel: Bool = false) {
        layoutIfNeeded()
        startAnimations()

        if smallLabel {
            nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
    }

    // MARK: Private Methods

    private func addConstraints() {
        setupMainImageView()
        setupNameLabel()
    }

    private func setupMainImageView() {
        contentView.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: 200),
            mainImageView.widthAnchor.constraint(equalToConstant: 170)
        ])
    }

    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 5),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.widthAnchor.constraint(equalToConstant: 170)
        ])
    }

    private func startAnimations() {
        mainImageView.startShimmeringAnimation(animationSpeed: 2.0)
        nameLabel.startShimmeringAnimation(animationSpeed: 2.0)
    }
}
