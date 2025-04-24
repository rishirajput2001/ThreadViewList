//
//  ThreadViewModel.swift
//  ListDemo
//
//  Created by Pushpendra Rajput  on 23/04/25.
//

import Foundation

class ThreadViewModel: ObservableObject {
    @Published var threads: [ThreadList] = []
    @Published var expandedThreadIDs: Set<Int> = []
    
    init() {
        loadThreads()
    }
    
    func loadThreads() {
        guard let url = Bundle.main.url(forResource: "thread_list", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return
        }
        
        do {
            let response = try JSONDecoder().decode(ThreadListResponse.self, from: data)
            threads = response.data.threads
        } catch {
            print("Failed to decode JSON:", error)
        }
    }
    
    func toggleReplies(for threadID: Int) {
        if expandedThreadIDs.contains(threadID) {
            expandedThreadIDs.remove(threadID)
        } else {
            expandedThreadIDs.insert(threadID)
        }
    }
    
    func isExpanded(threadID: Int) -> Bool {
        expandedThreadIDs.contains(threadID)
    }
}

