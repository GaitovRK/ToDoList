import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func didTapTitleButton(in cell: TaskTableViewCell)
}

class TaskTableViewCell: UITableViewCell {
    weak var delegate: TaskTableViewCellDelegate?
    private let titleButton = UIButton(type: .system)
    private let descriptionLabel = UILabel()
    private let checkboxButton = UIButton(type: .system)
    private let dateLabel = UILabel()
    private var task: Task?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(titleButton)
        addSubview(descriptionLabel)
        addSubview(checkboxButton)
        addSubview(dateLabel)

        titleButton.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        dateLabel.font = UIFont.systemFont(ofSize: 12)

//        titleButton.setTitleColor(.white, for: .normal)
        titleButton.contentHorizontalAlignment = .left
        titleButton.addTarget(self, action: #selector(titleButtonTapped), for: .touchUpInside)

        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .systemYellow
        config.baseBackgroundColor = .clear
        checkboxButton.configuration = config
        checkboxButton.isUserInteractionEnabled = true
        checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)

        NSLayoutConstraint.activate([
            checkboxButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            checkboxButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),

            titleButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleButton.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            titleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleButton.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])

        titleButton.bringSubviewToFront(self)
    }

    @objc private func toggleCheckbox() {
        guard var task = task else { return }
        task.isCompleted.toggle()
        configure(with: task)
    }

    @objc private func titleButtonTapped() {
        print("Title button tapped")
        delegate?.didTapTitleButton(in: self)
    }

    func configure(with task: Task) {
        self.task = task
        titleButton.setTitle(task.title, for: .normal)
        descriptionLabel.text = task.description
        checkboxButton.isSelected = task.isCompleted
        
        checkboxButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkboxButton.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormatter.string(from: task.creationDate)
        dateLabel.textColor = .gray

        if task.isCompleted {
            titleButton.setTitleColor(.gray, for: .normal)
            descriptionLabel.textColor = .gray
            let attributedString = NSAttributedString(string: task.title, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ])
            titleButton.setAttributedTitle(attributedString, for: .normal)
        } else {
            titleButton.setTitleColor(.white, for: .normal)
//            descriptionLabel.textColor = .darkText
            titleButton.setAttributedTitle(nil, for: .normal)
        }
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            titleButton.setTitle(nil, for: .normal)
            titleButton.setAttributedTitle(nil, for: .normal)
            titleButton.setTitleColor(.white, for: .normal)
            descriptionLabel.text = nil
            descriptionLabel.textColor = .white
            checkboxButton.isSelected = false
            checkboxButton.setImage(UIImage(systemName: "circle"), for: .normal)
            dateLabel.text = nil
        }
    
    func checkmarkPressed() {
        print("Checkmark pressed")
    }
    
    func titlePressed() {
        print("Title pressed")
    }
}
