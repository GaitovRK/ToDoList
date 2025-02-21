import UIKit

class TaskTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let checkboxButton = UIButton(type: .system)
    private let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(checkboxButton)
        addSubview(dateLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        dateLabel.font = UIFont.systemFont(ofSize: 12)

        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 2

        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .systemYellow
        config.baseBackgroundColor = .clear
        checkboxButton.configuration = config
        checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)

        NSLayoutConstraint.activate([
            checkboxButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            checkboxButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }

    @objc private func toggleCheckbox() {
        checkboxButton.isSelected.toggle()
    }

    func configure(with task: Task) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        checkboxButton.isSelected = task.isCompleted
        
        checkboxButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkboxButton.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormatter.string(from: task.creationDate)
        dateLabel.textColor = .gray

        if task.isCompleted {
            titleLabel.textColor = .gray
            descriptionLabel.textColor = .gray
            let attributedString = NSAttributedString(string: task.title, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ])
            titleLabel.attributedText = attributedString
        } else {
            titleLabel.textColor = .white
            descriptionLabel.textColor = .white
            titleLabel.attributedText = nil
            titleLabel.text = task.title
        }
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            titleLabel.text = nil
            titleLabel.attributedText = nil
            titleLabel.textColor = .white
            descriptionLabel.text = nil
            descriptionLabel.textColor = .white
            checkboxButton.isSelected = false
            checkboxButton.setImage(UIImage(systemName: "circle"), for: .normal)
            dateLabel.text = nil
        }
}
