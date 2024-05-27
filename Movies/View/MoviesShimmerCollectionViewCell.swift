// MoviesShimmerCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка для фильмов
final class MoviesShimmerCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    private enum Constants {
        static let cornerRadius: CGFloat = 8
        static let imageHeight: CGFloat = 200
        static let inset: CGFloat = 8
        static let starLabel = "⭐"
    }

    // MARK: - Visual Components

    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "shimmer")
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()

    lazy var movieInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.backgroundColor = UIColor(named: "shimmer")

        stackView.addArrangedSubview(movieNameLabel)
        stackView.addArrangedSubview(movieRatingStackView)
        return stackView
    }()

    lazy var movieRatingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5

        stackView.addArrangedSubview(starLabel)
        stackView.addArrangedSubview(ratingLabel)
        return stackView
    }()

    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let starLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.starLabel
        label.backgroundColor = .clear
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.backgroundColor = .clear
        return label
    }()

    // MARK: - Public Properties

    static let identifier = "moviesListShimmerCollectionViewCell"

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        configureLayout()
        setupContentView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieInfoStackView)
    }

    private func configureLayout() {
        configureMovieImageViewConstraints()
        configureMovieInfoStackViewConstraints()
        configureStarLabelConstraints()
    }

    private func setupContentView() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = Constants.cornerRadius
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }

    // MARK: - Configuration

    func startShimming() {
        layoutIfNeeded()
        movieImageView.startShimmeringAnimation(animationSpeed: 1.5)
        movieInfoStackView.startShimmeringAnimation(animationSpeed: 1.5)
    }
}

/// Pасширение для установки размеров и расположения элементов
extension MoviesShimmerCollectionViewCell {
    private func configureMovieImageViewConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            movieImageView.leftAnchor.constraint(
                equalTo: contentView.leftAnchor
            ),
            movieImageView.rightAnchor.constraint(
                equalTo: contentView.rightAnchor
            ),
            movieImageView.heightAnchor.constraint(
                equalToConstant: Constants.imageHeight
            )
        ])
    }

    private func configureMovieInfoStackViewConstraints() {
        NSLayoutConstraint.activate([
            movieInfoStackView.topAnchor.constraint(
                equalTo: movieImageView.bottomAnchor,
                constant: Constants.inset
            ),
            movieInfoStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            movieInfoStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            movieInfoStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            )
        ])
    }

    private func configureStarLabelConstraints() {
        NSLayoutConstraint.activate([
            starLabel.widthAnchor.constraint(
                equalToConstant: 20
            )
        ])
    }
}
