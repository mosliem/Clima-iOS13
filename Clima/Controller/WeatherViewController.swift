import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var SearchField: UITextField!
    var weatherManger = WeatherManager()
    let locationManager = CLLocationManager()
override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
     
        SearchField.delegate = self
        weatherManger.delegate = self
    }
    
    
    @IBAction func GPSButtonPressed(_ sender: UIButton)
    {
        locationManager.requestLocation()
    }
    
}

//MARK:- UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate
{
    @IBAction func SearchButtonPressed(_ sender: UIButton)
    {
      SearchField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
      textField.endEditing(true)
      return true
    }
    func textFieldShouldEndEditing(_ SearchField: UITextField) -> Bool
    {
        if SearchField.text != ""
        {
            return true
        }
        else
        {
            SearchField.placeholder = "Type Something!"
            return false
        }
    }
    func textFieldDidEndEditing(_ Searchfiled: UITextField)
    {
        if let city = SearchField.text
        {
            weatherManger.fetchWeatherData(cityName: city)
        }
        Searchfiled.text = ""
    }
}

//MARK:- WeatherMangerDelegate

extension WeatherViewController : WeatherMangerDelegate
{
    func didUpdateWeather(_ weatherManger : WeatherManager, weather : WeatherModel)
    {
        DispatchQueue.main.async
        {
            self.temperatureLabel.text = weather.tempStr
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
}


extension WeatherViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.last
        {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManger.fetchWeatherData(latitude: lat ,longtitude: lon)
          
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
       print(error)
    }
}
