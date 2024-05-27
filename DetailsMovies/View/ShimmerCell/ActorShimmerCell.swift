// ActorShimmerCell.swift
// Copyright © RoadMap. All rights reserved.

//
//  ActorShimmerCell.swift
//  CinemaStar
import UIKit

/// Ячейка с шиммером
class ActorShimmerCell: UICollectionViewCell {
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

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        mainImageView.startShimmeringAnimation(animationSpeed: 2.0)
    }

    // MARK: Private Methods

    private func setupHierarchy() {
        contentView.addSubview(mainImageView)
    }

    private func setupConstraints() {
        contentView.heightAnchor.constraint(equalToConstant: 115).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: 55).isActive = true

        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            mainImageView.widthAnchor.constraint(equalToConstant: 50),
            mainImageView.heightAnchor.constraint(equalToConstant: 73)
        ])
    }
}
