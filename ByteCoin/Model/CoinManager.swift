

import Foundation

protocol CoinManagerDelegate {
    
    func didFailWithError(error: Error)
    
    func didUpdatePrice (price:String, currency:String)
}


struct CoinManager {
    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "2C27F9AB-CEA7-4BE9-B781-F18F9C6B330B"
   
    func getCoinPrice (for currency: String) {
        let stringURL = String("\(baseURL)\(currency)/USD?apikey=\(apiKey)")
        if let url = URL(string: stringURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
           
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                  print(error!)
                    return
                }
                if let safeData = data{
                    if let bitcoinPrice = self.parseJSON(coinData: safeData){
                    let priceString = String(format: "%.2f", bitcoinPrice)
                    
                    self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume ()
        }
        
    }
    func parseJSON(coinData: Data)-> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decodedData.rate
            
            print(lastPrice)
            return lastPrice
            
        } catch {print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
   
    
}

