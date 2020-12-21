using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.Background as Bg;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time;

(:background)
class DigitalWatchApp extends App.AppBase {

	var mView;

	function initialize() {
		getSettings();
		AppBase.initialize();
	}

	// onStart() is called on application start up
	function onStart(state) {
	}

	// onStop() is called when your application is exiting
	function onStop(state) {
	}

	// Return the initial view of your application here
	function getInitialView() {
		mView = new DigitalWatchView();
		return [ mView ];
	} 

	(:background_method)
	function getServiceDelegate() {
		return [new BackgroundService()];
	}

	(:background_method)
    function onBackgroundData(data) {
    	if (data != null) { 
	    	weatherTemp = data["temp"];
	    	weatherIcon = data["icon"];
	    	setProperty("weatherTemp", weatherTemp);
	    	setProperty("weatherIcon", weatherIcon);
	    	setProperty("weatherLastTime", Time.now().value());
		}
		//Sys.println("Background data");
    }

	function onSettingsChanged() {
		getSettings();
		Ui.requestUpdate();
	}
	
	function startBackgroundService() {
		//Sys.println("Starting background");
		if (!showWeather) {
			return;
		}

		//if (!(Sys has :ServiceDelegate)) {
		//	return;
		//}
		
		var registeredTime = Background.getTemporalEventRegisteredTime();
		if (registeredTime != null){
			return;
		}

		//Sys.println("Starting background");
		
	    if (locationLat == 1000) {
	    	//Sys.println("no position");
	    	return;
	    }
	    
		var lastTime = Background.getLastTemporalEventTime();
		var duration = new Time.Duration(600);
		var now = Time.now();
		if (lastTime == null){
			//////////////////////////////////////////////////////////
			//DEBUG
			//System.println("reg ev now 1");
			//////////////////////////////////////////////////////////
			Background.registerForTemporalEvent(now);
		}else{
			if (now.greaterThan(lastTime.add(duration))){
				//////////////////////////////////////////////////////////
				//DEBUG
				//System.println("reg ev now 2");
				//////////////////////////////////////////////////////////
				Background.registerForTemporalEvent(now);
			}else{
			    var nextTime = lastTime.add(duration);
				//////////////////////////////////////////////////////////
				//DEBUG
			    //System.println("reg ev "+nextTime.value());
				//////////////////////////////////////////////////////////
			    Background.registerForTemporalEvent(nextTime);
			}
		}
	}

	function getSettings() {
		var sm = 0;
		var theme = 0;
		var weekdayLang = 0;
		gp = getProperty("powerMode");
		powerDNDMode = getProperty("powerDNDMode");
		sm = getProperty("secMode");
		secSize = getProperty("secSize");
		timeCenter = getProperty("alignCenter");
		dateFormat = getProperty("dateFormat");
		weekdayLang = getProperty("weekdayLang");
		timeFormat = getProperty("timeFormat");
		secondTime = getProperty("secondTime");
		batteryFormat = getProperty("batteryFormat");
		leadingZero = getProperty("leadingZero");
		dataFieldsType [1] = getProperty("dfMode1");
		dataFieldsType [2] = getProperty("dfMode2");
		dataFieldsType [3] = getProperty("dfMode3");
		dataFieldsType [0] = getProperty("dfMode0");
		dataFieldsType [4] = getProperty("dfMode4");

		showBattery = getProperty("showBattery");
		showBluetooth = getProperty("showBluetooth");
		showMessages = getProperty("showMessages");
		showAlarms = getProperty("showAlarms");
		showDND = getProperty("showDND");
		locationLat = getProperty("locationLat");
		locationLon = getProperty("locationLon");
		weatherOwmKey = getProperty("weatherOwmKey");
		tempFormat = getProperty("tempFormat");
			
		theme = getProperty("theme");
		if (theme != 0) {
			setTheme(theme);
			setProperty("colorBackground", colorBackground);
			setProperty("colorBackgroundBanner", colorBackgroundBanner);
			setProperty("colorTime", colorTime);
			setProperty("colorData", colorData);
			setProperty("colorLine", colorLine);
			setProperty("colorInactive", colorInactive);
			setProperty("colorDnd", colorDnd);
			setProperty("colorBattery", colorBattery);
			setProperty("colorStrings", colorStrings);
			setProperty("colorBigStrings", colorBigStrings);
			setProperty("splitHeight", splitHeight);
			setProperty("theme", 0);
		} else {
			colorBackground = getProperty("colorBackground");
			colorBackgroundBanner = getProperty("colorBackgroundBanner");
			colorTime = getProperty("colorTime");
			colorData = getProperty("colorData");
			colorLine = getProperty("colorLine");
			colorInactive = getProperty("colorInactive");
			colorDnd = getProperty("colorDnd");
			colorBattery = getProperty("colorBattery");
			colorStrings = getProperty("colorStrings");
			colorBigStrings = getProperty("colorBigStrings");
			splitHeight = getProperty("splitHeight");
		}
		if (sm == 0) {
			secHidden = '-';
		} else if (sm == 1) {
			secHidden = null;
		} else {
			secHidden = '8';
		}
		// day of week
		if (weekdayLang == 1) {
			day_of_week_array = ["dim", "lun", "mar", "mer", "jeu", "ven", "sam"];
		} else if (weekdayLang == 2) {
			day_of_week_array = ["vas", "het", "ked", "sze", "csu", "pen", "szo"];
		} else if (weekdayLang == 3) {
			day_of_week_array = ["son", "mon", "die", "mit", "don", "fre", "sam"];
		} else if (weekdayLang == 4) {
			day_of_week_array = ["dom", "lun", "mar", "mie", "jue", "vie", "sab"];
		} else if (weekdayLang == 5) {
			day_of_week_array = ["dom", "seg", "ter", "qua", "qui", "sex", "sab"];
		} else if (weekdayLang == 6) {
			day_of_week_array = ["nie", "pon", "wto", "sro", "czw", "pia", "sob"];
		} else if (weekdayLang == 7) {
			day_of_week_array = ["ned", "pon", "ute", "str", "ctv", "pat", "sob"];
		} else if (weekdayLang == 8) {
			day_of_week_array = ["ned", "pon", "uto", "str", "stv", "pia", "sob"];
		} else if (weekdayLang == 9) {
			day_of_week_array = ["ned", "pon", "uto", "sri", "cet", "pet", "sub"];
		} else if (weekdayLang == 10) {
			day_of_week_array = ["dum", "lun", "mar", "mie", "joi", "vin", "sam"];
		} else if (weekdayLang == 11) {
			day_of_week_array = ["dom", "lun", "mar", "mer", "gio", "ven", "sab"];
		} else if (weekdayLang == 12) {
			day_of_week_array = ["zon", "maa", "din", "woe", "don", "vri", "zat"];
		} else if (weekdayLang == 13) {
			day_of_week_array = ["son", "man", "tur", "ons", "tor", "fre", "lor"];
		} else {
			day_of_week_array = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
		}
		// weather
		showWeather = dataFieldsType[0]==DF_TEMP or
						dataFieldsType[1]==DF_TEMP or
						dataFieldsType[2]==DF_TEMP or
						dataFieldsType[3]==DF_TEMP or
						dataFieldsType[4]==DF_TEMP;
	}

	function setTheme(theme) {
		if (theme == 1) {
			colorBackground = Gfx.COLOR_WHITE;
			colorBackgroundBanner = Gfx.COLOR_BLACK;
			colorTime = Gfx.COLOR_BLACK;
			colorData = Gfx.COLOR_BLACK;
			colorLine = Gfx.COLOR_BLACK;
			colorInactive = Gfx.COLOR_WHITE;
			colorDnd = Gfx.COLOR_BLACK;
			colorBattery = Gfx.COLOR_BLACK;
			colorStrings = Gfx.COLOR_BLUE;
			colorBigStrings = Gfx.COLOR_WHITE;
			splitHeight = 2;
		} else if (theme == 2) {
			colorBackground = Gfx.COLOR_WHITE;
			colorBackgroundBanner = Gfx.COLOR_BLACK;
			colorTime = Gfx.COLOR_BLACK;
			colorData = Gfx.COLOR_BLACK;
			colorLine = Gfx.COLOR_BLUE;
			colorInactive = Gfx.COLOR_LT_GRAY;
			colorDnd = Gfx.COLOR_RED;
			colorBattery = Gfx.COLOR_BLUE;
			colorStrings = Gfx.COLOR_BLUE;
			colorBigStrings = Gfx.COLOR_WHITE;
			splitHeight = 8;
		} else if (theme == 3) {
			colorBackground = Gfx.COLOR_BLACK;
			colorBackgroundBanner = Gfx.COLOR_BLACK;
			colorTime = Gfx.COLOR_WHITE;
			colorData = Gfx.COLOR_WHITE;
			colorLine = Gfx.COLOR_WHITE;
			colorInactive = Gfx.COLOR_BLACK;
			colorDnd = Gfx.COLOR_WHITE;
			colorBattery = Gfx.COLOR_BLUE;
			colorStrings = Gfx.COLOR_BLUE;
			colorBigStrings = Gfx.COLOR_WHITE;
			splitHeight = 2;
		} else if (theme == 4) {
			colorBackground = Gfx.COLOR_WHITE;
			colorBackgroundBanner = Gfx.COLOR_BLACK;
			colorTime = Gfx.COLOR_BLACK;
			colorData = Gfx.COLOR_DK_BLUE;
			colorLine = Gfx.COLOR_ORANGE;
			colorInactive = Gfx.COLOR_WHITE;
			colorDnd = Gfx.COLOR_RED;
			colorBattery = Gfx.COLOR_GREEN;
			colorStrings = Gfx.COLOR_ORANGE;
			colorBigStrings = Gfx.COLOR_WHITE;
			splitHeight = 8;
		} else if (theme == 5) {
			colorBackground = Gfx.COLOR_ORANGE;
			colorBackgroundBanner = Gfx.COLOR_YELLOW;
			colorTime = Gfx.COLOR_BLACK;
			colorData = Gfx.COLOR_BLACK;
			colorLine = Gfx.COLOR_BLACK;
			colorInactive = Gfx.COLOR_YELLOW;
			colorDnd = Gfx.COLOR_RED;
			colorBattery = Gfx.COLOR_BLUE;
			colorStrings = Gfx.COLOR_RED;
			colorBigStrings = Gfx.COLOR_BLACK;
			splitHeight = 2;
		}
		
	}

	function getLocation() {
		var location = Activity.getActivityInfo().currentLocation;
		if (location != null) { 
			location = location.toDegrees();
			locationLat = location[0].toFloat();
			locationLon = location[1].toFloat();
			setProperty("locationLat", locationLat);
			setProperty("locationLon", locationLon);
		} else {
			locationLat = getProperty("locationLat");
			locationLon = getProperty("locationLon");
		}
		//Sys.println("Getlocation");
	}
}