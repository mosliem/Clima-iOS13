import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    var weatherManger = WeatherManager()
    let locationManager = CLLocationManager()
override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
     
        searchTextField.delegate = self
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
      searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManger.fetchWeatherData(cityName: city)
        }
        
        searchTextField.text = ""
        
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
