//
//  WeatherDetailView.swift
//  Weathersys
//
//  Created by Vamsi on 8/24/24.
//

import SwiftUI

struct WeatherDetailView: View {
    let city: String
    @StateObject private var viewModel = WeatherDetailViewModel()

    var body: some View {
        ZStack {
            Image("backgroundGradient")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Weather Details for \(city)")
                    .padding()
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity)

                if let weather = viewModel.weather {
                    VStack(spacing: 15) {
                        Text("Temperature: \(weather.main.temp)°C")
                        Text("Condition: \(weather.weather.first?.description ?? "")")
                        Text("Wind Speed: \(weather.wind.speed) m/s")
                        Text("Cloudiness: \(weather.clouds.all)%")
                    }
                    .padding()
                    .foregroundColor(.white)
                } else {
                    Text("Loading...")
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchWeatherDetails(for: city)
        }
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(city: "San Francisco")
    }
}
