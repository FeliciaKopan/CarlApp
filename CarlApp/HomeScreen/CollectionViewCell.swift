//
//  CollectionViewCell.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 09.09.2024.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, ReusableCell {

    private let title = UILabel()
    private let containerView = UIView()
    private let labelView = UIView()
    private let imageView = UIImageView()

    private var imageViewHeightConstraint: NSLayoutConstraint?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(label: String, image: UIImage?, backgroundColor: UIColor?, isPersonImage: Bool) {
        title.text = label
        imageView.image = image
        containerView.backgroundColor = backgroundColor
        imageView.contentMode = isPersonImage ? .scaleAspectFill : .scaleAspectFit

        imageViewHeightConstraint?.isActive = false
        let multiplier = isPersonImage ? 1.0 : 0.85
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: multiplier)
        imageViewHeightConstraint?.isActive = true

    }

    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 40
        layer.masksToBounds = true

        labelView.backgroundColor = .clear
        containerView.backgroundColor = .red

        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        title.textColor = .black
        title.font = .systemFont(ofSize: 24, weight: .semibold)
        title.numberOfLines = 0
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.preferredFont(forTextStyle: .body)
        title.adjustsFontForContentSizeCategory = true

        addSubview(containerView, constraints: [
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        containerView.addSubview(imageView, constraints: [
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        addSubview(labelView, constraints: [
            labelView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            labelView.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelView.heightAnchor.constraint(equalToConstant: 40)
        ])

        labelView.addSubview(title, constraints: [
            title.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 4),
            title.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 4),
            title.centerXAnchor.constraint(equalTo: labelView.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: labelView.centerYAnchor)
        ])
    }

}
