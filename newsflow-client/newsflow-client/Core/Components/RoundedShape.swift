//
//  RoundedShape.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/4/25.
//

import SwiftUI

struct RoundedShape: Shape {
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect, byRoundingCorners: corners,
            cornerRadii: CGSize(width: 60, height: 60)
        )

        return Path(path.cgPath)
    }
} 

#Preview {
    RoundedShape(corners: .bottomLeft)
}
