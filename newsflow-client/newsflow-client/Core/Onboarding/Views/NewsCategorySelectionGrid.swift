//
//  NewsCategorySelectionGrid.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 3/31/25.
//

import SwiftUI

struct NewsCategorySelectionGrid: View {
    @Binding var selectedIndices: [Int]
    let categories: [String]

    private var gridItemLayout = [GridItem(.adaptive(minimum: 100))]

    init(selectedIndices: Binding<[Int]>, categories: [String]) {
        _selectedIndices = selectedIndices
        self.categories = categories
    }

    var body: some View {
        LazyVGrid(columns: gridItemLayout, spacing: 8) {
            ForEach(categories.indices, id: \.self) { index in
                Text(categories[index])
                    .foregroundStyle(Color.NFPrimary)
                    .bold()
                    .padding([.horizontal, .vertical], 8)
                    .background(selectedIndices.contains(index) ? Color.cyan.opacity(0.8) : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .fixedSize()
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.NFPrimary, lineWidth: 1.5)
                    }
                    .onTapGesture {
                        if selectedIndices.contains(index) {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                selectedIndices.removeAll { $0 == index }
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                selectedIndices.append(index)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    NewsCategorySelectionGrid(
        selectedIndices: .constant([]),
        categories: ["Business", "Entertainment", "Health", "Science", "Technology", "Sport", "General"])
}
