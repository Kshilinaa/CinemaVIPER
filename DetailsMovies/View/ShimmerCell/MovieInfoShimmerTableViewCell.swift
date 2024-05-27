// MovieInfoShimmerTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

//
//  MovieInfoShimmerTableViewCell.swift
//  CinemaStar
//
import UIKit

/// Ячейка с информацией о фильме для отображения заглушек (шиммеров)
final class MovieInfoShimmerTableViewCell: UITableViewCell {
    // MARK: - Constants

    static var identifier: String {
        String(describing: self)
    }

    // MARK: - Visual Components

    private lazy var mainImageView: UIView = {
        let imageView = UIView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(named: "shimmer")
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private let nameLabel: UIView = {
        let label = UIView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(named: "shimmer")
        label.layer.cornerRadius = 10
        return label
    }()

    private lazy var watchButton: UIView = {
        let button = UIView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "shimmer")
        button.layer.cornerRadius = 15
        return button
    }()

    private let descriptionLabel: UIView = {
        let label = UIView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(named: "shimmer")
        label.layer.cornerRadius = 15
        return label
    }()

    private let infoCinemaLabel: UIView = {
        let label = UIView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(named: "shimmer")
        label.layer.cornerRadius = 9
        return label
    }()

    // MARK: - Initializers

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

    // MARK: - Public Methods

    func startShimmers() {
        layoutIfNeeded()
        startAnimations()
    }

    // MARK: - Private Methods

    private func setupHierarchy() {
        contentView.addSubview(mainImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(watchButton)
        contentView.addSubview(watchButton)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(infoCinemaLabel)
    }

    private func setupConstraints() {
        contentView.heightAnchor.constraint(
            equalToConstant: 440
        ).isActive = true

        setupMainImageViewConstraint()
        setupNameLabelConstraint()
        setupWatchNameButtonConstraint()
        setupDescriptionLabelConstraint()
        setupInfoCinemaLabelConstraint()
    }

    private func setupMainImageViewConstraint() {
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            mainImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            mainImageView.heightAnchor.constraint(
                equalToConstant: 200
            ),
            mainImageView.widthAnchor.constraint(
                equalToConstant: 170
            )
        ])
    }

    private func setupNameLabelConstraint() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(
                equalTo: mainImageView.topAnchor,
                constant: 45
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: mainImageView.trailingAnchor,
                constant: 16
            ),
            nameLabel.heightAnchor.constraint(
                equalToConstant: 100
            ),
            nameLabel.widthAnchor.constraint(
                equalToConstant: 170
            )
        ])
    }

    private func setupWatchNameButtonConstraint() {
        NSLayoutConstraint.activate([
            watchButton.topAnchor.constraint(
                equalTo: mainImageView.bottomAnchor,
                constant: 10
            ),
            watchButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            watchButton.widthAnchor.constraint(
                equalToConstant: 358
            ),
            watchButton.heightAnchor.constraint(
                equalToConstant: 48
            )
        ])
    }

    private func setupDescriptionLabelConstraint() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(
                equalTo: watchButton.bottomAnchor,
                constant: 15
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            descriptionLabel.widthAnchor.constraint(
                equalToConstant: 358
            ),
            descriptionLabel.heightAnchor.constraint(
                equalToConstant: 100
            )
        ])
    }

    private func setupInfoCinemaLabelConstraint() {
        NSLayoutConstraint.activate([
            infoCinemaLabel.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: 10
            ),
            infoCinemaLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),

            infoCinemaLabel.heightAnchor.constraint(
                equalToConstant: 20
            ),
            infoCinemaLabel.widthAnchor.constraint(
                equalToConstant: 358
            )
        ])
    }

    private func startAnimations() {
        mainImageView.startShimmeringAnimation(animationSpeed: 2.0)
        nameLabel.startShimmeringAnimation(animationSpeed: 2.0)
        watchButton.startShimmeringAnimation(animationSpeed: 2.0)
        descriptionLabel.startShimmeringAnimation(animationSpeed: 2.0)
        infoCinemaLabel.startShimmeringAnimation(animationSpeed: 2.0)
    }
}
