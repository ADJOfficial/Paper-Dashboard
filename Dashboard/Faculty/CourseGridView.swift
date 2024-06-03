//
//  CourseGridView.swift
//  Dashboard
//
//  Created by ADJ on 02/06/2024.
//

import SwiftUI

struct CourseGridView: View {
    
    var c_id: Int
    var c_title: String
    var c_code: String
    
    @StateObject private var gridviewheaderViewModel = GridViewHeaderViewModel()
    @StateObject private var courseclogridviewweightageViewModel = CourseCLOGridViewWeightageViewModel()
    
    var body: some View {
        VStack {
            Text("Grid View")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Spacer()
            Text("\(c_title)")
                .font(.title3)
                .padding()
                .frame(maxWidth: .infinity , alignment: .center)
                .foregroundColor(Color.white)
            Text("\(c_code)")
                .font(.title3)
                .padding()
                .frame(maxWidth: .infinity , alignment: .center)
                .foregroundColor(Color.white)
            Spacer()
            Text("Assessments")
                .font(.title3)
                .cornerRadius(8)
                .foregroundColor(Color.yellow)
            VStack {
                LazyHStack {
                    ForEach(gridviewheaderViewModel.gvh, id: \.self) { cr in
                        VStack {
                            Spacer()
                            Text(cr.name)
                                .font(.headline)
                                .foregroundColor(Color.white)
                            Text("\(String(cr.weightage)) %")
                                .font(.headline)
                                .foregroundColor(Color.black)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.gray) // Set the background color to gray
                                        .frame(maxWidth: .infinity)
                                )
                            Spacer()
                        }
                        .padding(10)
                    }
                }
                
                if gridviewheaderViewModel.gvh.isEmpty {
                    Text("No Header Data Found")
                        .font(.headline)
                        .foregroundColor(.orange)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.green.opacity(0.4), lineWidth: 2)
            )
            .frame(height: 120)
            .onAppear {
                gridviewheaderViewModel.fetchExistingGrid()
            }
            VStack{
                HStack{
                    Text(">>>")
                        .font(.title2)
                        .foregroundColor(Color.orange)
                        .frame(maxWidth: .infinity)
                    Text("Asg")
                        .font(.title2)
                        .foregroundColor(Color.orange)
                        .frame(maxWidth: .infinity)
                    Text("Quiz")
                        .font(.title2)
                        .foregroundColor(Color.orange)
                        .frame(maxWidth: .infinity)
                    Text("Mid")
                        .font(.title2)
                        .foregroundColor(Color.orange)
                        .frame(maxWidth: .infinity)
                    Text("Final") 
                        .font(.title2)
                        .foregroundColor(Color.orange)
                        .frame(maxWidth: .infinity)
                }
                ScrollView {
                    ForEach(courseclogridviewweightageViewModel.CourseCLOgvh, id: \.self) { cr in
                        HStack{
                            Text("\(String(cr.clo_code))")
                                .font(.headline)
                                .foregroundColor(Color.yellow)
                                .frame(maxWidth: .infinity)
                            Text("\(String(cr.weightage1))")
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                            Text("\(String(cr.weightage2))")
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                            Text("\(String(cr.weightage3))")
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                            Text("\(String(cr.weightage4))")
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                        }
                        Divider()
                            .background(Color.white)
                            .padding(1)
                    }
                    if courseclogridviewweightageViewModel.CourseCLOgvh.isEmpty {
                        Text("*No Course CLO Grid View Weightage Found*")
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
                    .stroke(Color.green.opacity(0.6), lineWidth: 2)
            )
            .frame(height:400)
            .onAppear {
                courseclogridviewweightageViewModel.fetchExistingGridWeightage(courseID: c_id)
            }
        }
        .navigationBarItems(leading: backButton)
        .background(Image("fiii").resizable().ignoresSafeArea())
    }
    @Environment(\.presentationMode) var presentationMode
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
    }
}

struct CourseGridView_Previews: PreviewProvider {
    static var previews: some View {
        CourseGridView(c_id: 1, c_title: "", c_code: "")
    }
}
