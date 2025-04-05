//
//  TabBarView.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/5/25.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }

            Tab("Flow", systemImage: "newspaper.fill") {
                FlowView()
            }

            Tab("Profile", systemImage: "person.fill") {
                Text("Profile view")
            }
        }
        .tint(Color.NFPrimary)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TabBarView()
}
