using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi;
using Toybox.System as Sys;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor;
using Toybox.SensorHistory;
using Toybox.Math;
using Toybox.Lang;

class DateDrawable extends WatchUi.Drawable {
	var font3;
	var font4;
	private var height = System.getDeviceSettings().screenHeight;
	private var width = System.getDeviceSettings().screenWidth;

	var dayX;
	var dayY;
	var dateY;
	var dateX;
	var stepX;
	var stepY;
	var batteryX;
	var batteryY;
	var bannerX;
	var bannerTopY;
	var bannerBottomY;

	function initialize(options) {
		Drawable.initialize(options);
		font3 = WatchUi.loadResource(Rez.Fonts.id_font_digital_date);
		font4 = WatchUi.loadResource(Rez.Fonts.id_font_digital_date_bat);
		
		var marginX = options.get(:marginX);
		dayX = width-marginX;
		dayY = (height/6+2);
		dayY = options.get(:topY);
		dateY = options.get(:bottomY);
		dateX = width-marginX;
		stepX = marginX;
		batteryX = marginX;
		stepY = dateY;
		batteryY = dayY;
		bannerX = width / 2;
		bannerTopY = options.get(:bannerTopY);
		bannerBottomY = options.get(:bannerBottomY);
	}
	
	function draw(dc) {
		// batterys
		drawDataFields(dc, 5);
		// fields
		drawDataFields(dc, 1);
		drawDataFields(dc, 2);
		drawDataFields(dc, 3);
		// banner fields
		if (bannerTop) {
			drawDataFields(dc, 0);
		}
		if (bannerBottom) {
			drawDataFields(dc, 4);
		}
	}
	
	private function drawDataFields(dc, fieldNr) {
		//Draw Data
		if (fieldNr == 5) {
			getDataFields(dc, 5, batteryX, batteryY, Gfx.TEXT_JUSTIFY_LEFT, colorData);
			//dc.drawText(batteryX, batteryY, font3, getDataFields(dc,5), Gfx.TEXT_JUSTIFY_LEFT);
		} else if (fieldNr == 0) {
			getDataFields(dc, 0, bannerX, bannerTopY, Gfx.TEXT_JUSTIFY_CENTER, colorBigStrings);
			//dc.drawText(bannerX, bannerTopY, font3, getDataFields(dc,0), Gfx.TEXT_JUSTIFY_CENTER);
		} else if (fieldNr == 4) {
			getDataFields(dc, 4, bannerX, bannerBottomY, Gfx.TEXT_JUSTIFY_CENTER, colorBigStrings);
			//dc.drawText(bannerX, bannerBottomY, font3, getDataFields(dc,4), Gfx.TEXT_JUSTIFY_CENTER);
		} else if (fieldNr == 1) {
			getDataFields(dc, 1, dayX, dayY, Gfx.TEXT_JUSTIFY_RIGHT, colorData);
			//dc.drawText(dayX, dayY, font3, getDataFields(dc,1), Gfx.TEXT_JUSTIFY_RIGHT);
		} else if (fieldNr == 2) {
			getDataFields(dc, 2, stepX, stepY, Gfx.TEXT_JUSTIFY_LEFT, colorData);
			//dc.drawText(stepX, stepY, font3, getDataFields(dc,2), Gfx.TEXT_JUSTIFY_LEFT);
		} else {
			getDataFields(dc, 3, dateX, dateY, Gfx.TEXT_JUSTIFY_RIGHT, colorData);
			//dc.drawText(dateX, dateY, font3, getDataFields(dc,3), Gfx.TEXT_JUSTIFY_RIGHT);
		}
	}

	private function getDataFields(dc, fieldNr, XX, YY, textJustify, colorData) {
		var settings = Sys.getDeviceSettings();
		var result = null;
		switch ( dataFieldsType[fieldNr] ) {
			case DF_NONE: {
				result = "";
				break;
			}
			case DF_DATE: {
				var info = Calendar.info(Time.now(), Time.FORMAT_SHORT);
				if (dateFormat == 0) {
					result = Lang.format("$1$", [info.month]) + "-" + Lang.format("$1$", [info.day.format("%02d")]);
				} else if (dateFormat == 1) {
					result = Lang.format("$1$", [info.day.format("%02d")]) + "-" + Lang.format("$1$", [info.month.format("%02d")]);
				} else if (dateFormat == 2) {
					result = Lang.format("$1$", [info.day.format("%02d")]);
				} else {
					result = Lang.format("$1$", [info.month.format("%02d")]);
				}
				break;
			}
			case DF_YEAR: {
				var yearStr = Calendar.info(Time.now(), Time.FORMAT_SHORT).year;
				result = Lang.format("$1$", [yearStr]);
				break;
			}
			case DF_WEEKDAYS: {
				var dayWeekStr = day_of_week_array[Calendar.info(Time.now(), Time.FORMAT_SHORT).day_of_week - 1];
				result = dayWeekStr;
				break;
			}
			case DF_STEPS: {
				result = Lang.format("$1$", [ActivityMonitor.getInfo().steps]);
				//result = 2234550;
				break;
			}
			case DF_FLOORS: {
				var info = ActivityMonitor.getInfo();
				if (info has :floorsClimbed){
					result = info.floorsClimbed.toString();
				}
				break;
			}
			case DF_HR: {
				var sample = Activity.getActivityInfo().currentHeartRate;
				if (sample != null) {
					result = sample.format("%d");
				} else if (ActivityMonitor has :getHeartRateHistory) {
					sample = ActivityMonitor.getHeartRateHistory(1, /* newestFirst */ true)
						.next();
					if ((sample != null) && (sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE)) {
						result = sample.heartRate.format("%d");
					}
				}
				break;
			}
			case DF_CALORIES: {
				result = Lang.format("$1$", [ActivityMonitor.getInfo().calories]);
				break;
			}
			case DF_DISTANCE: {
				result = ActivityMonitor.getInfo().distance.toFloat() / 100000;
				if (settings.distanceUnits == System.UNIT_METRIC) {
					// km					
				} else {
					result *= /* MI_PER_KM */ 0.621371;
					// mi
				}

				//result = 554310.12345;				
				if (result < 10) {
					result = result.format("%.3f");
				} else if (result < 100) {
					result = result.format("%.2f");
				} else if (result < 1000) {
					result = result.format("%.1f");
				} else {
					result = result.format("%d");
				}

				break;
			}
			case DF_ALTITUDE: {
				var activityInfo = Activity.getActivityInfo();
				var altitude = activityInfo.altitude;
				var sample;
				if ((altitude == null) && (Toybox has :SensorHistory) && (Toybox.SensorHistory has :getElevationHistory)) {
					sample = SensorHistory.getElevationHistory({ :period => 1, :order => SensorHistory.ORDER_NEWEST_FIRST })
						.next();
					if ((sample != null) && (sample.data != null)) {
						altitude = sample.data;
					}
				}
				if (altitude != null) {

					// Metres (no conversion necessary).
					if (settings.elevationUnits == System.UNIT_METRIC) {

					// Feet.
					} else {
						altitude *= /* FT_PER_M */ 3.28084;
					}

					result = altitude.format("%d");
				}
				break;
			}
			case DF_MESSAGES: {
				result = Sys.getDeviceSettings().notificationCount;
				result = (!getBluetooth()) ? "--" : result.format("%02d");
				break;
			}
			case DF_TEMP: {
				result = App.getApp().getProperty("weatherTemp");
				var result2 = App.getApp().getProperty("weatherIcon");
				var LastTime = App.getApp().getProperty("weatherLastTime");
				var result3 = Time.now().value() - LastTime < 1800 ? null : ":"; //outdated the weather data?
				if (result.toString().length() > 4) {
					result = null;
				}
				if (result2.toString().length() > 4) {
					result2 = null;
				}
				//Sys.println(Time.now().value() - LastTime < 1800 ? "igen": "Nem");
				if (result != null) {
					if (tempFormat == 1) {
						result = ((result.toFloat() * (9.0 / 5)) + 32).format("%0d");
					}
					if (result3 == null) {
						if (result2 != null) {
							result = weatherIconTable[result2] + result;
						}
					}
				} else if (weatherOwmKey.toString().length() < 10) {
					result = "key";
				} else if (locationLat == 1000) {
					result = "gps";
				} else {
					result = "web";
				}
				break;
			}
			case DF_SECONDTIME: {
				var offset = (secondTime*60) * (secondTimeNegative ? -1 : 1) - System.getClockTime().timeZoneOffset;
				var dur = new Time.Duration(offset);
				var clockTime = Calendar.info(Time.now().add(dur), Time.FORMAT_SHORT);
				result = clockTime.hour + ":" + Lang.format("$1$", [ clockTime.min.format("%02d")]);
				break;
			}
			case DF_SUNSETSUNRISE: {
			    if (locationLat != 1000) {
					result = getSunsetSunrise();
				} else {
					result ="gps";
				}
				break;
			}
			case DF_ICONS: {
				// battery
				var iconString = "";
				var iconStringDND = "";
				var iconStringInactive = "";
				var iconStringBatterySpace = "";

				if (showBluetooth) {
					if (getBluetooth()) {
						iconString += 'H';
						iconStringInactive += ' ';
					} else {
						iconString += ' ';
						iconStringInactive += 'H';
					}
					iconStringDND += ' ';
					iconStringBatterySpace += ' ';
				}
				if (showMessages) {
					if (getNotification()) {
						iconString += 'I';
						iconStringInactive += ' ';
					} else {
						iconString += ' ';
						iconStringInactive += 'I';
					}
					iconStringDND += ' ';
					iconStringBatterySpace += ' ';
				}
				if (showAlarms) {
					if (getAlarms()) {
						iconString += 'K';
						iconStringInactive += ' ';
					} else {
						iconString += ' ';
						iconStringInactive += 'K';
					}
					iconStringDND += ' ';
					iconStringBatterySpace += ' ';
				}
				if (Sys.getDeviceSettings() has :doNotDisturb) {
					// check power safe DND
					if (powerDNDMode != 0) {
						gpDND = getDND(); 
					} else {
						gpDND = false;
					}
					if (showDND) {
						if (getDND()) {
							iconStringInactive += ' ';
							iconStringDND += 'J';
						} else {
							iconStringInactive += 'J';
							iconStringDND += ' ';
						}
						iconString += ' ';
						iconStringBatterySpace += ' ';
					}
				}
				if (showBattery) {
					if (batteryFormat == 2) {
						if (textJustify == Gfx.TEXT_JUSTIFY_RIGHT) {
							iconString += "  ";
						} else {
							iconString = "  " + iconString;
						}
					} else {
						if (textJustify == Gfx.TEXT_JUSTIFY_RIGHT) {
							iconString += 'N';
						} else {
							iconString = 'N' + iconString;
						}
					}
					if (textJustify == Gfx.TEXT_JUSTIFY_RIGHT) {
						iconStringDND += "  ";
						iconStringInactive += "  ";
					} else {
						iconStringDND = "  " + iconStringDND;
						iconStringInactive = "  " + iconStringInactive;
					}
				}

				dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);
				dc.drawText(XX, YY, font3, iconString, textJustify);
				dc.setColor(colorDnd, Gfx.COLOR_TRANSPARENT);
				dc.drawText(XX, YY, font3, iconStringDND, textJustify);
				dc.setColor(colorInactive, Gfx.COLOR_TRANSPARENT);
				dc.drawText(XX, YY, font3, iconStringInactive, textJustify);


				if (showBattery) {
					iconString = getBattery();
					dc.setColor(colorBattery, Gfx.COLOR_TRANSPARENT);
					if (textJustify == Gfx.TEXT_JUSTIFY_RIGHT) {
					} else {
						iconString += iconStringBatterySpace;
					} 
					if (batteryFormat == 0) {
						dc.drawText(XX, YY, font3, iconString, textJustify);
					} else if (batteryFormat == 1) {
						dc.drawText(XX, YY, font4, "." + iconString + ',', textJustify);
					} else {
						dc.drawText(XX, YY, font3, iconString, textJustify);
					}
				}

				dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);	
				result = "";
				break;
			}
			case DF_DEFAULT: {
				result = "";
				break;
			}
		}
		if (result == null) {
			result ="-";
		}
		result = result.toString();
		if (result.length() > 9) {
			result = result.substring(0, 4) + "-";
		} else if (result.length() > 7) {
			// xxx mega
			result = result.substring(0,result.length() - 6) + "M";
		} else if (result.length() > 5) {
			// xxx kilo
			result = result.substring(0,result.length() - 3) + "L";
		}

		dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);
		dc.drawText(XX, YY, font3, result, textJustify);
	}

	function getBattery() {
		var battery = Sys.getSystemStats().battery;
		var result;
		if (batteryFormat == 0) {
			if (battery > 82) {
				result = 'O';
			} else if (battery > 65) {
				result = 'P'; 
			} else if (battery > 49) {
				result = 'Q'; 
			} else if (battery > 32) {
				result = 'R'; 
			} else if (battery > 15) {
				result = 'S'; 
			} else {
				result = " ";
			}
		} else if (battery < 100) {
			result = Lang.format("$1$", [battery.format("%02d")]);
		} else {
			result = 99;
		}
		return result;
	}

	private function getBluetooth(){
		var settings = Sys.getDeviceSettings();
		var result = false;
		if (settings has : connectionInfo) {
			// Check the connection state v3.0.0
			var bluetoothState = settings.connectionInfo[:bluetooth].state ;

			if(bluetoothState == Sys.CONNECTION_STATE_CONNECTED){
				result = true;
			} else {
				result = false;
			}

		} else {
			if(settings.phoneConnected){
				result = true;
			}else{
				result = false;
			}
		}
		return result;
	}

	private function getNotification(){
		var settings = Sys.getDeviceSettings();
		
		return settings.notificationCount !=0;
	}

	private function getDND(){
		var settings = Sys.getDeviceSettings();
		return settings.doNotDisturb;
	}

	private function getAlarms(){
       	var settings = Sys.getDeviceSettings();
    	return settings.alarmCount > 0;
	}


	private function getSunsetSunrise(){
		var result = "-";
		if (locationLat != null) {
			var nextSunEvent = 0;
			var sunTimes;
			var now = Calendar.info(Time.now(), Time.FORMAT_SHORT);

			// Convert to same format as sunTimes, for easier comparison. Add a minute, so that e.g. if sun rises at
			// 07:38:17, then 07:38 is already consided daytime (seconds not shown to user).
			now = now.hour + ((now.min + 1) / 60.0);
			//Sys.println(now);

			// Get today's sunrise/sunset times in current time zone.
			sunTimes = getSunTimes(locationLat, locationLon, null, /* tomorrow */ false);
			//Sys.println(sunTimes);

			// If sunrise/sunset happens today.
			var sunriseSunsetToday = ((sunTimes[0] != null) && (sunTimes[1] != null));
			if (sunriseSunsetToday) {

				// Before sunrise today: today's sunrise is next.
				if (now < sunTimes[0]) {
					nextSunEvent = sunTimes[0];
					//result["isSunriseNext"] = true;
					//Sys.println("1");
				// After sunrise today, before sunset today: today's sunset is next.
				} else if (now < sunTimes[1]) {
					nextSunEvent = sunTimes[1];

				// After sunset today: tomorrow's sunrise (if any) is next.
				} else {
					sunTimes = getSunTimes(locationLat, locationLon, null, /* tomorrow */ true);
					nextSunEvent = sunTimes[0];
					//Sys.println("3");
					//result["isSunriseNext"] = true;
				}
				//Sys.println(sunTimes);
				var hour = Math.floor(nextSunEvent).toLong() % 24;
				var min = Math.floor((nextSunEvent - Math.floor(nextSunEvent)) * 60); // Math.floor(fractional_part * 60)
				//value = App.getApp().getFormattedTime(hour, min);
				result = hour + ":" + Lang.format("$1$", [ min.format("%02d")]);
				//Sys.println(result); 
			}

		}
		return result;
	}

	/**
	* With thanks to ruiokada. Adapted, then translated to Monkey C, from:
	* https://gist.github.com/ruiokada/b28076d4911820ddcbbc
	*
	* Calculates sunrise and sunset in local time given latitude, longitude, and tz.
	*
	* Equations taken from:
	* https://en.wikipedia.org/wiki/Julian_day#Converting_Julian_or_Gregorian_calendar_date_to_Julian_Day_Number
	* https://en.wikipedia.org/wiki/Sunrise_equation#Complete_calculation_on_Earth
	*
	* @method getSunTimes
	* @param {Float} lat Latitude of location (South is negative)
	* @param {Float} lng Longitude of location (West is negative)
	* @param {Integer || null} tz Timezone hour offset. e.g. Pacific/Los Angeles is -8 (Specify null for system timezone)
	* @param {Boolean} tomorrow Calculate tomorrow's sunrise and sunset, instead of today's.
	* @return {Array} Returns array of length 2 with sunrise and sunset as floats.
	*                 Returns array with [null, -1] if the sun never rises, and [-1, null] if the sun never sets.
	*/
	private function getSunTimes(lat, lng, tz, tomorrow) {

		// Use double precision where possible, as floating point errors can affect result by minutes.
		lat = lat.toDouble();
		lng = lng.toDouble();

		var now = Time.now();
		if (tomorrow) {
			now = now.add(new Time.Duration(24 * 60 * 60));
		}
		var d = Calendar.info(now, Time.FORMAT_SHORT);
		var rad = Math.PI / 180.0d;
		var deg = 180.0d / Math.PI;
		
		// Calculate Julian date from Gregorian.
		var a = Math.floor((14 - d.month) / 12);
		var y = d.year + 4800 - a;
		var m = d.month + (12 * a) - 3;
		var jDate = d.day
			+ Math.floor(((153 * m) + 2) / 5)
			+ (365 * y)
			+ Math.floor(y / 4)
			- Math.floor(y / 100)
			+ Math.floor(y / 400)
			- 32045;

		// Number of days since Jan 1st, 2000 12:00.
		var n = jDate - 2451545.0d + 0.0008d;
		//Sys.println("n " + n);

		// Mean solar noon.
		var jStar = n - (lng / 360.0d);
		//Sys.println("jStar " + jStar);

		// Solar mean anomaly.
		var M = 357.5291d + (0.98560028d * jStar);
		var MFloor = Math.floor(M);
		var MFrac = M - MFloor;
		M = MFloor.toLong() % 360;
		M += MFrac;
		//Sys.println("M " + M);

		// Equation of the centre.
		var C = 1.9148d * Math.sin(M * rad)
			+ 0.02d * Math.sin(2 * M * rad)
			+ 0.0003d * Math.sin(3 * M * rad);
		//Sys.println("C " + C);

		// Ecliptic longitude.
		var lambda = (M + C + 180 + 102.9372d);
		var lambdaFloor = Math.floor(lambda);
		var lambdaFrac = lambda - lambdaFloor;
		lambda = lambdaFloor.toLong() % 360;
		lambda += lambdaFrac;
		//Sys.println("lambda " + lambda);

		// Solar transit.
		var jTransit = 2451545.5d + jStar
			+ 0.0053d * Math.sin(M * rad)
			- 0.0069d * Math.sin(2 * lambda * rad);
		//Sys.println("jTransit " + jTransit);

		// Declination of the sun.
		var delta = Math.asin(Math.sin(lambda * rad) * Math.sin(23.44d * rad));
		//Sys.println("delta " + delta);

		// Hour angle.
		var cosOmega = (Math.sin(-0.83d * rad) - Math.sin(lat * rad) * Math.sin(delta))
			/ (Math.cos(lat * rad) * Math.cos(delta));
		//Sys.println("cosOmega " + cosOmega);

		// Sun never rises.
		if (cosOmega > 1) {
			return [null, -1];
		}
		
		// Sun never sets.
		if (cosOmega < -1) {
			return [-1, null];
		}
		
		// Calculate times from omega.
		var omega = Math.acos(cosOmega) * deg;
		var jSet = jTransit + (omega / 360.0);
		var jRise = jTransit - (omega / 360.0);
		var deltaJSet = jSet - jDate;
		var deltaJRise = jRise - jDate;

		var tzOffset = (tz == null) ? (Sys.getClockTime().timeZoneOffset / 3600) : tz;
		return [
			/* localRise */ (deltaJRise * 24) + tzOffset,
			/* localSet */ (deltaJSet * 24) + tzOffset
		];
	}
}
