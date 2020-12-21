//
// Copyright 2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Background as Bg;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Communications as Comms;


// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system. This indicates a set timer has expired, and
// we should attempt to notify the user.
(:background)
class BackgroundService extends Sys.ServiceDelegate {
    function initialize() {
        ServiceDelegate.initialize();
    }

    // If our timer expires, it means the application timer ran out,
    // and the main application is not open. Prompt the user to let them
    // know the timer expired.
    function onTemporalEvent() {
    	if (weatherOwmKey.length() > 0 and locationLat != 0) {
			makeWebRequest(
				"https://api.openweathermap.org/data/2.5/weather",
				{
					"lat" => locationLat,
					"lon" => locationLon,
					"appid" => weatherOwmKey,
					//"appid" => "",
					"units" => "metric" // Celcius.
				},
				method(:onReceiveOpenWeatherMapCurrent)
			);
		} else {
			Bg.exit(null);
		}
    }

	(:background_method)
	function onReceiveOpenWeatherMapCurrent(responseCode, data) {
		var result = null;
		
		if (responseCode == 200) {
			result = { "temp" => data["main"]["temp"].format("%0d"),
					   "icon" => data["weather"][0]["icon"] };
			//result = { "temp" => data["main"]["temp"].format("%0d"),
			//		   "icon" => "01n" };
		}
		Bg.exit(result);
	}
	(:background_method)
	function makeWebRequest(url, params, callback) {
		var options = {
			:method => Comms.HTTP_REQUEST_METHOD_GET,
			:headers => {
					"Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
			:responseType => Comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
		};

		Comms.makeWebRequest(url, params, options, callback);
		//Sys.println("onTemporalEvent");
	}

}
