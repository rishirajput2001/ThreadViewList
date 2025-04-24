//
//  ViewController+Extention.swift
//  ListDemo
//
//  Created by Pushpendra Rajput  on 23/04/25.
//

import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildThreadData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let threadData = buildThreadData()[indexPath.row]
        let (thread, isReply, showReplyButton) = threadData
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadTblCell", for: indexPath) as? ThreadTblCell
        
        let isExpanded = expandedThreads.contains(thread.id)
        cell?.configure(with: thread, isReply: isReply, isExpanded: isExpanded, showReplyButton: showReplyButton)
        cell?.onToggleReplies = { [weak self] in
            guard let self = self else { return }
            if self.expandedThreads.contains(thread.id) {
                self.expandedThreads.remove(thread.id)
            } else {
                self.expandedThreads.insert(thread.id)
            }
            self.tbvThreds.reloadData()
        }
        
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
