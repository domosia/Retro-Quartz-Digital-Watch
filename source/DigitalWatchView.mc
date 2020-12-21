using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian as Calendar;
using Toybox.System as Sys;
using Toybox.Communications as Comms;

(:background)
class DigitalWatchView extends WatchUi.WatchFace {
	
	var layouts;

	function initialize() {   
		if (Sys has :ServiceDelegate) {
    		Application.getApp().startBackgroundService();
    	}
		WatchFace.initialize();
	}

	// Load your resources here
	function onLayout(dc) {
		layouts = Rez.Layouts.WatchFace(dc);
		setLayout(layouts);
	}

	//! Called when this View is brought to the foreground. Restore
	//! the state of this View and prepare it to be shown. This includes
	//! loading resources into memory.
	function onShow() {
		Application.getApp().getLocation();
	}

	//! Update the view
	function onUpdate(dc) {
		View.onUpdate(dc);
		if (Sys has :ServiceDelegate) {
    		Application.getApp().startBackgroundService();
    	}
	}
	
	function onPartialUpdate(dc){
	  //Sys.println("aaa");
		if (gp != 0 or gpDND) {
			return;
		}
		// show sec
			sleepMode = true;
			var clockTime = System.getClockTime();
			layouts[2].drawSeconds(dc, Lang.format("$1$", [clockTime.sec.format("%02d")]), true);
	}
	

	//! Called when this View is removed from the screen. Save the
	//! state of this View here. This includes freeing resources from
	//! memory.
	function onHide() {
	}

	//! The user has just looked at their watch. Timers and animations may be started here.
	function onExitSleep() {
		sleepMode = false;
		requestUpdate();
	}

	//! Terminate any active timers and prepare for slow updates.
	function onEnterSleep() {
		sleepMode = true;
		requestUpdate();
	}
	
}
