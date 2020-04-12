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
	private var height = System.getDeviceSettings().screenHeight;
	private var width = System.getDeviceSettings().screenWidth;
	var dayX = width-30;
	var dayY = (height/6+2);
	var dateY = 4*(height/6)+6;
	var dateX = width-30;
	var stepX = 30;
	var stepY;
	var batteryX = 30;
	var batteryY;
	var batteryPaddingX = 0;
	function initialize(options) {
		Drawable.initialize(options);
		font3 = WatchUi.loadResource(Rez.Fonts.id_font_digital_date);
		var batteryPaddingX_ = options.get(:batteryPaddingX);
		if (batteryPaddingX_ != null) {
			batteryPaddingX = batteryPaddingX_;
		}
		var stepX_ = options.get(:stepX);
		if (stepX_ != null) {
			stepX = stepX_;
		}
		var stepY_ = options.get(:stepY);
		if (stepY_ != null) {
			stepY = stepY_;
		}
		var dateY_ = options.get(:dateY);
		if (dateY_ != null) {
			dateY = dateY_;
		}
		var dateX_ = options.get(:dateX);
		if (dateX_ != null) {
			dateX = dateX_;
		}
		var dayY_ = options.get(:dayY);
		if (dayY_ != null) {
			dayY = dayY_;
		}
		var dayX_ = options.get(:dayX);
		if (dayX_ != null) {
			dayX = dayX_;
		}
		stepY = dateY;
		batteryY = dayY;
	}
	
	function draw(dc) {
		drawDataFields(dc, 0);
		drawDataFields(dc, 1);
		drawDataFields(dc, 2);
		drawDataFields(dc, 3);
	}
	
	private function drawDataFields(dc, fieldNr) {
		//Draw Data
		
		dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);
		if (fieldNr == 0) {
			// battery
			dc.drawText(batteryX, batteryY, font3, "G", Gfx.TEXT_JUSTIFY_LEFT);
			var batteryMeter = getBattery();
			if (batteryMeter < 'F') {
				dc.setColor(colorBattery, Gfx.COLOR_TRANSPARENT);
			} else {
				dc.setColor(colorDnd, Gfx.COLOR_TRANSPARENT);
			}
			dc.drawText(batteryX, batteryY, font3, batteryMeter, Gfx.TEXT_JUSTIFY_LEFT);
			dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);
			// Bluetooth
			if (getBluetooth()) {
				dc.drawText(batteryX + 32 - batteryPaddingX, batteryY, font3, "H", Gfx.TEXT_JUSTIFY_LEFT);
			} else {
				dc.setColor(colorInactive, Gfx.COLOR_TRANSPARENT);
				dc.drawText(batteryX + 32 - batteryPaddingX, batteryY, font3, "H", Gfx.TEXT_JUSTIFY_LEFT);
				dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);
			}
			// Notification
			if (getNotification()) {
				dc.drawText(batteryX + 45 - batteryPaddingX * 2, batteryY, font3, "I", Gfx.TEXT_JUSTIFY_LEFT);
			} else {
				dc.setColor(colorInactive, Gfx.COLOR_TRANSPARENT);
				dc.drawText(batteryX + 45 - batteryPaddingX * 2, batteryY, font3, "I", Gfx.TEXT_JUSTIFY_LEFT);
				dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);
			}
			// Do Not Disturb
			if (Sys.getDeviceSettings() has :doNotDisturb) {
				if (getDND()) {
					dc.setColor(colorDnd, Gfx.COLOR_TRANSPARENT);
					dc.drawText(batteryX + 64 - batteryPaddingX * 3, batteryY, font3, "J", Gfx.TEXT_JUSTIFY_LEFT);
					dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);
				} else {
					dc.setColor(colorInactive, Gfx.COLOR_TRANSPARENT);
					dc.drawText(batteryX + 64 - batteryPaddingX * 3, batteryY, font3, "J", Gfx.TEXT_JUSTIFY_LEFT);
					dc.setColor(colorData, Gfx.COLOR_TRANSPARENT);
				}
			}
		} else if (fieldNr == 1) {
			dc.drawText(dayX, dayY, font3, getDataFields(1), Gfx.TEXT_JUSTIFY_RIGHT);
		} else if (fieldNr == 2) {
			dc.drawText(stepX, stepY, font3, getDataFields(2), Gfx.TEXT_JUSTIFY_LEFT);
		} else {
			dc.drawText(dateX, dateY, font3, getDataFields(3), Gfx.TEXT_JUSTIFY_RIGHT);
		}
	}

	private function getDataFields(fieldNr) {
		var result = null;
		switch ( dataFieldsType[fieldNr] ) {
			case DF_DATE: {
				var info = Calendar.info(Time.now(), Time.FORMAT_SHORT);
				if (dateFormat == 0) {
					result = Lang.format("$1$", [info.month]) + "-" + Lang.format("$1$", [info.day.format("%02d")]);
				} else {
					result = Lang.format("$1$", [info.day.format("%02d")]) + "-" + Lang.format("$1$", [info.month.format("%02d")]);
				}
				
				break;
			}
			case DF_WEEKDAYS: {
				var dayWeekStr = day_of_week_array[Calendar.info(Time.now(), Time.FORMAT_SHORT).day_of_week - 1];
				result = dayWeekStr;
				break;
			}
			case DF_STEPS: {
				result = Lang.format("$1$", [ActivityMonitor.getInfo().steps]);
				//result = 22345;
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
		}
		if (result == null) {
			result ="-";
		}
		result = result.toString();
		if (result.length() > 9) {
			result = result.substring(0, 4) + "-";
		} else if (result.length() > 7) {
			result = result.substring(0,result.length() - 6) + "M";
		} else if (result.length() > 5) {
			result = result.substring(0,result.length() - 3) + "K";
		}
		return result;
	}

	function getBattery() {
		var battery = Sys.getSystemStats().battery;
		var result;
		if (battery > 83) {
			result = 'A';
		} else if (battery > 66) {
			result = 'B'; 
		} else if (battery > 50) {
			result = 'C'; 
		} else if (battery > 33) {
			result = 'D'; 
		} else if (battery > 16) {
			result = 'E'; 
		} else {
			result = 'F';
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
}