// MovieDetailsViewController.swift
// Copyright © RoadMap. All rights reserved.

//
//  MovieDetailViewController.swift
//  CinemaStar
import UIKit

/// Экран для показа деталей о фильме
final class MovieDetailsViewController: UIViewController {
    // MARK: - Constants

    enum Constants {
        static let topInset: CGFloat = 20
        static let leading: CGFloat = 16
        static let trailing: CGFloat = -16
        static let movieDetailsViewIdentifier = "movieDetailViewIdentifier"
        static let alertTitle = "Упс"
        static let alertText = "Функционал в разработке :("
        static let movieDetailsTableViewIdentifier = "movieDetailTableViewIdentifier"
        static let favoriteButtonIdentifier = "favoriteButtonIdentifier"
        static let backButtonIdentifier = "backButtonIdentifier"
    }

    let sections: [MovieDetailSection] = [.info, .description, .actors, .similar]
    let movieDetailViewModel: MovieDetailViewModel?
    private let id: Int

    // MARK: - Private Properties

    var currentSection: MovieDetailSection = .info
    var favorite = false
    var descriptionExpanded = false

    // MARK: - Visual Components

    private let gradientLayer = CAGradientLayer()

    private let backBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.accessibilityIdentifier = Constants.backButtonIdentifier
        return button
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "isNotFavorite"), for: .normal)
        button.accessibilityIdentifier = Constants.favoriteButtonIdentifier
        return button
    }()

    private lazy var movieDetailsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            MovieInfoTableViewCell.self,
            forCellReuseIdentifier: MovieInfoTableViewCell.Constants.identifier
        )
        tableView.register(
            DescriptionTableViewCell.self,
            forCellReuseIdentifier: DescriptionTableViewCell.Constants.identifier
        )
        tableView.register(
            InfoTableViewCell.self,
            forCellReuseIdentifier: InfoTableViewCell.Constants.identifier
        )
        tableView.register(
            ActorsTableViewCell.self,
            forCellReuseIdentifier: ActorsTableViewCell.Constants.identifier
        )
        tableView.register(
            LanguagesTableViewCell.self,
            forCellReuseIdentifier: LanguagesTableViewCell.Constants.identifier
        )
        tableView.register(
            RecomendationsMoviesTableViewCell.self,
            forCellReuseIdentifier: RecomendationsMoviesTableViewCell.Constants.identifier
        )
        tableView.register(
            MovieInfoShimmerTableViewCell.self,
            forCellReuseIdentifier: "MovieInfoShimmerTableViewCell"
        )
        tableView.register(
            RecommendedShimmerCell.self,
            forCellReuseIdentifier: "RecommendedShimmerCell"
        )
        tableView.register(
            CastShimmerCell.self,
            forCellReuseIdentifier: "CastShimmerCell"
        )

        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.accessibilityIdentifier = Constants.movieDetailsTableViewIdentifier
        return tableView
    }()

    // MARK: - Initializers

    init(id: Int, movieDetailViewModel: MovieDetailViewModel?) {
        self.movieDetailViewModel = movieDetailViewModel
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailViewModel?.fetchMovie {
            self.movieDetailsTableView.reloadData()
        }
        setupGradientLayer()
        setupSubview()
        makeMovieDetailTableViewConstrints()
        setupNavigationBar()
        updateIsFavoriteButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    // MARK: - Private Methodes

    private func setupSubview() {
        view.addSubview(movieDetailsTableView)
    }

    private func setupGradientLayer() {
        gradientLayer.colors = [
            UIColor(named: "topColor")?.cgColor ?? UIColor.white.cgColor,
            UIColor(named: "bottonColor")?.cgColor ?? UIColor.white.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        view.accessibilityIdentifier = Constants.movieDetailsViewIdentifier
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            for: .default
        )
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: backBarButton
        )
        backBarButton.addTarget(
            self,
            action: #selector(tapBackButton(_:)),
            for: .touchUpInside
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        favoriteButton.addTarget(
            self,
            action: #selector(tapFavoriteButton(_:)),
            for: .touchUpInside
        )
    }

    private func setIsFavoriteButton(isFavorite: Bool) {
        guard let isFavotiteImage = UIImage(named: "isFavorite"),
              let isNotFavorite = UIImage(named: "isNotFavorite")
        else { return }
        let favoriteImage: UIImage = isFavorite
            ? isFavotiteImage
            : isNotFavorite
        favoriteButton.setImage(favoriteImage, for: .normal)
    }

    private func toggleIsFavoriteButtonState() {
        favorite.toggle()
        setIsFavoriteButton(isFavorite: favorite)
        let defaults = UserDefaults.standard
        defaults.set(favorite, forKey: "\(id)")
    }

    private func updateIsFavoriteButton() {
        let isFavorite = UserDefaults.standard.bool(forKey: "\(id)")
        setIsFavoriteButton(isFavorite: isFavorite)
        favorite = isFavorite
    }

    private func makeMovieDetailTableViewConstrints() {
        movieDetailsTableView.translatesAutoresizingMaskIntoConstraints = false
        movieDetailsTableView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: Constants.topInset
        ).isActive = true
        movieDetailsTableView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: Constants.leading
        ).isActive = true
        movieDetailsTableView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: Constants.trailing
        ).isActive = true
        movieDetailsTableView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor
        ).isActive = true
    }

    @objc private func tapFavoriteButton(_ sender: UIButton) {
        toggleIsFavoriteButtonState()
    }

    @objc private func tapBackButton(_ sender: UIButton) {
        movieDetailViewModel?.backToMoviesList()
    }
}

// MARK: - Extensions

extension MovieDetailsViewController {
    private func showAlertForWatchButton() {
        let alertViewController = UIAlertController(
            title: Constants.alertTitle,
            message: Constants.alertText,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default
        )
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true)
    }
}

// MARK: - MovieDetailViewController + UITableViewDataSource

extension MovieDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch movieDetailViewModel?.state {
        case let .data(movieDetail):
            currentSection = sections[section]
            switch currentSection {
            case .description, .actors:
                return 2
            default:
                return 1
            }
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch movieDetailViewModel?.state {
        case .loading:
            switch sections[indexPath.section] {
            case .info:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: MovieInfoShimmerTableViewCell.identifier,
                    for: indexPath
                ) as? MovieInfoShimmerTableViewCell else { return UITableViewCell() }
                cell.startShimmers()
                cell.backgroundColor = .clear
                return cell
            case .description:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: CastShimmerCell.identifier,
                    for: indexPath
                ) as? CastShimmerCell else { return UITableViewCell() }
                cell.startShimmers()
                return cell
            case .actors:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: RecommendedShimmerCell.identifier,
                    for: indexPath
                ) as? RecommendedShimmerCell else { return UITableViewCell() }
                cell.startShimmers()
                return cell
            case .similar:
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                return cell
            }
        case let .data(movieDetail):
            switch sections[indexPath.section] {
            case .info:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: MovieInfoTableViewCell.Constants.identifier,
                    for: indexPath
                ) as? MovieInfoTableViewCell else { return UITableViewCell() }
                cell.configureCell(info: movieDetail)
                cell.onTapWatchButton = { [weak self] in
                    self?.showAlertForWatchButton()
                }
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                return cell
            case .description:
                if indexPath.row == 0 {
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: DescriptionTableViewCell.Constants.identifier,
                        for: indexPath
                    ) as? DescriptionTableViewCell else { return UITableViewCell() }
                    cell.configureCell(info: movieDetail)
                    cell.onExpandButtonTap = { [weak self] in
                        self?.movieDetailsTableView.beginUpdates()
                        self?.movieDetailsTableView.setNeedsDisplay()
                        self?.movieDetailsTableView.endUpdates()
                    }
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: InfoTableViewCell.Constants.identifier,
                        for: indexPath
                    ) as? InfoTableViewCell else { return UITableViewCell() }
                    cell.configureCell(info: movieDetail)
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    return cell
                }
            case .actors:
                if indexPath.row == 0 {
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: ActorsTableViewCell.Constants.identifier,
                        for: indexPath
                    ) as? ActorsTableViewCell else { return UITableViewCell() }
                    print("movieDetail is \(movieDetail)")
                    cell.configureCell(info: movieDetail)
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: LanguagesTableViewCell.Constants.identifier,
                        for: indexPath
                    ) as? LanguagesTableViewCell else { return UITableViewCell() }
                    cell.configureCell(info: movieDetail)
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    return cell
                }

            case .similar:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: RecomendationsMoviesTableViewCell.Constants.identifier,
                    for: indexPath
                ) as? RecomendationsMoviesTableViewCell else { return UITableViewCell() }
                cell.configureCell(info: movieDetail)
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
}
