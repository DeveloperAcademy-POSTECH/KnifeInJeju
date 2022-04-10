//
//  RoleModelView.swift
//  KnifeInJeju
//
//  Created by DongKyu Kim on 2022/04/07.
//

import SwiftUI

class RoleModelManageViewModel: ObservableObject {
    @Published var roleModels: [RoleModel] = []
    
    func delRoleModel(_ item: RoleModel) {
        let index = roleModels.firstIndex(of: item)
        roleModels.remove(at: index!)
    }
    func deleteRoleModel(at offsets: IndexSet) {
        roleModels.remove(atOffsets: offsets)
    }
}

struct RoleModel: Identifiable, Equatable, Hashable{
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(UUID())
    }
    
    var id = UUID()
    var image: Image
    var name: String
    var bookmarkCount: Int
}

extension RoleModel {
    static let dummyData = [
        RoleModel(image: Image(systemName: "person.circle"),
                  name: "Cali",
                  bookmarkCount: 0),
        RoleModel(image: Image(systemName: "person.circle"),
                  name: "Evan",
                  bookmarkCount: 4),
        RoleModel(image: Image(systemName: "person.circle"),
                  name: "Eve",
                  bookmarkCount: 3),
        RoleModel(image: Image(systemName: "person.circle"),
                  name: "Jayden",
                  bookmarkCount: 5),
        RoleModel(image: Image(systemName: "person.circle"),
                  name: "Juju",
                  bookmarkCount: 2),
        RoleModel(image: Image(systemName: "person.circle"),
                  name: "Leeo",
                  bookmarkCount: 100),
        RoleModel(image: Image(systemName: "person.circle"),
                  name: "Judy",
                  bookmarkCount: 30)
    ]
}

// 롤모델 관리 View
struct RoleModelManageView: View {
    @StateObject private var vm = RoleModelManageViewModel()
    @State private var bookmark = 0
    
    var body: some View {
        ScrollView {
            ForEach(RoleModel.dummyData) { rolemodel in
                HStack {
                    HStack{
                        rolemodel.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                        Text(rolemodel.name)
                            .padding()
                    }
                    .frame(width: 250, height: 60, alignment: .leading)
                    HStack(spacing: 2) {
                        Image(systemName: "bookmark")
                        Text("\(rolemodel.bookmarkCount)")
                    }
                    .frame(width: 50, height: 40, alignment: .leading)
                    .foregroundColor(Color(0xFFBE0B))
                }
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("롤모델")
                    .font(.headline)
            }
        }
    }
}

struct RoleModelManageView_Previews: PreviewProvider {
    static var previews: some View {
        RoleModelManageView()
    }
}

//                .swipeActions(edge: .trailing) {
//                    Button(role: .destructive) {
//                        vm.delRoleModel()
//                    } label: {
//                        Label("Delete", systemImage: "trash")
//                    }
//                }


//.onDelete(perform: delete)
