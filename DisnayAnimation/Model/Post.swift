//
//  Post.swift
//  Post
//
//  Created by 1 on 16/09/21.
//

import SwiftUI

struct Post: Identifiable {
    
    var id = UUID().uuidString
    var imageName : String
    var isLiked: Bool = false
    
}

