

// Constants used throughout the app
const String ipAddress = '192.168.1.3:8080'; //local address
//const String ipAddress = '193.134.218.31:8080'; //VM address


const String uriPrefix = 'http://$ipAddress';

// Regex patterns used for INPUT VALIDATION
const intRegexPattern = r'^[0-9]{0,10}$';
const doubleRegexPattern = r'^[0-9]{0,10}(\.[0-9]{0,2})?$';
const nameRegexPattern = r"^[0-9A-Za-zÀ-ÖØ-öø-ÿ '/-]{0,50}$";
const streetAndCityRegexPattern = r"^[A-Za-zÀ-ÖØ-öø-ÿ '/-]{0,50}$";
const descriptionRegexPattern = r"^[0-9A-Za-zÀ-ÖØ-öø-ÿ ',.!?-]{0,255}$";
