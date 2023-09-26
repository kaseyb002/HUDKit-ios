import UIKit

final class HUDView: UIView {
    // MARK: - Views
    private let stackView: UIStackView = makeStackView()
    let iconView: UIImageView = makeIconView()
    let label: UILabel = makeLabel()
    let spinner: UIActivityIndicatorView = makeSpinner()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension HUDView {
    private func setup() {
        backgroundColor = .label.withAlphaComponent(0.95)
        layer.cornerRadius = 20
        clipsToBounds = true
        addSubview(stackView)
        let padding: CGFloat = 30
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: padding),
        ])
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(spinner)
        stackView.addArrangedSubview(label)
    }

    private static func makeStackView() -> UIStackView {
        let stackView: UIStackView = .init()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }

    private static func makeIconView() -> UIImageView {
        let imageView: UIImageView = .init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemBackground
        return imageView
    }

    private static func makeLabel() -> UILabel {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBackground
        label.textAlignment = .center
        label.numberOfLines = 5
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }
    
    private static func makeSpinner() -> UIActivityIndicatorView {
        let spinner: UIActivityIndicatorView = .init()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.style = .large
        spinner.color = .systemBackground
        return spinner
    }
}
