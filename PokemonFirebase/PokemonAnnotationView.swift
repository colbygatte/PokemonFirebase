import UIKit
import MapKit

class PokemonAnnotationView: MKAnnotationView {
    
    var annotationImage: UIImage!
    var annotationImageView: UIImageView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        annotationImage = UIImage()
        annotationImageView = UIImageView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImageToView() {
        self.annotationImageView.image = self.annotationImage
        self.annotationImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.addSubview(annotationImageView)
    }
    
}


class PokemonPointAnnotation: MKPointAnnotation {
    var pokemon: Pokemon!
}
