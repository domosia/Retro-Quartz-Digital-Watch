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
		drawDataFields(dc, 6);
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
		if (fieldNr == 6) {
			// battery
			var iconString = "";
			var iconStringDND = "";
			var iconStringInactive = "";
			if (showBattery) {
				if (batteryFormat == 2) {
					iconString += "  ";
				} else {
					iconString += 'N';
				}
				iconStringDND += "  ";
				iconStringInactive += "  ";
			}
			if (showBluetooth) {
				if (getBluetooth()) {
					iconString += 'H';
					iconStringInactive += ' ';
				} else {
					iconString += ' ';
					iconStringInactive += 'H';
				}
				iconStringDND += ' ';
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
						iconStringDND += 'J';
					} else {
						iconStringInactive += 'J';
					}
				}
			}
			dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);
			dc.drawText(batteryX, batteryY, font3, iconString, Gfx.TEXT_JUSTIFY_LEFT);
			dc.setColor(colorDnd, Gfx.COLOR_TRANSPARENT);
			dc.drawText(batteryX, batteryY, font3, iconStringDND, Gfx.TEXT_JUSTIFY_LEFT);
			dc.setColor(colorInactive, Gfx.COLOR_TRANSPARENT);
			dc.drawText(batteryX, batteryY, font3, iconStringInactive, Gfx.TEXT_JUSTIFY_LEFT);

			if (showBattery) {
				iconString = getBattery();
				dc.setColor(colorBattery, Gfx.COLOR_TRANSPARENT);
				if (batteryFormat == 0) {
					dc.drawText(batteryX, batteryY, font3, iconString, Gfx.TEXT_JUSTIFY_LEFT);
				} else if (batteryFormat == 1) {
					dc.drawText(batteryX, batteryY, font4, " " + iconString, Gfx.TEXT_JUSTIFY_LEFT);
				} else {
					dc.drawText(batteryX, batteryY, font3, iconString, Gfx.TEXT_JUSTIFY_LEFT);
				}
			}
			dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);


		} else if (fieldNr == 0) {
			dc.setColor(colorBigStrings, Gfx.COLOR_TRANSPARENT);
			dc.drawText(bannerX, bannerTopY, font3, getDataFields(0), Gfx.TEXT_JUSTIFY_CENTER);
		} else if (fieldNr == 4) {
			dc.setColor(colorBigStrings, Gfx.COLOR_TRANSPARENT);
			dc.drawText(bannerX, bannerBottomY, font3, getDataFields(4), Gfx.TEXT_JUSTIFY_CENTER);
		} else if (fieldNr == 1) {
			dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);
			dc.drawText(dayX, dayY, font3, getDataFields(1), Gfx.TEXT_JUSTIFY_RIGHT);
		} else if (fieldNr == 2) {
			dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);
			dc.drawText(stepX, stepY, font3, getDataFields(2), Gfx.TEXT_JUSTIFY_LEFT);
		} else {
			dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);
			dc.drawText(dateX, dateY, font3, getDataFields(3), Gfx.TEXT_JUSTIFY_RIGHT);
		}
	}

	private function getDataFields(fieldNr) {
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
				} else {
					result = Lang.format("$1$", [info.day.format("%02d")]) + "-" + Lang.format("$1$", [info.month.format("%02d")]);
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
				result = Lang.format("$1$", [ActivityMonitor.getInfo().distance]);
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
			case DF_TEMP: {
				result = App.getApp().getProperty("weatherTemp");
				var result2 = App.getApp().getProperty("weatherIcon");
				if (result.toString().length() > 4) {
					result = null;
				}
				if (result2.toString().length() > 4) {
					result2 = null;
				}
				//Sys.println(result);
/*
				if (result != null) {
					if (tempFormat == 1) {
						result = ((result.toFloat() * (9.0 / 5)) + 32).format("%0d") + "U";
					} else {
						result = result + "T";
					}
				}
*/
				if (result != null) {
					if (tempFormat == 1) {
						result = ((result.toFloat() * (9.0 / 5)) + 32).format("%0d");
					}
					if (result2 != null) {
						result = weatherIconTable[result2] + result;
					}
				}
				break;
			}
			case DF_SECONDTIME: {
				var offset = secondTime*60 - System.getClockTime().timeZoneOffset;
				var dur = new Time.Duration(offset);
				var clockTime = Calendar.info(Time.now().add(dur), Time.FORMAT_SHORT);
				result = clockTime.hour + ":" + Lang.format("$1$", [ clockTime.min.format("%02d")]);



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
		return result;
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

}