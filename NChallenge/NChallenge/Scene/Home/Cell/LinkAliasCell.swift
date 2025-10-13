import UIKit

final class LinkAliasCell: UITableViewCell {
    
    static let identifier = String(describing: LinkAliasCell.self)
    
    // MARK: - UI Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let aliasLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let shortLinkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let originalUrlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private enum Constants {
        static let spacing4 = 4.0
        static let spacing8 = 8.0
        static let spacing16 = 16.0
    }
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with alias: String, shortLink: String, originalUrl: String) {
        aliasLabel.text = alias
        shortLinkLabel.text = shortLink
        originalUrlLabel.text = originalUrl
    }
}

extension LinkAliasCell: ViewCodeProtocol {
    func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(aliasLabel)
        containerView.addSubview(shortLinkLabel)
        containerView.addSubview(originalUrlLabel)
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.spacing8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.spacing8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.spacing4),
            
            aliasLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.spacing16),
            aliasLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.spacing16),
            aliasLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.spacing16),
            
            shortLinkLabel.topAnchor.constraint(equalTo: aliasLabel.bottomAnchor, constant: Constants.spacing4),
            shortLinkLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.spacing16),
            shortLinkLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.spacing16),
            
            originalUrlLabel.topAnchor.constraint(equalTo: shortLinkLabel.bottomAnchor, constant: Constants.spacing4),
            originalUrlLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.spacing16),
            originalUrlLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.spacing16),
            originalUrlLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.spacing16)
        ])
    }
    
    func setupComponents() {
        backgroundColor = .clear
        selectionStyle = .none
    }

}
