//
//  RoleModelSelectView.swift
//  KnifeInJeju
//
//  Created by DongKyu Kim on 2022/04/11.
//

import SwiftUI

//struct RoleModel: Identifiable, Hashable {
//    let id: UUID()
//    let name: String
//}

struct RoleModelSelectView: View {
    @StateObject private var vm = RoleModelManageViewModel()
    
    var body: some View {
        headLineView
        ScrollView {
            ForEach(RoleModel.dummyData) { rolemodel in
                let name = rolemodel.name
                let image = rolemodel.image
                HStack{
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                    Text(name)
                        .padding()
                }
                .frame(width: 250, height: 60, alignment: .leading)
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("롤모델 선택")
                    .font(.headline)
            }
        }
    }
    
    private var headLineView: some View {
        Text("누구에게 질문하고 싶으신가요?")
            .font(.headline)
            .frame(width: 356, height: 30, alignment: .leading)
            .padding()
    }
}

struct RoleModelSelectView_Previews: PreviewProvider {
    static var previews: some View {
        RoleModelSelectView()
    }
}
