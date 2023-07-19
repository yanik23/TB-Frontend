
const String ipAddress = '192.168.1.3:8080';
const String uriPrefix = 'http://$ipAddress';


const numberRegexPattern = r'^[0-9]{0,10}$';
const nameRegexPattern = r"^[0-9A-Za-zÀ-ÖØ-öø-ÿ '/-]{0,50}$";
const streetAndCityRegexPattern = r"^[A-Za-zÀ-ÖØ-öø-ÿ '/-]{0,50}$";
const descriptionRegexPattern = r"^[0-9A-Za-zÀ-ÖØ-öø-ÿ ',.!?-]{0,255}$";
