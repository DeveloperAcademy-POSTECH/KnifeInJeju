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
    @State var selectCount = 0
    
    var body: some View {
        
        VStack {
            headLineView
            ScrollView(showsIndicators: false) {
                ForEach($vm.roleModels) { $rolemodel in
                    HStack {
                        HStack{
                            Image(uiImage: rolemodel.profilePicture )
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .background(
                                    ZStack {
                                        Circle().fill(Color(.systemGray5))
                                        Image(systemName: "photo")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                )
                            Text(rolemodel.name)
                                .font(.system(size: 16.0, weight: .regular))
                            
                        }
                        .frame(width: 310, height: 60, alignment: .leading)
                        
                        Toggle(isOn: $rolemodel.checkToggle) {
                        }
                        .frame(width: 30, height: 40)
                        .foregroundColor(Color(0xFF9407))
                        .toggleStyle(CircleToggleStyle(selectCount: $selectCount))
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
            if selectCount == 1 {
                questionButton
            }
        }
    }
    
    private var headLineView: some View {
        Text("누구에게 질문하고 싶으신가요?")
            .font(.system(size: 20.0, weight: .semibold))
            .frame(width: 356, height: 30, alignment: .leading)
            .padding()
    }
    
    private var questionButton: some View {
        NavigationLink(destination: AskView()) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 356, height: 40)
                Text("질문하기")
                    .font(.system(size: 17.0, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.bottom)
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
    @Binding var selectCount : Int
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            if selectCount < 1 && configuration.isOn == false{
                configuration.isOn.toggle()
                selectCount += 1
            } else if selectCount == 1 && configuration.isOn == true {
                configuration.isOn.toggle()
                selectCount -= 1
            }
            print(selectCount)
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
