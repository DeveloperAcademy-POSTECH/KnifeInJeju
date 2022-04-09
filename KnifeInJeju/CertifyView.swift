//
//  CertifyView.swift
//  KnifeInJeju
//
//  Created by 정지혁 on 2022/04/09.
//

import SwiftUI

struct CertifyView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("어떤 전문가인지 선택해주세요.")
                .font(.subheadline)
            RoundRectangle()
                .frame(height: 42)
            
            Text("첨부 파일을 업로드해주세요.")
                .font(.subheadline)
                .padding(.top, 40)
            Text("해당 전문가를 증명할 수 있는 사진을 첨부해주세요.")
                .font(.caption)
                .foregroundColor(.secondary)
            RoundRectangle()
                .frame(height: 160)
            
            Text("제출 시 유의사항\n\n1. 해당 첨부파일은 관리자에게 전송되어 검토 과정을 거치게 됩니다.\n2. 개인정보에 해당하는 내용은 지워서 첨부해주시길 바랍니다.")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 40)
            
            Spacer()
            
            Button(action: {}) {
                Text("제출하기")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(.orange)
            .cornerRadius(10)
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

struct CertifyView_Previews: PreviewProvider {
    static var previews: some View {
        CertifyView()
    }
}
