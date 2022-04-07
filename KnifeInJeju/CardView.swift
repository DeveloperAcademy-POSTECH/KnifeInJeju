//
//  CardView.swift
//  KnifeInJeju
//
//  Created by 김예훈 on 2022/04/07.
//

import SwiftUI

struct CardView: View {
    @State private var showCardDetailView = false
    @Binding var question: Question
    var questionCase: QuestionCase
    @EnvironmentObject var mainUser: MainUserViewModel
    
    private var bookmarked: Bool {
        mainUser.checkBookmarked(question)
    }
    
    private var hearted: Bool {
        mainUser.checkHearted(question)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            header
            
            tags
            
            main
            
            Divider()
            
            footer
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.background)
        )
        .opacity(question.answer == nil ? 1 : 0.6)
        .onTapGesture {
            showCardDetailView = true
        }
        .sheet(isPresented: $showCardDetailView) {
            cardDetail
        }
    }
    
    private var cardDetail: some View {
        VStack(alignment: .leading, spacing: 12) {
            UserHeaderView(user: question.from, date: Date())
            header
            tags
            Divider()
                .padding(.vertical, 4)
            Text(question.text)
                .font(.footnote)
            Divider()
                .padding(.top, 56)
                .padding(.vertical, 4)
            if let answer = question.answer {
                VStack(alignment: .leading) {
                    UserHeaderView(user: question.to, date: question.date)
                    Text(answer.text)
                        .font(.footnote)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.systemGray6))
                )
                
            }
            
            Spacer()
        }
        .padding(17)
    }
    
    private var header: some View {
        HStack(spacing: 6) {
            Text("Q.")
            Text(question.title)
                .lineLimit(1)
            
            Spacer()
            
            HStack(spacing: 16) {
                Image(systemName: bookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(bookmarked ? .yellow : .primary)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            if bookmarked {
                                mainUser.removeBookmark(question: question)
                            } else {
                                mainUser.addBookmark(question: question)
                            }
                        }
                    }
                
                HStack {
                    Image(systemName: hearted ? "heart.fill" : "heart")
                    Text("\(question.heartCount)")
                }
                .foregroundColor(hearted ? .red : .primary)
                .onTapGesture {
                    withAnimation(.spring()){
                        if hearted {
                            if mainUser.removeHearted(question: question) {
                                question.heartCount -= 1
                            }
                        } else {
                            mainUser.addHearted(question: question)
                            question.heartCount += 1
                        }
                    }
                }
            }
        }
        .font(.headline.bold())
    }
    
    private var tags: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(question.tags, id: \.self) { tag in
                    TagView(text: tag)
                }
            }
        }
    }
    
    private var main: some View {
        HStack(alignment: .top) {
            Image("")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 64, height: 64)
                .cornerRadius(12)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray5))
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                )
            
            Text(question.text)
                .font(.footnote)
                .frame(height: 64)
                .foregroundColor(.gray)
        }
    }
    
    private var footer: some View {
        HStack {
            UserHeaderView(user: questionCase == .toMe ? question.from : question.to, date: question.date)
            
            Spacer()
            
            if questionCase == .toOther {
                Button {
                    withAnimation(.spring()) {
                        
                    }
                } label: {
                    Text("취소하기")
                }
                .buttonStyle(CardButtonStyle(color: Color(.systemGray6)))
            } else if question.answer != nil {
                Button {
                    showCardDetailView = true
                } label: {
                    Label("답변 완료", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.orange)
                        .font(.headline.bold())
                }
                .buttonStyle(.plain)
            } else {
                Button {
                    withAnimation(.spring()) {
                        question.isRejected = true
                    }
                } label: {
                    Text("거절하기")
                }
                .buttonStyle(CardButtonStyle(color: Color(.systemGray6)))
                
                Button {
                    print("답변")
                } label: {
                    Text("답변하기")
                        .foregroundColor(.white)
                }
                .buttonStyle(CardButtonStyle(color: .orange))
            }
        }
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
