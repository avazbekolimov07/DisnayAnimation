//
//  Server.swift
//  Server
//
//  Created by 1 on 15/09/21.
//

import SwiftUI

struct Server: Identifiable {
    var id = UUID().uuidString
    var name: String
    var flag: String
    
}

var servers = [
    Server(name: "United States", flag: "us"),
    Server(name: "India", flag: "in"),
    Server(name: "United Kingdom", flag: "uk"),
    Server(name: "France", flag: "fr"),
    Server(name: "Germany", flag: "gr"),
    Server(name: "Singapore", flag: "si"),
]


