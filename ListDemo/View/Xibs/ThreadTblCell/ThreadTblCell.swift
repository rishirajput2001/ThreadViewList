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
    @IBOutlet weak var vwSmile: UIView!
    
    @IBOutlet weak var heightTbvReply: NSLayoutConstraint!
    @IBOutlet weak var tbvReply: UITableView!
    
    let attachmentsStack = UIStackView()
    let reactionsStack = UIStackView()
    let replyButton = UIButton(type: .system)
    
    var viewMoreArray = [ThreadList]()
//    var viewMoreArray = [ThreadData]()
    
    var onToggleReplies: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tbvReply.dataSource = self
        tbvReply.delegate = self
        let nib = UINib(nibName: "ViewMoreCell", bundle: nil)
        tbvReply.register(nib, forCellReuseIdentifier: "ViewMoreCell")
//        tbvReply.estimatedRowHeight = 60
        
        setupViews()
        lblFirstName.font = UIFont(name: "Metropolis-Bold", size: 14.0)
        lblCreateTime.font = UIFont(name: "Metropolis-Light", size: 10.0)
        lblDes.font = UIFont(name: "Metropolis-Medium", size: 12.0)
        
        vwSmile.backgroundColor = .white
        vwSmile.layer.cornerRadius = 13
        vwSmile.layer.borderWidth = 1
        vwSmile.layer.borderColor = UIColor.lightGray.cgColor
        vwSmile.layer.shadowColor = UIColor.black.cgColor
        vwSmile.layer.shadowOpacity = 0.1
        vwSmile.layer.shadowOffset = CGSize(width: 1, height: 1)
        
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
        
        viewMoreArray = thread.replies
        lblFirstName.text = "\(thread.user.firstName) \(thread.user.lastName)"
        lblCreateTime.text = formattedDate(thread.createdAt)
        lblDes.text = thread.message

        // Show/hide reply section
        viewRepliesButton.isHidden = !showReplyButton
        tbvReply.isHidden = !isExpanded

        viewRepliesButton.setTitle(isExpanded ? "Hide Replies" : "View \(thread.replies.count) more replies", for: .normal)
        viewRepliesButton.titleLabel?.font = UIFont(name: "Metropolis-Bold", size: 14.0)
        viewRepliesButton.setTitleColor(.black, for: .normal)

        heightBtn.constant = showReplyButton ? 15 : 0

        // Force reload and layout so contentSize is available immediately
        tbvReply.reloadData()
        tbvReply.layoutIfNeeded()

        // Set height after layout
        heightTbvReply.constant = isExpanded ? tbvReply.contentSize.height : 0

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

extension ThreadTblCell: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewMoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tbvReply.dequeueReusableCell(withIdentifier: "ViewMoreCell", for: indexPath) as! ViewMoreCell
         
        let reply =
        cell.lblFirstname.text = viewMoreArray[indexPath.row].user.firstName
        cell.lblDescription.text = viewMoreArray[indexPath.row].message
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
