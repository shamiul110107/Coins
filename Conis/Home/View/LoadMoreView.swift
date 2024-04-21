import UIKit

class LoaderFooterView: UIView {

    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    var tryAgainTapped: (() -> Void)?

    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .init(hexString: "#333333")
        label.text = "Could not load data"
        label.textAlignment = .center
        return label
    }()
    
    lazy var tryAgainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.init(hexString: "#38A0FF"), for: .normal)
        button.setTitle("Try again", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        
        tryAgainButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        addSubview(stackView)
        stackView.addArrangedSubview(activityIndicatorView)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(tryAgainButton)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func startAnimating() {
        activityIndicatorView.startAnimating()
    }

    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
    
    func showLoader() {
        activityIndicatorView.isHidden = false
        errorLabel.isHidden = true
        tryAgainButton.isHidden = true
    }
    
    func hideLoader() {
        activityIndicatorView.isHidden = true
        errorLabel.isHidden = false
        tryAgainButton.isHidden = false
    }
    
    @objc func buttonAction(sender: UIButton!) {
        tryAgainTapped?()
    }
}
