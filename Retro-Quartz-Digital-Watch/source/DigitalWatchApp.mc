using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class DigitalWatchApp extends App.AppBase {

	function initialize() {
		AppBase.initialize();
	}

	// onStart() is called on application start up
	function onStart(state) {
		getSettings();
	}

	// onStop() is called when your application is exiting
	function onStop(state) {
	}

	// Return the initial view of your application here
	function getInitialView() {
		return [ new DigitalWatchView() ];
	} 

	function onSettingsChanged() {
		getSettings();
		Ui.requestUpdate();
	}
	
	function getSettings() {
		var sm = 0;
		if (Toybox.Application has :Storage) {
			gp = Properties.getValue("powerMode");
			sm = Properties.getValue("secMode");
		} else {
			gp = Application.getApp().getProperty("powerMode");
			sm = Application.getApp().getProperty("secMode");
		}
		if (sm == 0) {
			secColor = Gfx.COLOR_BLACK;
			secHidden = "--";
		} else if (sm == 1) {
			secColor = Gfx.COLOR_BLACK;
			secHidden = "";
		} else {
			secColor = Gfx.COLOR_LT_GRAY;
			secHidden = "88";
		}
	}

}