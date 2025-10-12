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
        return label
    }()
    
    private let shortLinkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with alias: String, shortLink: String) {
        aliasLabel.text = alias
        shortLinkLabel.text = shortLink
    }
}

extension LinkAliasCell: ViewCodeProtocol {
    func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(aliasLabel)
        containerView.addSubview(shortLinkLabel)
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            aliasLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            aliasLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            aliasLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            shortLinkLabel.topAnchor.constraint(equalTo: aliasLabel.bottomAnchor, constant: 4),
            shortLinkLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            shortLinkLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            shortLinkLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func setupComponents() {
        backgroundColor = .clear
        selectionStyle = .none
    }

}
