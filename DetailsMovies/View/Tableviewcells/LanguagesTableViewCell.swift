// LanguagesTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

//
//  LanguagesTableViewCell.swift
//  CinemaStar
import UIKit

/// Экран с языком фильма
final class LanguagesTableViewCell: UITableViewCell {
    // MARK: - Constants

    enum Constants {
        static let titleLabel = "Язык"
        static let identifier = "LanguagesTableViewCell"
        static let verticalInset: CGFloat = 5
    }

    // MARK: - Visual Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .heavy)
        label.text = Constants.titleLabel
        label.textColor = .white
        return label
    }()

    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(named: "languageText")
        return label
    }()

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

    func configureCell(info: MovieDetail) {
        print("info \(info)")
        languageLabel.text = info.language
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(languageLabel)
    }

    private func setupConstraints() {
        makeTitleLabelConstraints()
        makeLanguageLabelConstraints()
    }

    private func makeLanguageLabelConstraints() {
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.topAnchor.constraint(
            equalTo: titleLabel.bottomAnchor,
            constant: Constants.verticalInset
        ).isActive = true
        languageLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor
        ).isActive = true
        languageLabel.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor
        ).isActive = true
        languageLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -Constants.verticalInset
        ).isActive = true
    }

    private func makeTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: Constants.verticalInset
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
