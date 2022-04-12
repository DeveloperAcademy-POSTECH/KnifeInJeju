//
//  RoleModelView.swift
//  KnifeInJeju
//
//  Created by DongKyu Kim on 2022/04/07.
//

import SwiftUI

class RoleModelManageViewModel: ObservableObject {
    @Published var roleModels: [RoleModel] = []
    
    init() {
        // 백엔드에서 데이터를 가져옴...
        roleModels = RoleModel.dummyData
    }
    
    func deleteRoleModel(at offsets: IndexSet) {
        roleModels.remove(atOffsets: offsets)
    }
    
    //    func delRoleModel(_ item: RoleModel) {
    //        var index = roleModels.firstIndex(of: item)
    //        roleModels.remove(at: )
    //    }
    
}

struct RoleModel: Identifiable, Equatable, Hashable{
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(UUID())
    }
    
    var id = UUID()
    var image: Image = Image(systemName: "person.circle")
    var name: String
    private var profilePictureData: Data?
    var bookmarkToggle: Bool = true
    var bookmarkCount: Int = 0
    var checkToggle: Bool = false
    var profilePicture: UIImage {
        get {
            UIImage(data: profilePictureData ?? Data()) ?? UIImage()
        } set {
            profilePictureData = newValue.getData()
        }
    }
}

extension RoleModel {
    static let dummyData = [
        RoleModel(name: "Cali",
                  bookmarkCount: 0),
        RoleModel(name: "Evan",
                  bookmarkCount: 4),
        RoleModel(name: "Eve",
                  bookmarkCount: 3),
        RoleModel(name: "Jayden",
                  bookmarkCount: 5),
        RoleModel(name: "Juju",
                  bookmarkCount: 2),
        RoleModel(name: "Leeo",
                  bookmarkCount: 100),
        RoleModel(name: "Judy",
                  bookmarkCount: 30),
        RoleModel(name: "role_model",
                  bookmarkCount: 30),
        RoleModel(name: "role__model",
                  bookmarkCount: 30),
        RoleModel(name: "role_model_",
                  bookmarkCount: 30),
        RoleModel(name: "_role_model",
                  bookmarkCount: 30),
        RoleModel(name: "_role_model",
                  bookmarkCount: 30),
        RoleModel(name: "_role_model",
                  bookmarkCount: 30),
        RoleModel(name: "_role_model",
                  bookmarkCount: 30)
    ]
}

// 롤모델 관리 View
struct RoleModelManageView: View {
    @StateObject private var vm = RoleModelManageViewModel()
    
    var body: some View {
        List {
            ForEach($vm.roleModels) { $rolemodel in
                // $ Binding이 없으면 model data를 뿌려주기만 함 (iOS 15부터 추가)
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
                    .frame(width: 280, height: 60, alignment: .leading)
                    
                    HStack(spacing: 2) {
                        Image(systemName: "bookmark.fill")
                        Text("\(rolemodel.bookmarkCount)")
                    }
                    .frame(width: 50, height: 30, alignment: .leading)
                    .foregroundColor(Color(0xFFBE0B))
                }
                //                .swipeActions(edge: .trailing) {
                //                    Button("Del") {rolemodel.viewtoggle = false}
                //
                //                }
            }
            .onDelete(perform: vm.deleteRoleModel)
            
        }
        .listStyle(.plain)
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
