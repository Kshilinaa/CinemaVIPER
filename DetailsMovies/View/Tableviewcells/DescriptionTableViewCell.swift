// DescriptionTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

//
//  DescriptionTableViewCell.swift
//  CinemaStar
//
import UIKit

/// Ячейка для отображения описания фильма
final class DescriptionTableViewCell: UITableViewCell {
    // MARK: - Constants

    /// Состояние кнопки разворачивания
    enum ExpandButtonState: String {
        /// Кнопка развернута
        case expanded = "chevron.up"
        /// Кнопка свернута
        case collapsed = "chevron.down"
    }

    enum Constants {
        static let identifier = "DescriptionTableViewCell"
        static let textViewHeightHide: CGFloat = 200
        static let textViewHeightUnhide: CGFloat = 308
        static let topInset: CGFloat = 16
        static let iconSize: CGFloat = 24
        static let smallInset: CGFloat = 6
    }

    // MARK: - Visual Components

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 5
        label.setContentCompressionResistancePriority(
            .required,
            for: .vertical
        )
        label.setContentHuggingPriority(
            .required,
            for: .vertical
        )
        return label
    }()

    private lazy var expandButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.isUserInteractionEnabled = true
        button.setImage(
            UIImage(systemName: "chevron.down"),
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(didTapExpandButton(_:)),
            for: .touchUpInside
        )
        return button
    }()

    // MARK: - Private properties

    private var expandButtonState: ExpandButtonState = .collapsed
    private var isExpanded = false
    var onExpandButtonTap: VoidHandler?

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

    /// Настройка ячейки
    func configureCell(info: MovieDetail) {
        descriptionLabel.text = info.description
    }

    // MARK: - Private Methodes

    private func setupSubviews() {
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(expandButton)
    }

    private func setupConstraints() {
        makeDescriptionLabelConstraints()
        makeButtonConstraints()
    }

    private func makeButtonConstraints() {
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        expandButton.bottomAnchor.constraint(
            equalTo: descriptionLabel.bottomAnchor
        ).isActive = true
        expandButton.trailingAnchor.constraint(
            equalTo: descriptionLabel.trailingAnchor
        ).isActive = true
        expandButton.heightAnchor.constraint(
            equalToConstant: Constants.iconSize
        ).isActive = true
        expandButton.widthAnchor.constraint(
            equalToConstant: Constants.iconSize
        ).isActive = true
    }

    private func makeDescriptionLabelConstraints() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: Constants.topInset
        ).isActive = true
        descriptionLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor
        ).isActive = true
        descriptionLabel.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor
        ).isActive = true
        descriptionLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor
        ).isActive = true
    }

    /// Переключение состояния кнопки разворачивания
    private func toggleExpandButton(to state: ExpandButtonState) {
        switch state {
        case .expanded:
            expandButton.setImage(
                UIImage(systemName: "chevron.down"),
                for: .normal
            )
            descriptionLabel.numberOfLines = 0
            descriptionLabel.sizeToFit()
            onExpandButtonTap?()
        case .collapsed:
            expandButton.setImage(
                UIImage(systemName: "chevron.up"),
                for: .normal
            )
            descriptionLabel.numberOfLines = 5
            onExpandButtonTap?()
        }
    }

    /// Обработка нажатия на кнопку разворачивания
    @objc private func didTapExpandButton(_ sender: UIButton) {
        isExpanded.toggle()
        let state: ExpandButtonState = isExpanded
            ? .expanded
            : .collapsed
        toggleExpandButton(to: state)
    }
}
