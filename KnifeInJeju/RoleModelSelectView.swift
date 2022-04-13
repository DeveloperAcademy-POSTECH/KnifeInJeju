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
    @State private var selectRoleModel = false
    
    var body: some View {
        headLineView
        ScrollView {
            ForEach(RoleModel.dummyData) { rolemodel in
                HStack {
                    HStack{
                        rolemodel.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                        Text(rolemodel.name)
                            .font(.system(size: 16.0, weight: .regular))
                        
                    }
                    .frame(width: 300, height: 60, alignment: .leading)
                    Toggle(isOn: $selectRoleModel) {
                        Text("선택됨")
                    }
                    .foregroundColor(Color(0xFF9407))
                    .toggleStyle(CircleToggleStyle())
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("롤모델 선택")
                    .font(.headline)
            }
        }
        questoinButton
    }
    
    private var headLineView: some View {
        Text("누구에게 질문하고 싶으신가요?")
            .font(.system(size: 20.0, weight: .semibold))
            .frame(width: 356, height: 30, alignment: .leading)
            .padding()
    }
    
    private var questoinButton: some View {
        Button(action: {}) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 356, height: 40)
                Text("질문하기")
                    .font(.system(size: 17.0, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

struct RoleModelSelectView_Previews: PreviewProvider {
    static var previews: some View {
        RoleModelSelectView()
    }
}

struct CircleToggleStyle: ToggleStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                ZStack {
                    Circle()
                        .stroke(Color(0x979797))
                        .frame(width: 29, height: 29)
                    Image(systemName: configuration.isOn ? "record.circle.fill" : "")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                }
                
                
            }
        })
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }
}
