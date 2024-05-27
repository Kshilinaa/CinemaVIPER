// MoviesCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Переиспользуемая ячейка для показа списка фильмов
final class MoviesCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants

    private enum Constants {
        static let starLabel = "⭐"
        static let cornerRadius: CGFloat = 8
        static let chemisette: CGFloat = 8
        static let height: CGFloat = 200
    }

    static let identifier = "moviesListCollectionViewCell"

    // MARK: - Visual Components

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        return imageView
    }()

    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()

    private let starLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = Constants.starLabel
        return label
    }()

    // MARK: - Public Properties

    let identifier = "moviesListCollectionViewCell"

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupContentView()
        makeMovieImageViewConstraints()
        makeMovieNameLabelConstraints()
        makeStarLabelConstraints()
        makeRatingLabelConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupSubviews() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(starLabel)
        contentView.addSubview(ratingLabel)
    }

    private func makeMovieImageViewConstraints() {
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: Constants.height).isActive = true
    }

    private func makeMovieNameLabelConstraints() {
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        movieNameLabel.topAnchor.constraint(
            equalTo: movieImageView.bottomAnchor,
            constant: Constants.chemisette
        ).isActive = true
        movieNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }

    private func makeStarLabelConstraints() {
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.topAnchor.constraint(
            equalTo: movieNameLabel.bottomAnchor,
            constant: Constants.chemisette
        ).isActive = true
        starLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }

    private func makeRatingLabelConstraints() {
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.topAnchor.constraint(
            equalTo: movieNameLabel.bottomAnchor,
            constant: Constants.chemisette
        ).isActive = true
        ratingLabel.leadingAnchor.constraint(
            equalTo: starLabel.trailingAnchor,
            constant: 5
        ).isActive = true
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

    func configureCell(movie: Movie) {
        guard let url = movie.imageUrl else { return }
        loadImage(from: url) { image in
            self.movieImageView.image = image
        }
        movieNameLabel.text = movie.movieName
        guard let rating = movie.rating else { return }
        ratingLabel.text = "\(rating)"
    }
}
