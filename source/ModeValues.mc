const DF_NONE			= 0;
const DF_DATE			= 1;
const DF_WEEKDAYS		= 2;
const DF_STEPS			= 3;
const DF_HR				= 4;
const DF_CALORIES		= 5;
const DF_DISTANCE		= 6;
const DF_ALTITUDE		= 7;
const DF_YEAR			= 8;
const DF_TEMP			= 9;
const DF_DEFAULT		= 10;
const DF_SECONDTIME		= 11;
const DF_SUNSETSUNRISE	= 12;
const DF_FLOORS			= 13;

const weatherIconTable = {
	"01d" => 'V',
	"01n" => 'V',
	"02d" => 'Z',
	"02n" => 'Z',
	"03d" => ']',
	"03n" => ']',
	"04d" => '^',
	"04n" => '^',
	"09d" => 'Y',
	"09n" => 'Y',
	"10d" => '\\',
	"10n" => '\\',
	"11d" => 'X',
	"11n" => 'X',
	"13d" => 'W',
	"13n" => 'W',
	"50d" => '[',
	"50n" => '['	
};

// false: looking watch
// true: watch is sleeping
var sleepMode = false;
// 0: sec always on
// 1: sec off
// 2: sec olways off
var gp = 0;
var powerDNDMode = 0;
var gpDND = false;
// second type on sleep mode
var secHidden = null;
var secSize = 0;
// 0: mm-dd
// 1: dd-mm
var dateFormat = 0;
var day_of_week_array = new [7];
// 0: 24 h
// 1: 12 h
var timeFormat = 0;
// 0: normal
// 1: small number
// 2: big number
var batteryFormat = 0;
var timeCenter = 0;
var leadingZero = false;
var secondTime;

// Weather
var showWeather = false;
var weatherTemp = null;
var weatherIcon = null;
var weatherOwmKey = "";
var tempFormat = 0;
var locationLat = 1000;
var locationLon = 0;

var dataFieldsType = new [5];

var showBattery = true;
var showBluetooth = true;
var showMessages = true;
var showAlarms = true;
var showDND = true;

var colorBackground = 0;
var colorBackgroundBanner = 0;
var colorTime = 0;
var colorData = 0;
var colorLine = 0;
var colorInactive = 0;
var colorDnd = 0;
var colorBattery = 0;
var colorStrings = 0;
var colorBigStrings = 0;
var splitHeight = 8;

var banner;
var bannerTop;
var bannerBottom;
