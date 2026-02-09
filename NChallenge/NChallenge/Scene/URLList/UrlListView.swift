import UIKit

protocol UrlListViewProtocol: UIView {
    func updateShortenedURLs(_ urls: [ShortenedURL])
}

final class UrlListView: UIView, UrlListViewProtocol {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.text = AppStrings.UI.recentlyShortened
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(LinkAliasCell.self, forCellReuseIdentifier: LinkAliasCell.identifier)
        table.separatorStyle = .none
        table.backgroundColor = .systemGroupedBackground
        table.accessibilityIdentifier = "home.tableView"
        return table
    }()
    
    private enum Constants {
        static let spacing16 = 16.0
        static let spacing24 = 24.0
        static let cellHeight = 120.0
        static let totalSections = 1
        static let cornerRadius = 8.0
        static let minimumFontSize = 12.0
    }
    
    // MARK: - Data
    private var shortenedURLs: [ShortenedURL] = []
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - ViewCodeProtocol Extension

extension UrlListView: ViewCodeProtocol {
    func setupSubviews() {
        addSubview(titleLabel)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.spacing24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.spacing16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.spacing16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing16),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupComponents() {
        backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Public Methods
    
    func updateShortenedURLs(_ urls: [ShortenedURL]) {
        shortenedURLs = urls
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource Extension

extension UrlListView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Constants.totalSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shortenedURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LinkAliasCell.identifier, for: indexPath) as? LinkAliasCell else {
            return UITableViewCell()
        }
        
        let shortenedURL = shortenedURLs[indexPath.row]
        cell.configure(with: shortenedURL.alias, shortLink: shortenedURL.shortURL, originalUrl: shortenedURL.originalURL)
        
        return cell
    }
}

// MARK: - UITableViewDelegate Extension

extension UrlListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = shortenedURLs.count <= 0 ? "" : AppStrings.UI.recentlyShortened
        return title
    }
}
