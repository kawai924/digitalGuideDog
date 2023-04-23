// Created by Florian Schweizer on 20.06.22

import Combine

class ARManager {
    static let shared = ARManager()
    private init() { }
    
    var actionStream = PassthroughSubject<ARAction, Never>()
}
