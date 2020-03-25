using Toybox.Graphics as Gfx;
using Toybox.WatchUi;
using Toybox.System;

class TopContent extends WatchUi.Drawable {
	private var font4;
	private var font5;
	var bluetoothUi;
	var batteryUi;
	var notificationUi;
	var alarmUi;

	function initialize(options) {
		Drawable.initialize(options);
		var width = System.getDeviceSettings().screenWidth;
		var height = System.getDeviceSettings().screenHeight;
		var margin = (width - 195)/2;
		var y = options.get(:y);
		if(y == null) {
			y = (height/6)+8;
		}
		var batteryX = options.get(:batteryX);
		if(batteryX == null) {
			batteryX= 27;
		}
		var blueToothX = options.get(:blueToothX);
		if(blueToothX == null) {
			blueToothX = 62;
		}
		var notificationX = options.get(:notificationX);
		if(notificationX == null) {
			notificationX = 84;
		}
		var alarmX = options.get(:alarmX);
		if(alarmX == null) {
			alarmX = 110;
		}
		var alarmY = options.get(:alarmY);
		if(alarmY == null) {
			alarmY = y;
		}
		font4 = WatchUi.loadResource(Rez.Fonts.id_font_cas10);
		font5 = WatchUi.loadResource(Rez.Fonts.id_font_cas10_2);
		var bluetoothIconBlack = WatchUi.loadResource(Rez.Drawables.bluetooth_icon_black);
		var bluetoothIconGrey = WatchUi.loadResource(Rez.Drawables.bluetooth_icon_grey);
		bluetoothUi = new BluetoothUi(blueToothX,y,bluetoothIconBlack,bluetoothIconGrey);
		batteryUi = new BatteryUi(batteryX,y,27,17);
		var notificationIconBlack = WatchUi.loadResource(Rez.Drawables.notification_icon_black);
		var notificationIconGrey = WatchUi.loadResource(Rez.Drawables.notification_icon_grey);
		notificationUi = new NotificationUi(notificationX,y+1,notificationIconBlack,notificationIconGrey);
		var alarmIconBlack = WatchUi.loadResource(Rez.Drawables.silent_icon_black);
		var alarmIconGrey = WatchUi.loadResource(Rez.Drawables.silent_icon_grey);
		alarmUi = new AlarmUi(alarmX, alarmY ,alarmIconBlack, alarmIconGrey);
	}
	
	function draw(dc) {
		batteryUi.draw(dc);
		bluetoothUi.draw(dc);
		notificationUi.draw(dc);
		alarmUi.draw(dc);
	}
}