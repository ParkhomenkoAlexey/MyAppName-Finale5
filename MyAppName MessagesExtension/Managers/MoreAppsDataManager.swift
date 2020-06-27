import UIKit

class MoreAppsService {
    
    let developerId = "1288067083"
    let lookupUrl = "https://itunes.apple.com/lookup?id=%@&entity=software"
    
    func getApps(completion: @escaping (Result<[UIImage], Error>) -> Void) {
        
//        MoreAppsDataManager.shared
        
        let urlStr = String(format: lookupUrl, developerId)
        let url = URL(string: urlStr)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                DispatchQueue.main.async {
                    print(data)
                    
                    do {
                        let model = try JSONDecoder().decode(MoreAppsModel.self, from: data)
                        model.results.forEach { (result) in
                            print(result.artworkUrl)
                        }
                        
                        completion(.success([]))
                    } catch {
                        completion(.failure(error))
                    }
                }
            } else {
                completion(.failure(error!))
            }
        
        }.resume()
    }
    
    
}

struct MoreAppsDataManager {

    static let shared = MoreAppsDataManager()

    let developerId = "1288067083"
    let lookupUrl = "https://itunes.apple.com/lookup?id=%@&entity=software"

    var dataSource = [[String: UIImage]]()

    init() {
        loadDeveloperAppsData()
    }

    private mutating func loadDeveloperAppsData() {
        let urlStr = String(format: lookupUrl, developerId)
        let url = URL(string: urlStr)!
        if let data = try? Data(contentsOf: url) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                
                print(json!)
                
                if let results = json?["results"] as? [[String: Any]]{
                    if results.count > 0 {
                        results.forEach { (result) in
                            print("result", result)
                            if let artworkUrlStr = result["artworkUrl100"] as? String, let artworkUrl = URL(string: artworkUrlStr), let idNumber = result["trackId"] as? Int{

                                if let imageData = try? Data(contentsOf: artworkUrl) {
                                    if let artworkImage = UIImage(data: imageData) {
                                        let item = [String(idNumber): artworkImage]
                                        self.dataSource.append(item)
                                    }
                                }
                            }
                        }
                    }
                }

            } catch {
                print("Error -> \(error)")
            }
        }
    }
}
