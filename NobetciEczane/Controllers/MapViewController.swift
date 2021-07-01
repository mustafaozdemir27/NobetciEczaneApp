import UIKit
import MapKit
class MapViewController: UIViewController {

    private let locationManager = CLLocationManager()
    private var currentCoordinate : CLLocationCoordinate2D?
    
    private var destinations: [MKPointAnnotation] = []
    private var currentRoute: MKRoute?
    var pharmacyLocation = String()
    var pharmacyName = String()
    

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        configureLocationServices()
        self.title = "Title"


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(pharmacyLocation)
    }
     
    
    private func configureLocationServices() {
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if  status == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }
        else if status == .authorizedAlways || status == .authorizedWhenInUse{
                beginLocationUpdates(locationManager: locationManager)
        }
          
    }
    

    
    private func beginLocationUpdates(locationManager: CLLocationManager){
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    
    private func zoomToLatestLocation(with coordinate : CLLocationCoordinate2D) {
        
        let zoomRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(zoomRegion, animated: true)
    
}

    private func addAnnotations() {
        
        let pharmacyAnnotation = MKPointAnnotation()
        let lat = CLLocationDegrees(pharmacyLocation.stringBefore(","))
        let long = CLLocationDegrees(pharmacyLocation.stringAfter(","))
        pharmacyAnnotation.title = pharmacyName + " ECZANESİ"
        pharmacyAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat ?? 0.0 , longitude: long ?? 0.0 )
    
        
        destinations.append(pharmacyAnnotation)
         
        
        mapView.addAnnotation(pharmacyAnnotation)

    }
    
    private func constructRoute(userLocation: CLLocationCoordinate2D){
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate:  userLocation))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate:  destinations[0].coordinate))
        directionsRequest.requestsAlternateRoutes = true
        directionsRequest.transportType = .automobile
        
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate { [weak self] (directionsResponse,error) in
            guard let strongSelf = self else {return}
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            else if  let response = directionsResponse, response.routes.count > 0 {

                strongSelf.currentRoute = response.routes[0]
                
                strongSelf.mapView.addOverlay(response.routes[0].polyline)
                strongSelf.mapView.setVisibleMapRect(response.routes[0].polyline.boundingMapRect, animated: true)
                
            }
        }
    }
}

    extension MapViewController : CLLocationManagerDelegate {
        
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            guard let latestLocation = locations.first else { return }
        
            if currentCoordinate == nil{
                zoomToLatestLocation(with: latestLocation.coordinate)
                addAnnotations()
                constructRoute(userLocation: latestLocation.coordinate )
            }
            
            currentCoordinate = latestLocation.coordinate
        
        }
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
              
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                beginLocationUpdates(locationManager: manager)
            }
        }
    }
    
extension MapViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        guard let currentRoute = currentRoute else {
            return MKOverlayRenderer()
        }
        
        let polyLineRenderer = MKPolylineRenderer(polyline: currentRoute.polyline)
        polyLineRenderer.strokeColor = UIColor.blue
        polyLineRenderer.lineWidth = 5
        
        return polyLineRenderer
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if annotation.title == pharmacyName + " ECZANESİ" {
            annotationView?.image = UIImage(named: "pharmacy")
        }
        
        else if annotation === mapView.userLocation{
            annotationView?.image = UIImage(named: "car")
        }
        
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    }
}

extension String {
    func stringBefore(_ delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            return String(prefix(upTo: index))
        } else {
            return ""
        }
    }
    
    func stringAfter(_ delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            return String(suffix(from: index).dropFirst())
        } else {
            return ""
        }
    }
}
