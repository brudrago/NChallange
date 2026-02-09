import UIKit

protocol HomeViewProtocol: UIView  {
    func updateShortenedURLs(_ urls: [ShortenedURL])
}

protocol HomeViewDelegate: AnyObject {
    func didTapSendButton(_ text: String)
    func didTapShowUrlsButton()
}

final class HomeView: UIView, HomeViewProtocol {
    
    // MARK: - UIComponents
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        textField.textColor = .label
        textField.tintColor = .label
        textField.textAlignment = .center
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = Constants.minimumFontSize
        
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.placeholder = AppStrings.UI.enterURL
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .URL
        textField.accessibilityIdentifier = "home.textField"
        return textField
    }()
    
    private var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(AppStrings.UI.sendButton, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = Constants.cornerRadius
        button.accessibilityIdentifier = "home.sendButton"
        return button
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
    
    private var showUrlsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(AppStrings.UI.recentlyShortened, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = Constants.cornerRadius
        button.accessibilityIdentifier = "home.sendButton"
        return button
    }()
    
    weak var delegate: HomeViewDelegate?
    
    private enum Constants {
        static let spacing16 = 16.0
        static let textFieldHeight = 44.0
        static let spacing24 = 24.0
        static let spacing8 = 8.0
        static let cellHeight = 120.0
        static let minCharacterCountForButtonEnabling: Int = 5
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
    
    // MARK: - Actions
    
    @objc private func sendButtonTapped() {
        guard button.isEnabled else { return }
        delegate?.didTapSendButton(textField.text ?? "")
        textField.text = nil
        updateButtonState()
    }
    
    @objc private func showUrlsButtonTapped() {
        delegate?.didTapShowUrlsButton()
    }
    
    @objc private func textFieldDidChange() {
        updateButtonState()
    }
    
    private func updateButtonState() {
        let text = textField.text ?? ""
        let hasValidText = !text.isEmpty && text.count >= Constants.minCharacterCountForButtonEnabling
        button.isEnabled = hasValidText
        button.alpha = hasValidText ? 1.0 : 0.5
    }
    
    // MARK: - Public Methods
    
    func updateShortenedURLs(_ urls: [ShortenedURL]) {
        shortenedURLs = urls
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - ViewCodeProtocol Extension

extension HomeView: ViewCodeProtocol {
    func setupSubviews() {
        addSubview(textField)
        addSubview(button)
        addSubview(tableView)
        addSubview(showUrlsButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.spacing24),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.spacing16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.spacing16),
            textField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),

            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.spacing16),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.spacing16),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.spacing16),
            
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: Constants.spacing16),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: showUrlsButton.topAnchor, constant: -Constants.spacing8),
            
            showUrlsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.spacing16),
            showUrlsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.spacing16),
            showUrlsButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.spacing16),
            showUrlsButton.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight)
        ])
    }
    
    func setupComponents() {
        backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        updateButtonState()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        showUrlsButton.addTarget(self, action: #selector(showUrlsButtonTapped), for: .touchUpInside)
    }
}

// MARK: - UITextField Delegate Extension

extension HomeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDataSource Extension

extension HomeView: UITableViewDataSource {
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

extension HomeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = shortenedURLs.count <= 0 ? "" : AppStrings.UI.lastShortened
        return title
    }
}
