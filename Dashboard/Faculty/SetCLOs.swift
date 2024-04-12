//
//  SetCLOs.swift
//  Director Dashboard
//
//  Created by ADJ on 14/01/2024.
//

import SwiftUI

struct SetCLOs: View { // Design 100% OK
    
    @State private var cloText = ""
    @State private var selectedOptions = 0
    var options = ["CS", "WT" , "SNA" , "SE" , "Isl" , "SRE"]
    
    var body: some View { // Get All Data From Node MongoDB : Pending
        
        NavigationView {
            VStack {
                Text("Create CLOs")
//                    .padding()
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                Text("Course")
                    .bold()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                Picker("" , selection: $selectedOptions){
                    ForEach(0..<options.count) { index in
                        Text(options[index])
                    }
                }
                .accentColor(.green)
                .pickerStyle(.menu)
//                .background(Color.green)
                .environment(\.colorScheme, .dark)
                .frame(maxWidth: .infinity , alignment: .center)
                .padding(.horizontal)
                .cornerRadius(8)
//                Spacer()
                VStack{
                    Text("CLO Description")
                        .padding(.horizontal)
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    TextEditor(text: $cloText)
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(8)
                        .frame(height: 100)
                        .padding(.horizontal)
                }
                .padding()
//                    Spacer()
                    Button("Add"){
                        saveCLOs()
                    }
                    .bold()
                    .padding()
                    .frame(width: 80)
                    .foregroundColor(.black)
                    .background(Color.green)
                    .cornerRadius(8)
//                    Spacer()
                
                VStack{
                    ScrollView {
//                        ForEach(filteredFaculties.indices, id: \.self) { index in
//                            let cr = filteredFaculties[index]
//                            HStack{
//                                Text(cr.f_name)
//                                    .font(.headline)
//                                    .foregroundColor(Color.white)
//                                    .frame(maxWidth: .infinity , alignment: .leading)
//                                Text(cr.username)
//                                    .font(.headline)
//                                    .padding(.horizontal)
//                                    .foregroundColor(Color.white)
//                                    .frame(maxWidth: .infinity , alignment: .center)
//
//                                NavigationLink(destination: EditFaculty(faculty: cr)) {
//                                    Image(systemName: "square.and.pencil.circle")
//                                        .bold()
//                                        .font(.title)
//                                        .foregroundColor(Color.orange)
//                                }
//                                Image(systemName: isFacultyEnabled(index) ? "checkmark.circle.fill" : "nosign")
//                                    .font(.title2)
//                                    .foregroundColor(isFacultyEnabled(index) ? .green : .red)
//                                    .onTapGesture {
//                                        toggleFacultyStatus(index)
//                                    }
//                            }
//                            Divider()
//                                .background(Color.white)
//                                .padding(1)
                        }
//                        if filteredFaculties.isEmpty {
//                            Text("No Data Found")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                        }
                    
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green.opacity(0.5), lineWidth: 1)
                )
                .frame(height:450)
                .onAppear {
//                    facultiesViewModel.fetchExistingFaculties()
                }
                
            }
            .background(Image("fiii").resizable().ignoresSafeArea())
        }
    }
    func saveCLOs() {
        
    }
    
}

struct SetCLOs_Previews: PreviewProvider {
    static var previews: some View {
        SetCLOs()
    }
}
