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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadTblCell", for: indexPath) as? ThreadTblCell
        let threadData = buildThreadData()[indexPath.row]
       let (thread, isReply, showReplyButton) = threadData

        
        let isExpanded = expandedRows.contains(indexPath.row)

        cell?.configure(with: thread, isExpanded: isExpanded, showReplyButton: !thread.replies.isEmpty)

        cell?.onToggleReplies = { [weak self] in
                guard let self = self else { return }

                if self.expandedRows.contains(indexPath.row) {
                    self.expandedRows.remove(indexPath.row)
                } else {
                    self.expandedRows.insert(indexPath.row)
                }

                // Animate height change
                tableView.beginUpdates()
                tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }

          
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.tbvHeight.constant = self.tbvThreds.contentSize.height
        }
    }
}
