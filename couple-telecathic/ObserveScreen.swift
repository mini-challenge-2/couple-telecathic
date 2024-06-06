//
//  ObserveScreen.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 03/06/24.
//
//-7.257412, 112.745233

import SwiftUI
import WeatherKit
import CoreLocation

struct ObserveScreen: View {
    @Environment(LocationManager.self) var locationManager
    @State private var selectedCity: City?
    let weatherManager = WeatherManager.shared
    @State private var currentWeather: CurrentWeather?
    @State private var isLoading = false
    @State var condition: String = "Unknown"
    
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text("Your Partner's Distance").foregroundStyle(.grayDisabled)
                    let coordinate1 = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
                    let coordinate2 = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)

                    let distanceInMeters = coordinate1.distance(from: coordinate2)
                    let distanceKM = distanceInMeters/1000
                    Text("\(String(format: "%.0f", distanceKM)) Km").font(.title).fontWeight(.bold)
                }
                Spacer()
            }.padding(20)
            HStack{
                VStack(alignment: .leading){
                    if let selectedCity {
                        if isLoading {
                            ProgressView()
                                Text("Fetching Weather...")
                        } else {
                            Text("📍\(selectedCity.name)").font(.title).fontWeight(.bold)

                        }
                    }
                    
                    Text(currentWeather?.condition.description ?? "Unknown")
                        .font(.title2)
                        .fontWeight(.semibold)
                        //                    Text("Sunnny Cloudy").font(.title2).fontWeight(.semibold)
                    Text(Date.now.formatted(date: .omitted, time: .shortened)).font(.headline).foregroundStyle(.grayDisabled)
                    
                    
                }
                    
                
                Spacer()
            }.padding(.horizontal, 20)
            
            
            VStack(alignment: .center){
                if isLoading {
                    ProgressView()
                        Text("Fetching Weather...")
                } else {
                    if let currentWeather {
                        let temp = weatherManager.temperatureFormatter.string(from: currentWeather.temperature)
                        Text(temp)
                            .font(.system(size: 76))
                            .fontWeight(.bold)

                                }
                            }
                
                HStack{
                    switch currentWeather?.condition.description {
                        case "Clear":
                            Image("sun")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 141, maxHeight: 60)
                        case "Cloudy":
                            Image("cloud")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 141, maxHeight: 60)
                        case "Drizzle":
                            Image("rain")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 141, maxHeight: 60)
                        case "Haze":
                            Image("cloud")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 141, maxHeight: 60)
                        case "Heavy Rain":
                            Image("storm-rain")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 141, maxHeight: 60)
                        case "Hot":
                            Image("sunny")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 141, maxHeight: 60)
                        case "Isolated Thunderstorms":
                            Image("storm")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 141, maxHeight: 60)
                        case "Mostly Clear":
                            Image("sunny")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 141, maxHeight: 60)
                        case "Mostly Cloudy":
                            Image("cloud")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 141, maxHeight: 60)
                        case "PartlyCloudy":
                            Image("sunny-cloudy")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 141, maxHeight: 60)
                        case "Rain":
                            Image("rain")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 141, maxHeight: 60)
                        case "Thunderstorms":
                            Image("storm")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 141, maxHeight: 60)
                        default:
                            Image("cloud")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 141, maxHeight: 60)
                        }
                
                }
                Spacer()
                switch selectedCity?.name {
                case "Surabaya":
                    Image("indonesia")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 200, maxHeight: 200)
                default:
                    Image("singapore")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 100, maxHeight: 150)
                }
                
            }
            
            Spacer()
        }.navigationTitle("Observe")
        .task(id: locationManager.currentLocation){
            if let currentLocation = locationManager.currentLocation, selectedCity == nil {
                selectedCity = currentLocation
            }
        }
        .task(id: selectedCity){
            if let selectedCity {
                await fetchWeather(for: selectedCity)
            }
        }
    }
    
    func fetchWeather(for city: City) async {
        isLoading = true
        Task.detached { @MainActor in
            currentWeather = await weatherManager.currentWeather(for: city.clLocation)
            
        }
        isLoading = false
    }
    
}

#Preview {
    NavigationStack{
        ObserveScreen()
            .environment(LocationManager())
    }
}
