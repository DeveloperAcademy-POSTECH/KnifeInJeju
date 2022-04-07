//
//  SearchView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/06.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var queryQuestions: [Question] = []
    
    // 백엔드 존재 시 데이터베이스에 쿼리하는 코드가 들어감. but 없으므로 더미 데이터에 쿼리함.
    func query(string: String) {
        
        if let data = Storage.retrive("userQuestions.json", from: .documents, as: [Question].self) {
            let filteredData = data.filter { question in
                let queryedText = question.text + question.title
                return queryedText.contains(string)
            }
            queryQuestions = filteredData
        } else {
            Storage.store(Question.dummyData, to: .documents, as: "userQuestions.json")
            query(string: string)
        }
    }
    
    func sortQuestion(sortCase: SortCase) {
        switch sortCase {
        case .heart:
            queryQuestions = queryQuestions.sorted { $0.heartCount > $1.heartCount }
        case .name:
            queryQuestions = queryQuestions.sorted { $0.title.first ?? "0" < $1.title.first ?? "0" }
        }
        
    }
}

struct SearchView: View {
    @EnvironmentObject var mainUser: MainUserViewModel
    @StateObject private var vm = SearchViewModel()
    @State private var queryString = ""
    @State private var sortCase: SortCase = .heart
    
    var body: some View {
        NavigationView {
            Group {
                if vm.queryQuestions.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                        Text("검색 결과가 없어요..")
                            .font(.headline)
                        Spacer()
                    }
                    .foregroundColor(Color(.systemGray3))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGray6))
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            Spacer().frame(height: 0)
                            
                            HStack {
                                Text("\(vm.queryQuestions.count)개의 검색결과")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Spacer()
                                
                                CustomSortMenu(sortCase: $sortCase)
                            }
                            
                            ForEach($vm.queryQuestions) { $question in
                                CardView(question: $question, questionCase: .toMe)
                                    .environmentObject(mainUser)
                            }
                        }
                        .padding(.horizontal, 17)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGray6))
                }
            }.navigationBarTitle("검색", displayMode: .inline)
        }
        .searchable(text: $queryString, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: queryString) { newValue in
            withAnimation(.spring()) {
                vm.query(string: newValue)
            }
        }
        .onChange(of: sortCase) { newValue in
            withAnimation(.spring()) {
                vm.sortQuestion(sortCase: newValue)
            }
        }
    }
}

enum SortCase: String, CaseIterable, Identifiable {
    
    case heart
    case name
    
    
    var id: String {
        return self.rawValue
    }
    
    var name: String {
        switch self {
        case .heart:
            return "하트"
        case .name:
            return "이름"
        }
    }
    
    var labelImage: String {
        switch self {
        case .heart:
            return "heart.fill"
        case .name:
            return "textformat"
        }
    }
    
    var tintColor: Color {
        switch self {
        case .heart:
            return .red
        case .name:
            return .primary
        }
    }
}


struct CustomSortMenu: View {
    
    @Binding var sortCase: SortCase
    
    var body: some View {
        Menu {
            ForEach(SortCase.allCases) { sort in
                Button(action: {
                    sortCase = sort
                }){
                    Label(sort.name + " 순", systemImage: sort.labelImage)
                        .font(Font.system(.subheadline, design: .default).weight(.semibold))
                }
            }
        } label: {
            HStack(spacing: 12) {
                Label(sortCase.name + " 순", systemImage: sortCase.labelImage)
                    .minimumScaleFactor(0.1)
                    .font(.footnote.weight(.semibold))
                
                Image(systemName: "chevron.down")
                    .font(.footnote.weight(.semibold))
            }
            .padding(.vertical, 10).padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.background)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(.systemGray5))
            )
        }
        .tint(sortCase.tintColor)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
