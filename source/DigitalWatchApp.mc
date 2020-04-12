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
			timeCenter = Properties.getValue("alignCenter");
			dateFormat = Properties.getValue("dateFormat");
			dataFieldsType [1] = Properties.getValue("dfMode1");
			dataFieldsType [2] = Properties.getValue("dfMode2");
			dataFieldsType [3] = Properties.getValue("dfMode3");

			colorBackground = Properties.getValue("colorBackground");
			colorTime = Properties.getValue("colorTime");
			colorData = Properties.getValue("colorData");
			colorLine = Properties.getValue("colorLine");
			colorInactive = Properties.getValue("colorInactive");
			colorDnd = Properties.getValue("colorDnd");
			colorBattery = Properties.getValue("colorBattery");



		} else {
			gp = Application.getApp().getProperty("powerMode");
			sm = Application.getApp().getProperty("secMode");
			timeCenter = Application.getApp().getProperty("alignCenter");
			dateFormat = Application.getApp().getProperty("dateFormat");
			dataFieldsType [1] = Application.getApp().getProperty("dfMode1");
			dataFieldsType [2] = Application.getApp().getProperty("dfMode2");
			dataFieldsType [3] = Application.getApp().getProperty("dfMode3");
			
			colorBackground = Application.getApp().getProperty("colorBackground");
			colorTime = Application.getApp().getProperty("colorTime");
			colorData = Application.getApp().getProperty("colorData");
			colorLine = Application.getApp().getProperty("colorLine");
			colorInactive = Application.getApp().getProperty("colorInactive");
			colorDnd = Application.getApp().getProperty("colorDnd");
			colorBattery = Application.getApp().getProperty("colorBattery");
			
		}
		if (sm == 0) {
			secHidden = '-';
		} else if (sm == 1) {
			secHidden = null;
		} else {
			secHidden = '8';
		}
		
		
	}

}