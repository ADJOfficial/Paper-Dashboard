//
//  VerifiedPapers.swift
//  Director Dashboard
//
//  Created by ADJ on 13/01/2024.
//

//import SwiftUI
//
//struct ApprovedPaper: View { // Design 100% OK
//
//    @State private var showAlert = false
//    @State private var printedPaperName = ""
//
//    @State private var searchText = ""
//    @StateObject private var paperViewModel = PaperViewModel()
//
//    var filteredPapers: [Paper]{ // All Data Will Be Filter and show on Table
//            if searchText.isEmpty {
//                return paperViewModel.existingPapers
//            } else {
//                return paperViewModel.existingPapers.filter { faculty in
//                    faculty.p_name.localizedCaseInsensitiveContains(searchText)
//                }
//            }
//        }
//
//    struct SearchBar: View { // Search Bar avaible outside of table to search record
//        @Binding var text: String
//
//        var body: some View {
//            HStack {
//                TextField("Search", text: $text)
//                    .padding()
//                    .frame(width: 247 , height: 40)
//                    .background(Color.gray.opacity(1))
//                    .cornerRadius(8) // Set the corner radius to round the corners
//                    .padding(.horizontal)
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//                Button(action: {
//                    text = ""
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .font(.title3)
//                        .foregroundColor(Color.red.opacity(0.9))
//                }
//                .opacity(text.isEmpty ? 0 : 1)
//            }
//        }
//    }
//    var body: some View { // Get All Data From Node MongoDB : Pending
//
//        NavigationView {
//            VStack {
//                Text("Approved Papers")
//                    .bold()
//                    .padding()
//                    .font(.largeTitle)
//                    .foregroundColor(Color.white)
//                Spacer()
//                SearchBar(text: $searchText)
//                    .padding()
//                Spacer()
//                VStack{
//                    ScrollView {
//                        ForEach(filteredPapers.indices, id: \.self) { index in
//                            let cr = filteredPapers[index]
//                            HStack{
//                                Text(cr.p_name)
//                                    .font(.headline)
//                                    .foregroundColor(Color.white)
//                                    .frame(maxWidth: .infinity , alignment: .leading)
//
//                                Image(systemName: isPaperApproved(index) ? "printer.filled.and.paper" : "printer.filled.and.paper")
//                                    .font(.title2)
//                                    .foregroundColor(isPaperApproved(index) ? .green : .yellow)
//                                    .onTapGesture {
//                                        togglePaperStatus(index)
//                                    }
//                            }
//                            Divider()
//                                .background(Color.white)
//                                .padding(1)
//                        }
//                        if filteredPapers.isEmpty {
//                            Text("No Approved Paper Found")
//                                .font(.headline)
//                                .foregroundColor(.orange)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                        }
//                    }
//                }
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(Color.gray.opacity(0.4), lineWidth: 2)
//                )
//                .frame(height:700)
//                .onAppear {
//                    paperViewModel.fetchApprovedPapers()
//                }
//                Spacer()
//            }
//            .alert(isPresented: $showAlert) {
//                Alert(title: Text("Paper Printed"), message: Text("\(printedPaperName) Paper has been Printed"), dismissButton: .default(Text("OK")))
//            }
//            .navigationBarItems(leading: backButton)
//            .background(Image("fw").resizable().ignoresSafeArea())
//        }
//    }
//    @Environment(\.presentationMode) var presentationMode
//    private var backButton: some View {
//        Button(action: {
//            presentationMode.wrappedValue.dismiss()
//        }) {
//            Image(systemName: "chevron.left")
//                .foregroundColor(.blue)
//                .imageScale(.large)
//        }
//    }
//
//    func isPaperApproved(_ index: Int) -> Bool {
//        let paper = filteredPapers[index]
//        return paper.status == "Approved"
//    }
//
//    func togglePaperStatus(_ index: Int) {
//        let paper = filteredPapers[index]
//
//        guard paper.status == "Approved" else {
//            return
//        }
//
//        printedPaperName = paper.p_name
//
//        let newStatus = "Printed"
//
//        guard let url = URL(string: "http://localhost:8000/updatepaperstatus/\(paper.p_id)") else {
//            return
//        }
//
//        guard let jsonData = try? JSONEncoder().encode(["status": newStatus]) else {
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error updating paper status: \(error.localizedDescription)")
//            } else if let data = data {
//                if let responseString = String(data: data, encoding: .utf8) {
//                    print("Paper status updated successfully: \(responseString)")
//
//                    DispatchQueue.main.async {
//                        showAlert = true
//                        paperViewModel.existingPapers.removeAll { $0.p_id == paper.p_id }
//                    }
//                }
//            }
//        }.resume()
//    }
//}
import SwiftUI
import UIKit

struct ApprovedPaper: View { // Design 100% OK
    @State private var showAlert = false
    @State private var printedPaperName = ""
    @State private var searchText = ""
    @StateObject private var paperViewModel = PaperViewModel()

    var filteredPapers: [Paper] { // All Data Will Be Filter and show on Table
        if searchText.isEmpty {
            return paperViewModel.existingPapers
        } else {
            return paperViewModel.existingPapers.filter { faculty in
                faculty.p_name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    struct SearchBar: View { // Search Bar avaible outside of table to search record
        @Binding var text: String

        var body: some View {
            HStack {
                TextField("Search", text: $text)
                    .padding()
                    .frame(width: 247, height: 40)
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

    var body: some View { // Get All Data From Node MongoDB : Pending
        NavigationView {
            VStack {
                Text("Approved Papers")
                    .bold()
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                SearchBar(text: $searchText)
                    .padding()
                Spacer()
                VStack {
                    ScrollView {
                        ForEach(filteredPapers.indices, id: \.self) { index in
                            let cr = filteredPapers[index]
                            HStack {
                                Text(cr.p_name)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: isPaperApproved(index) ? "printer.filled.and.paper" : "printer.filled.and.paper")
                                    .font(.title2)
                                    .foregroundColor(isPaperApproved(index) ? .green : .yellow)
                                    .onTapGesture {
                                        if let window = UIApplication.shared.windows.first,
                                           let rootViewController = window.rootViewController {
                                            let pdfData = generatePDF(from: rootViewController.view)
                                            if let pdfData = pdfData,
                                               let pdfURL = savePDF(data: pdfData, named: "Paper-\(cr.p_name).pdf") {
                                                printPDF(from: pdfURL)
                                                togglePaperStatus(index)
                                            }
                                        }
                                    }
                            }
                            Divider()
                                .background(Color.white)
                                .padding(1)
                        }
                        if filteredPapers.isEmpty {
                            Text("No Approved Paper Found")
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
                        .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                )
                .frame(height: 700)
                .onAppear {
                    paperViewModel.fetchApprovedPapers()
                }
                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Paper Printed"), message: Text("\(printedPaperName) Paper has been Printed"), dismissButton: .default(Text("OK")))
            }
            .navigationBarItems(leading: backButton)
            .background(Image("fw").resizable().ignoresSafeArea())
        }
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

    func isPaperApproved(_ index: Int) -> Bool {
        let paper = filteredPapers[index]
        return paper.status == "Approved"
    }

    func togglePaperStatus(_ index: Int) {
        let paper = filteredPapers[index]

        guard paper.status == "Approved" else {
            return
        }

        printedPaperName = paper.p_name

        let newStatus = "Printed"

        guard let url = URL(string: "http://localhost:8000/updatepaperstatus/\(paper.p_id)") else {
            return
        }

        guard let jsonData = try? JSONEncoder().encode(["status": newStatus]) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating paper status: \(error.localizedDescription)")
            } else if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Paper status updated successfully: \(responseString)")

                    DispatchQueue.main.async {
                        showAlert = true
                        paperViewModel.existingPapers.removeAll { $0.p_id == paper.p_id }
                    }
                }
            }
        }.resume()
    }
}

func generatePDF(from view: UIView) -> Data? {
    let pdfRenderer = UIGraphicsPDFRenderer(bounds: view.bounds)
    let data = pdfRenderer.pdfData { context in
        context.beginPage()
        view.layer.render(in: context.cgContext)
    }
    return data
}

func savePDF(data: Data, named fileName: String) -> URL? {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    let pdfURL = documentsDirectory.appendingPathComponent(fileName)

    do {
        try data.write(to: pdfURL)
        return pdfURL
    } catch {
        print("Could not save PDF file: \(error.localizedDescription)")
        return nil
    }
}

func printPDF(from url: URL) {
    let printController = UIPrintInteractionController.shared
    let printInfo = UIPrintInfo(dictionary: nil)
    printInfo.outputType = .general
    printInfo.jobName = url.lastPathComponent
    printController.printInfo = printInfo
    printController.printingItem = url

    printController.present(animated: true, completionHandler: nil)
}

struct VerifiedPapers_Previews: PreviewProvider {
    static var previews: some View {
        ApprovedPaper()
    }
}
