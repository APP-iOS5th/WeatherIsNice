
struct TemperatureInfo {
    let date: String
    let minTemp: Double
    let maxTemp: Double
    var iconCode: String
}




struct ForecastViewModel {
    var shortday: String
    var temp_min: Double
    var temp_max: Double
    var iconCode: String
}



func calculateTemperatureInfoPerDay(from forecasts: [ForecastViewModel]) -> [TemperatureInfo] {
    var temperatureInfoPerDay: [TemperatureInfo] = []
    var tempInfoDict: [String: TemperatureInfo] = [:]
    
    // 각 요일별로 아이콘 코드를 그룹화
    var iconCodeCountDict: [String: [String: Int]] = [:]
    for forecast in forecasts {
        let date = forecast.shortday
        if iconCodeCountDict[date] == nil {
            iconCodeCountDict[date] = [:]
        }
        if let count = iconCodeCountDict[date]?[forecast.iconCode] {
            iconCodeCountDict[date]?[forecast.iconCode] = count + 1
        } else {
            iconCodeCountDict[date]?[forecast.iconCode] = 1
        }
    }
    
    for forecast in forecasts {
        let date = forecast.shortday
        if let existingTempInfo = tempInfoDict[date] {
            let minTemp = min(existingTempInfo.minTemp, forecast.temp_min)
            let maxTemp = max(existingTempInfo.maxTemp, forecast.temp_max)
            
            // 가장 많이 등장한 아이콘 코드를 찾음 // 근데 gpt 코드라 이해 안됨... somebody help me
            let mostFrequentIconCode = iconCodeCountDict[date]?.max { $0.value < $1.value }?.key ?? forecasts[0].iconCode
            
            let updatedTempInfo = TemperatureInfo(date: date, minTemp: minTemp, maxTemp: maxTemp, iconCode: mostFrequentIconCode)
            tempInfoDict[date] = updatedTempInfo
        } else {
            let mostFrequentIconCode = iconCodeCountDict[date]?.max { $0.value < $1.value }?.key ?? forecasts[0].iconCode
            let tempInfo = TemperatureInfo(date: date, minTemp: forecast.temp_min, maxTemp: forecast.temp_max, iconCode: mostFrequentIconCode)
            tempInfoDict[date] = tempInfo
        }
    }
    
    // Convert dictionary to array
    temperatureInfoPerDay = Array(tempInfoDict.values)
    
    // Sort by date if needed
    temperatureInfoPerDay.sort { $0.date < $1.date }
    
    return temperatureInfoPerDay
}

var weatherDummydata: [ForecastViewModel] = [
ForecastViewModel(shortday: "Mon", temp_min: 10, temp_max: 20, iconCode: "비옴"),
ForecastViewModel(shortday: "Mon", temp_min: 9, temp_max: 19, iconCode: "흐림"),
ForecastViewModel(shortday: "Mon", temp_min: 11, temp_max: 24, iconCode: "비옴"),
ForecastViewModel(shortday: "Mon", temp_min: 11, temp_max: 24, iconCode: "흐림"),
ForecastViewModel(shortday: "Mon", temp_min: 11, temp_max: 24, iconCode: "맑음"),
ForecastViewModel(shortday: "Mon", temp_min: 11, temp_max: 24, iconCode: "흐림"),

ForecastViewModel(shortday: "Tue", temp_min: 10, temp_max: 20, iconCode: "비옴"),
ForecastViewModel(shortday: "Tue", temp_min: 11, temp_max: 24, iconCode: "맑음"),
ForecastViewModel(shortday: "Tue", temp_min: 11, temp_max: 24, iconCode: "비옴"),

ForecastViewModel(shortday: "Wed", temp_min: 11, temp_max: 24, iconCode: "맑음"),
ForecastViewModel(shortday: "Wed", temp_min: 11, temp_max: 24, iconCode: "흐림"),
ForecastViewModel(shortday: "Wed", temp_min: 11, temp_max: 24, iconCode: "비옴")
]

print(calculateTemperatureInfoPerDay(from: weatherDummydata))
