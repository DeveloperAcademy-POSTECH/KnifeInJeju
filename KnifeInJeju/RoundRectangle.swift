//
//  RoundRectangle.swift
//  KnifeInJeju
//
//  Created by 정지혁 on 2022/04/08.
//

import SwiftUI

struct RoundRectangle: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color.white)
            .cornerRadius(10)
    }
}

struct RoundRectangle_Previews: PreviewProvider {
    static var previews: some View {
        RoundRectangle()
    }
}
