//
//  ThreadTblCell.swift
//  ListDemo
//
//  Created by Pushpendra Rajput  on 23/04/25.
//

import UIKit

class ThreadTblCell: UITableViewCell {
    
    @IBOutlet weak var heightBtn: NSLayoutConstraint!
    @IBOutlet weak var profileImgaeView: UIImageView!
    @IBOutlet weak var lblFirstName: UILabel!
    
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var lblCreateTime: UILabel!
    
    @IBOutlet weak var leadingView: NSLayoutConstraint!
    @IBOutlet weak var viewRepliesButton: UIButton!
    let attachmentsStack = UIStackView()
    let reactionsStack = UIStackView()
    let replyButton = UIButton(type: .system)
    
    
    var onToggleReplies: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        lblFirstName.font = UIFont(name: "Metropolis-Bold", size: 14.0)
        lblCreateTime.font = UIFont(name: "Metropolis-Light", size: 10.0)
        lblDes.font = UIFont(name: "Metropolis-Medium", size: 12.0)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setupViews() {
        selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        attachmentsStack.axis = .horizontal
        attachmentsStack.spacing = 8
        attachmentsStack.distribution = .fillEqually
        
        reactionsStack.axis = .horizontal
        reactionsStack.spacing = 4
        
        viewRepliesButton.titleLabel?.font = .systemFont(ofSize: 12)
        viewRepliesButton.setTitleColor(.systemBlue, for: .normal)
        viewRepliesButton.addTarget(self, action: #selector(toggleReplies), for: .touchUpInside)
    }
    
    func configure(with thread: ThreadList, isReply: Bool = false, isExpanded: Bool = false, showReplyButton: Bool = false) {
        lblFirstName.text = "\(thread.user.firstName) \(thread.user.lastName)"
        lblCreateTime.text = formattedDate(thread.createdAt)
       
        lblDes.text = thread.message
        
        viewRepliesButton.isHidden = !showReplyButton
        viewRepliesButton.setTitle(isExpanded ? "Hide Replies" : "View 3 more replies", for: .normal)
        viewRepliesButton.titleLabel?.font = UIFont(name: "Metropolis-Bold", size: 14.0)
        viewRepliesButton.setTitleColor(.black, for: .normal)
        if showReplyButton == false {
            heightBtn.constant = 0
        }else {
            heightBtn.constant = 15
        }
        
        reactionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if let reactions = thread.reactions {
            for reaction in reactions {
                let emojiLabel = UILabel()
                emojiLabel.text = reaction.emoji + " \(reaction.users.count)"
                emojiLabel.font = .systemFont(ofSize: 12)
                emojiLabel.backgroundColor = UIColor.systemGray5
                emojiLabel.layer.cornerRadius = 4
                emojiLabel.clipsToBounds = true
                reactionsStack.addArrangedSubview(emojiLabel)
            }
        }
        attachmentsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if let attachments = thread.attachmentsJson {
            for file in attachments {
                let button = UIButton(type: .system)
                button.setTitle(file.fileOriginalName, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 12)
                button.backgroundColor = .systemGray6
                button.layer.cornerRadius = 6
                attachmentsStack.addArrangedSubview(button)
            }
        }
        
        contentView.backgroundColor = isReply ? UIColor.systemGray6 : .white
    }
    
    let tenMinutesAgo = Calendar.current.date(byAdding: .minute, value: -10, to: Date())!
    let isoFormatter = ISO8601DateFormatter()

    private func formattedDate(_ dateStr: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] 
        guard let date = formatter.date(from: dateStr) else { return dateStr }

        let relative = RelativeDateTimeFormatter()
        relative.unitsStyle = .full
        return relative.localizedString(for: date, relativeTo: Date())
    }

    @objc private func toggleReplies() {
        onToggleReplies?()
    }
}
