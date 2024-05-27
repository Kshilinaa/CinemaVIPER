// InfoTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

//
//  OtherInfoTableViewCell.swift
//  CinemaStar
//
import UIKit

/// Ячейка с остальной информацией
final class InfoTableViewCell: UITableViewCell {
    // MARK: - Constants

    enum Constants {
        static let identifier = "OtherInfoTableViewCell"
        static let titleLabel = "Язык"
        static let verticalInset: CGFloat = 10
    }

    // MARK: - Visual Components

    private let otherInfoLabel: UILabel = {
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
        let year = info.year ?? 2000
        let country = info.country ?? "country"
        let type = info.contentType ?? "Сериал"
        otherInfoLabel.text = "\(year)/\(country)/\(type)"
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubview(otherInfoLabel)
    }

    private func setupConstraints() {
        makeOtherInfoLabelConstraints()
    }

    private func makeOtherInfoLabelConstraints() {
        otherInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        otherInfoLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: Constants.verticalInset
        ).isActive = true
        otherInfoLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor
        ).isActive = true
        otherInfoLabel.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor
        ).isActive = true
        otherInfoLabel.heightAnchor.constraint(
            equalToConstant: 20
        ).isActive = true
        otherInfoLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -Constants.verticalInset
        ).isActive = true
    }
}
