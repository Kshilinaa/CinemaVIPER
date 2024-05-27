// RecomendationsMoviesCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

//
//  SimilarMoviesCollectionViewCell.swift
//  CinemaStar
//
import UIKit

/// Ячейка с рекомендуемыми(похожими фильмами)
final class RecomendationsMoviesCollectionViewCell: UICollectionViewCell {
    // MARK: - Visual Components

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var similarMovieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.backgroundColor = .clear
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(movieNameLabel)
        return stackView
    }()

    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = "text"
        return label
    }()

    // MARK: - Public Properties

    let identifier = "RecomendationsMoviesCollectionViewCell"

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        configureLayout()
        setupContentView()
        layoutSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubview(similarMovieStackView)
    }

    private func configureLayout() {
        configureImageViewConstraints()
        configureMovieNameLabelConstraints()
    }

    override func layoutSubviews() {
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
    }

    private func setupContentView() {
        contentView.backgroundColor = .clear
    }

    private func configureImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: similarMovieStackView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: similarMovieStackView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: similarMovieStackView.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 265).isActive = true
    }

    private func configureMovieNameLabelConstraints() {
        similarMovieStackView.translatesAutoresizingMaskIntoConstraints = false
        similarMovieStackView.topAnchor.constraint(
            equalTo: contentView.topAnchor
        ).isActive = true
        similarMovieStackView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor
        ).isActive = true
        similarMovieStackView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor
        ).isActive = true
        similarMovieStackView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor
        ).isActive = true
    }

    // MARK: - Configuration

    func configureWith(data: Movie) {
        guard let url = data.imageUrl else { return }
        loadImage(from: url) { image in
            self.imageView.image = image
        }
        movieNameLabel.text = ""
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
}
