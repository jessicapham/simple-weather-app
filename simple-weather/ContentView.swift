//
//  ContentView.swift
//  simple-weather
//
//  Created by Jessica Pham on 9/17/20.
//  Copyright © 2020 Jessica Pham. All rights reserved.
//

import SwiftUI

func fetchWeather (zipcode: String, completion: @escaping([String : Any]) -> Void) {
    let urlOpt = URL(string: "https://api.openweathermap.org/data/2.5/weather?zip=\(zipcode),us&appid=<APIKEY>&units=imperial")
    let session = URLSession.shared
    guard let url = urlOpt else {
       return
    }
    let request = URLRequest(url: url)
    let task = session.dataTask(with: request, completionHandler: {
        data, response, error in
        guard error == nil else {
            return
        }
        guard let data = data else {
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                as? [String:Any] {
                completion(json)
            }
        } catch let error{
                print(error)
            }
        
    })
    task.resume()
}

struct ContentView: View {
    @State var zipcode = ""
    @State var cityName = ""
    @State var temperature  = ""
    @State var weatherLoaded = false
    
    func updateWeather() {
        fetchWeather(zipcode: self.zipcode, completion: { json in
            print(json)
            self.weatherLoaded = true
            if let cityName = json["name"]
                as? String { self.cityName = cityName
            }
            if let main = json["main"] as? [String:Double] {
                if let temperature = main["temp"] {
                    self.temperature = String(format: "%.2f", temperature)
                }
            }
        })
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("Simple Weather App")
                    .font(.title)
                TextField(/*@START_MENU_TOKEN@*/"Zipcode"/*@END_MENU_TOKEN@*/, text: $zipcode)
            }
            Button(action: updateWeather) {
                Text(/*@START_MENU_TOKEN@*/"Look Up Weather"/*@END_MENU_TOKEN@*/)
            }
            Spacer()
            if weatherLoaded {
                VStack {
                       
                       Text("Weather in " + cityName)
                       Text("Temperature: " + temperature)
                   }
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
