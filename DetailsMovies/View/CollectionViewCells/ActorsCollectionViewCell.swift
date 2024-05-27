// ActorsCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

//
//  ActorsCollectionViewCell.swift
//  CinemaStar
//
//  Created by Ксения Шилина on 27.04.2024.
import UIKit

/// Переиспользуемая ячейка для показа категорий
final class ActorsCollectionViewCell: UICollectionViewCell {
    // MARK: - Visual Components

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 8)
        return label
    }()

    // MARK: - Public Properties

    let identifier = "ActorsCollectionViewCellIdentifier"

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
        contentView.addSubview(imageView)
        contentView.addSubview(fullNameLabel)
    }

    private func configureLayout() {
        makeImageViewConstraints()
        makeFullNameLabelConstraints()
    }

    private func setupContentView() {
        contentView.backgroundColor = .clear
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

    func configureWith(data: MovieActor) {
        guard let url = URL(string: data.imageURL ?? "")
        else { return }
        print("url \(url)")
        loadImage(from: url) { image in
            self.imageView.image = image
        }
        fullNameLabel.text = data.name
    }

    private func makeImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(
            equalTo: contentView.topAnchor
        ).isActive = true
        imageView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 7
        ).isActive = true
        imageView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -7
        ).isActive = true
    }

    private func makeFullNameLabelConstraints() {
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.topAnchor.constraint(
            equalTo: imageView.bottomAnchor,
            constant: 6
        ).isActive = true
        fullNameLabel.centerXAnchor.constraint(
            equalTo: imageView.centerXAnchor
        ).isActive = true
        fullNameLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor
        ).isActive = true
    }
}
