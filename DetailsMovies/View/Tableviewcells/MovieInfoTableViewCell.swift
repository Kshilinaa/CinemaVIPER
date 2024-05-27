// MovieInfoTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

//
//  MovieInfoTableViewCell.swift
//  CinemaStar
import UIKit

/// Ячейка  с постером и названием фильма
final class MovieInfoTableViewCell: UITableViewCell {
    // MARK: - Constants

    enum Constants {
        static let identifier = "MovieInfoTableViewCell"
        static let watchMovieButton = "Смотреть"
        static let watchMovieButtonIdentifier = "watchMovieButtonIdentifier"
        static let starLabel = "⭐"
        static let imageWidth: CGFloat = 0.45
        static let cornerRadius: CGFloat = 12
        static let imageHeight: CGFloat = 1.4
        static let buttonCornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 48
        static let inset: CGFloat = 16
        static let labelWidth: CGFloat = 20
        static let smallInset: CGFloat = 2
        static let minimumHeight: CGFloat = 20
    }

    // MARK: - Visual Components

    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()

    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let starLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.starLabel
        return label
    }()

    private let movieRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()

    private lazy var watchMovieButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.watchMovieButton, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor(named: "gradientBottom")
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.accessibilityIdentifier = Constants.watchMovieButtonIdentifier
        button.addTarget(
            self,
            action: #selector(didTapWatchButton(_:)),
            for: .touchUpInside
        )
        return button
    }()

    // MARK: - Private Properties

    var onTapWatchButton: (() -> ())?

    // MARK: - Initalizers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    // MARK: - Public Methods

    /// Настройка ячейки с данными о фильме
    func configureCell(info: MovieDetail) {
        guard let url = info.imageURL else { return }
        loadImage(from: url) { image in
            self.movieImageView.image = image
        }
        movieNameLabel.text = info.movieName
        movieRatingLabel.text = info.movieRating
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(starLabel)
        contentView.addSubview(movieRatingLabel)
        contentView.addSubview(movieRatingLabel)
        contentView.addSubview(watchMovieButton)
    }

    private func setupConstraints() {
        makeMovieImageViewConstraints()
        makeMovieNameLabelConstraints()
        makeStarLabelConstraints()
        makeMovieRatingLabelConstraints()
        makeWatchMovieButtonConstraints()
    }

    /// Загрузка изображения по URL
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
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

    private func makeStarLabelConstraints() {
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        starLabel.leadingAnchor.constraint(
            equalTo: movieImageView.trailingAnchor,
            constant: Constants.inset
        ).isActive = true
        starLabel.widthAnchor.constraint(
            equalToConstant: Constants.labelWidth
        ).isActive = true
        starLabel.topAnchor.constraint(
            equalTo: movieImageView.centerYAnchor,
            constant: Constants.smallInset
        ).isActive = true
        starLabel.heightAnchor.constraint(
            greaterThanOrEqualToConstant: Constants
                .minimumHeight
        ).isActive = true
    }

    private func makeMovieRatingLabelConstraints() {
        movieRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        movieRatingLabel.leadingAnchor.constraint(
            equalTo: starLabel.trailingAnchor,
            constant: Constants.smallInset
        ).isActive = true
        movieRatingLabel.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor
        ).isActive = true
        movieRatingLabel.topAnchor.constraint(
            equalTo: movieImageView.centerYAnchor,
            constant: Constants.smallInset
        ).isActive = true
        movieRatingLabel.heightAnchor.constraint(
            greaterThanOrEqualToConstant: Constants
                .minimumHeight
        ).isActive = true
    }

    private func makeWatchMovieButtonConstraints() {
        watchMovieButton.translatesAutoresizingMaskIntoConstraints = false
        watchMovieButton.topAnchor.constraint(
            equalTo: movieImageView.bottomAnchor,
            constant: Constants.inset
        ).isActive = true
        watchMovieButton.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor
        ).isActive = true
        watchMovieButton.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor
        ).isActive = true
        watchMovieButton.heightAnchor.constraint(
            equalToConstant: Constants.buttonHeight
        ).isActive = true
        watchMovieButton.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor
        ).isActive = true
    }

    private func makeMovieImageViewConstraints() {
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.topAnchor.constraint(
            equalTo: contentView.topAnchor
        ).isActive = true
        movieImageView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor
        ).isActive = true
        movieImageView.widthAnchor.constraint(
            equalTo: contentView.widthAnchor,
            multiplier: Constants.imageWidth
        ).isActive = true
        movieImageView.heightAnchor.constraint(
            equalTo: movieImageView.widthAnchor,
            multiplier: Constants.imageHeight
        ).isActive = true
    }

    private func makeMovieNameLabelConstraints() {
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        movieNameLabel.leadingAnchor.constraint(
            equalTo: movieImageView.trailingAnchor,
            constant: Constants.inset
        ).isActive = true
        movieNameLabel.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor
        ).isActive = true
        movieNameLabel.heightAnchor.constraint(
            greaterThanOrEqualToConstant: Constants
                .minimumHeight
        ).isActive = true
        movieNameLabel.bottomAnchor.constraint(
            equalTo: movieImageView.centerYAnchor,
            constant: -Constants.smallInset
        ).isActive = true
    }

    /// Обработка нажатия на кнопку просмотра фильма
    @objc private func didTapWatchButton(_ sender: UIButton) {
        onTapWatchButton?()
    }
}
