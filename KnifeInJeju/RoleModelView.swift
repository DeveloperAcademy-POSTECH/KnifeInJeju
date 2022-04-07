//
//  RoleModelView.swift
//  KnifeInJeju
//
//  Created by DongKyu Kim on 2022/04/07.
//

import SwiftUI

// 롤모델 관리 View
struct RoleModelView: View {
    var body: some View {
        List(0 ..< 5) { item in
            roleModelContent
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("롤모델")
                    .font(.headline)
            }
        }
    }
    
    private var roleModelContent: some View {
        HStack {
            Circle()
                .frame(width: 30.0)
            Text("RoleModel")
        }
    }
}

struct RoleModelView_Previews: PreviewProvider {
    static var previews: some View {
        RoleModelView()
    }
}
