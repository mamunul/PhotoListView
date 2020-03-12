//
//  LRUCache.swift
//  Anonymous
//
//  Created by New User on 6/2/20.
//  Copyright © 2020 Mamunul Mazid. All rights reserved.
//

import Foundation

class LRUCache<Key, Value> where Key: Equatable & Hashable, Value: Equatable {
    private var capacity: Int

    private var cache = [Key: Value]()
    private var queue = [Key]()
    private var dispatchQueue = DispatchQueue(label: "cacheQueue")

    init(capacity: Int = 20) {
        self.capacity = capacity
    }

    func get(key: Key) -> Value? {
        dispatchQueue.sync {
            changeQueuPosition(key)
        }

        return cache[key]
    }

    fileprivate func changeQueuPosition(_ element: Key) {
        queue.removeAll { element2 in
            element2 == element
        }
        queue.append(element)
    }

    private func updateQueue(for key: Key) {
        if cache[key] != nil {
            changeQueuPosition(key)
        } else {
            if queue.count >= capacity {
                cache.removeValue(forKey: queue.first!)
                queue.removeFirst()
            }
            queue.append(key)
        }
    }

    func put(key: Key, value: Value) {
        dispatchQueue.sync {
            if cache[key] == nil {
                cache[key] = value
            }

            updateQueue(for: key)
        }
    }
}
