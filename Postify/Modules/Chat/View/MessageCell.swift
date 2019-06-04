//
//  MessageCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 15/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import Visually

class MessageCell: UITableViewCell, Reusable {
    private let dummyLabel = UILabel()
    private(set) lazy var bubbleView = builtBubbleView()
    private(set) lazy var messageContentLabel = builtMessageContentLabel()
    private(set) lazy var usernameLabel = builtUsernameLabel()
    private(set) lazy var dateLabel = builtDateLabel()
    private(set) lazy var bubbleViewRightSideConstraints = [bubbleView.leftAnchor.constraint(greaterThanOrEqualTo: contentView.leftAnchor, constant: 100),
                                                            bubbleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)]
    private(set) lazy var bubbleViewLeftSideConstraints = [bubbleView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -100),
                                                           bubbleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10)]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MessageCell {
    func hydrate(with viewModel: MessageViewModel) {
        setupBubbleViewConstraints(for: viewModel)
        messageContentLabel.text = viewModel.text
        dateLabel.text = viewModel.dateText
        usernameLabel.text = ""
    }
}

private extension MessageCell {
    func setup() {
        addSubviews()
        setupConstraints()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageContentLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(dateLabel)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += [bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)]
        c += [bubbleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)]
        c += [messageContentLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10)]
        c += [messageContentLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 10)]
        c += [messageContentLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10)]
        c += [messageContentLabel.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -10)]
        c += [usernameLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 5)]
        c += [usernameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15)]
        c += [usernameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15)]
        c += [dateLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 3)]
        c += [dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15)]
        c += [dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15)]
        c += [dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)]
        NSLayoutConstraint.activate(c)
    }
    
    func builtBubbleView() -> UIView {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }
    
    func builtMessageContentLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }
    
    func builtUsernameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .right
        label.text = "   "
        label.font = UIFont.boldSystemFont(ofSize: 11)
        return label
    }
    
    func builtDateLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }
    
    func setupBubbleViewConstraints(for viewModel: MessageViewModel) {
        if viewModel.text.count < 5 {
            messageContentLabel.textAlignment = .center
        } else {
            messageContentLabel.textAlignment = .natural
        }
        
        switch viewModel.direction {
        case .right:
            NSLayoutConstraint.deactivate(bubbleViewLeftSideConstraints)
            NSLayoutConstraint.activate(bubbleViewRightSideConstraints)
            bubbleView.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.4274509804, blue: 0.8196078431, alpha: 1)
            messageContentLabel.textColor = .white
            dateLabel.textAlignment = .right
            usernameLabel.textAlignment = .right
        case .left:
            NSLayoutConstraint.deactivate(bubbleViewRightSideConstraints)
            NSLayoutConstraint.activate(bubbleViewLeftSideConstraints)
            bubbleView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
            messageContentLabel.textColor = .black
            dateLabel.textAlignment = .left
            usernameLabel.textAlignment = .left
        }
    }
    
    func dateString(for timestamp: UInt64) -> String {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp)/1000)
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}
