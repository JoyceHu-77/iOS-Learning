//
//  TableViewPrefetchCell.swift
//  ListViewTest
//
//  Created by Blacour on 2022/10/8.
//

import UIKit

final class TableViewPrefetchCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(photo)
        NSLayoutConstraint.activate([
            photo.widthAnchor.constraint(equalToConstant: 300),
            photo.heightAnchor.constraint(equalToConstant: 300),
            photo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
    }
    
    func configure(with viewModel: PrefetchViewModel) {
        viewModel.downloadImage { [weak self] image in
            DispatchQueue.main.async {
                self?.photo.image = image
            }
        }
    }
    
    private lazy var photo: UIImageView = {
        let photo = UIImageView()
        photo.clipsToBounds = true
        photo.contentMode = .scaleAspectFill
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
}
