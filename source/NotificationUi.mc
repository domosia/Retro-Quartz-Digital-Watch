using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class NotificationUi {

	//private var width = 20;
	//private var height = 14;
	private var x;
	private var y;
	private var notificationIconBlack;
	private var notificationIconGrey;
	
	function initialize(x_,y_,notificationIconBlack_,notificationIconGrey_){
		x = x_;
		y = y_;
		notificationIconBlack = notificationIconBlack_;
		notificationIconGrey = notificationIconGrey_;
	}


	function draw(dc){
		dc.drawBitmap(x, y, notificationState() ? notificationIconBlack : notificationIconGrey);
	}
	
	private function notificationState(){
		var settings = Sys.getDeviceSettings();
		
		return settings.notificationCount !=0;
	}
}