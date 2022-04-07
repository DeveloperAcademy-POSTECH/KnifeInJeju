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
}

struct SearchView: View {
    @EnvironmentObject var mainUser: MainUserViewModel
    @StateObject private var vm = SearchViewModel()
    @State private var queryString = ""
    
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
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            Spacer().frame(height: 0)
                            
                            Text("\(vm.queryQuestions.count)개의 검색결과")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
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
            }.navigationBarTitle("", displayMode: .inline)
        }
        .searchable(text: $queryString, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: queryString) { newValue in
            withAnimation(.spring()) {
                vm.query(string: newValue)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
