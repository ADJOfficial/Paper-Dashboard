//
//  PaperStatus.swift
//  Director Dashboard
//
//  Created by ADJ on 14/01/2024.
//

import SwiftUI

struct PaperStatus: View { // Design 100% Ok
    
    var f_id: Int
    var f_name: String
    var c_id: Int
    var c_title: String
    
    @State private var searchText = ""
    @StateObject private var paperViewModel = PaperViewModel()
    
    var filteredPapers: [Paper] { // All Data Will Be Filter and show on Table
        if searchText.isEmpty {
            return paperViewModel.existingPapers
        } else {
            return paperViewModel.existingPapers.filter { paper in
                paper.p_name.localizedCaseInsensitiveContains(searchText) ||
                paper.status.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    struct SearchBar: View { // Search Bar avaible outside of table to search record
        @Binding var text: String
        
        var body: some View {
            HStack {
                TextField("Search", text: $text)
                    .padding()
                    .frame(width: 247 , height: 40)
                    .background(Color.gray.opacity(1))
                    .cornerRadius(8) // Set the corner radius to round the corners
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(Color.red.opacity(0.9))
                }
                .opacity(text.isEmpty ? 0 : 1)
            }
        }
    }
    func getColorForStatus(_ status: String) -> Color {
        switch status {
        case "Approved":
            return Color.green
        case "Pending":
            return Color.yellow
        case "Rejected":
            return Color.red
        default:
            return Color.white
        }
    }
    
    var body: some View { // Get All Data From Node MongoDB : Pending
        
        NavigationView {
            VStack {
                Text("Papers Status")
                    .bold()
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                SearchBar(text: $searchText)
                    .padding()
                Spacer()
                VStack{
                    ScrollView {
                        ForEach(filteredPapers.indices, id: \.self) { index in
                            let cr = filteredPapers[index]
                            HStack{
                                Text(cr.p_name)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                Text(cr.status)
                                    .font(.headline)
                                    .foregroundColor(getColorForStatus(cr.status))
                                    .frame(maxWidth: .infinity , alignment: .trailing)
                            }
                            Divider()
                                .background(Color.white)
                                .padding(1)
                        }
                        if filteredPapers.isEmpty {
                            Text("\(f_name) Have Not Maked Any Paper Yet ...")
                                .font(.headline)
                                .foregroundColor(.orange)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green.opacity(0.5), lineWidth: 1)
                )
                .frame(height:650)
                .onAppear {
                    paperViewModel.fetchFacultyPaper(facultyID: f_id)
                }
                Spacer()
            }
            .background(Image("fiii").resizable().ignoresSafeArea())
        }
    }
}

struct PaperStatus_Previews: PreviewProvider {
    static var previews: some View {
        PaperStatus(f_id: 1,f_name: "", c_id: 1, c_title: "")
    }
}
