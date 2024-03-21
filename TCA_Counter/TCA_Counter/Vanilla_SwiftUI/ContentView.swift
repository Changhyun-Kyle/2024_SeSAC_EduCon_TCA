//
//  ContentView.swift
//  TCA_Counter
//
//  Created by 강창현 on 3/21/24.
//

import SwiftUI

struct NetworkService {
    static func fetch(number: Int) async throws -> String {
        let (data, _) = try await URLSession.shared.data(
            from: URL(string: "http://www.numbersapi.com/\(number)")!
        )
        return String(decoding: data, as: UTF8.self)
    }
}

final class CounterFeature: ObservableObject {
    @Published var count: Int = 0
    @Published var fact: String?
    @Published var isLoadingFact: Bool = false
    @Published var isTimerOn: Bool = false
    
    func decrementButtonTapped() {
        self.count -= 1
        self.fact = nil
    }
    
    func incrementButtonTapped() {
        count += 1
        fact = nil
    }
    
    @MainActor
    func getFactButtonTapped() async {
        self.fact = nil
        self.isLoadingFact = true
            do {
                let result = try await NetworkService.fetch(number: self.count)
                self.factResponse(fact: result)
            } catch {
                print(error.localizedDescription)
            }
    }
    
    private func factResponse(fact: String) {
        self.fact = fact
        self.isLoadingFact = false
    }
}

struct ContentView: View {
    @EnvironmentObject var counterFeature: CounterFeature
    var body: some View {
        Form {
            Section {
                Text("\(self.counterFeature.count)")
                Button("+") {
                    self.counterFeature.count += 1
                }
                Button("-") {
                    self.counterFeature.count -= 1
                }
            }
            
            Section {
                Button {
                    Task {
                        await self.counterFeature.getFactButtonTapped()
                    }
                } label: {
                    HStack {
                        Text("데이터 가져오기")
                        if self.counterFeature.isLoadingFact {
                          Spacer()
                          ProgressView()
                        }
                    }
                }
                if let fact = counterFeature.fact {
                    Text(fact)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CounterFeature())
}
