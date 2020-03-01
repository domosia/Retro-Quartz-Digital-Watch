using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian as Calendar;
using Toybox.System;


class DigitalWatchView extends WatchUi.WatchFace {
	
	var layouts;

	function initialize() {   
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
	}

	//! Update the view
	function onUpdate(dc) {
			View.onUpdate(dc);
	}
	
	function drawTopGuiLine(dc){
		//Guide Lines
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
		dc.drawLine(0  , (dc.getHeight()/6) + 5  , dc.getWidth()    , (dc.getHeight()/6) + 5 );
		dc.drawLine(0  , (dc.getHeight()/6) + 27  , dc.getWidth()    , (dc.getHeight()/6) + 27 );
	}
	
	
	function onPartialUpdate(dc){
		// show sec
		sleepMode = true;
		var dateTime = DateTimeBuilder.build();
		layouts[3].drawSeconds(dc,dateTime.getSeconds(),true);
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
	
	function margin(dc){
		return (dc.getWidth() - 195)/2;
	}

}
