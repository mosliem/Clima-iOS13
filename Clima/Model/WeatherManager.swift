

import Foundation
import CoreLocation

protocol  WeatherMangerDelegate {
    func didUpdateWeather(_ weatherManger: WeatherManager ,weather : WeatherModel)
}

struct WeatherManager
{
    
    var delegate : WeatherMangerDelegate?
    let WeatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=7396a74bb7f29326be64ba1015930c6c&units=metric"
    
    
    func fetchWeatherData(cityName : String)
    {
        let urlString = "\(WeatherUrl)&q=\(cityName)"
        perfromRequest(urlString: urlString)
    }
    
    func fetchWeatherData(latitude : CLLocationDegrees , longtitude : CLLocationDegrees)
    {
        let urlString = "\(WeatherUrl)&lon=\(longtitude)&lat=\(latitude)"
        perfromRequest(urlString: urlString)
    }
    func perfromRequest(urlString : String)
    {
        if let url = URL(string: urlString)
           {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data,response, error) in
                if error != nil
                 {
                     print(error!)
                     return
                 }
                 if let safeData = data
                 {
                if let weather =  self.parseJSON(data: safeData)
                   {
                    self.delegate?.didUpdateWeather(self , weather: weather)
                   }
            }
            }
            task.resume()
        
           }
  }
    
    func parseJSON(data : Data) -> WeatherModel?
     {
      let decoder = JSONDecoder()
        do
        {
            let decodedData =  try decoder.decode(WeatherData.self, from: data)
            let weatherModel = WeatherModel(conditionId: decodedData.weather[0].id, temp: decodedData.main.temp, cityName: decodedData.name)
            return weatherModel
        }
        catch{
            print(error)
            return nil
        }
     }
    
    
}
