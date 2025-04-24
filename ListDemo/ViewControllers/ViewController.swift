//
//  ViewController.swift
//  ListDemo
//
//  Created by Pushpendra Rajput  on 23/04/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    @IBOutlet weak var tbvThreds: UITableView!
    var threads: [ThreadList] = []
    var expandedThreads: Set<Int> = []
    var expandedRows: Set<Int> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Threads"
        view.backgroundColor = .white
        
        setupTableView()
        loadThreadsFromJSON()
    }
    
    private func setupTableView() {
        
        let nib = UINib(nibName: "ThreadTblCell", bundle: nil)
        tbvThreds.register(nib, forCellReuseIdentifier: "ThreadTblCell")
        
        tbvThreds.dataSource = self
        tbvThreds.delegate = self
        tbvThreds.estimatedRowHeight = 100
        tbvThreds.rowHeight = UITableView.automaticDimension
        
    }
    
    private func loadThreadsFromJSON() {
        guard let url = Bundle.main.url(forResource: "thread_list", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to read thread_list.json")
            return
        }
        
        do {
            let result = try JSONDecoder().decode(ThreadListResponse.self, from: data)
            self.threads = result.data.threads
            
        } catch {
            print("Failed to parse JSON:", error)
        }
        
        self.tbvThreds.reloadData()
    }
    
    func buildThreadData() -> [(ThreadList, Bool, Bool)] {
        var rows: [(ThreadList, Bool, Bool)] = []
        
        for thread in threads {
            rows.append((thread, false, !thread.replies.isEmpty))
            
            if expandedThreads.contains(thread.id) {
                let shownReplies = thread.replies.prefix(3)
                for reply in shownReplies {
                    rows.append((reply, true, false))
                }
                
                if thread.replies.count > 3 {
                    let loadMoreThread = ThreadList(id: thread.id, message: "", mentionList: [], attachmentsJson: nil, user: thread.user, replies: [])
                    rows.append((loadMoreThread, false, true))
                }
            }
        }
        return rows
    }
}


