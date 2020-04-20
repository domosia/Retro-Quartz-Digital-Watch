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
		var theme = 0;
		if (Toybox.Application has :Storage) {
			gp = Properties.getValue("powerMode");
			sm = Properties.getValue("secMode");
			timeCenter = Properties.getValue("alignCenter");
			dateFormat = Properties.getValue("dateFormat");
			leadingZero = Properties.getValue("leadingZero");
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
			colorStrings = Properties.getValue("colorStrings");
			splitHeight = Properties.getValue("splitHeight");
			theme = Properties.getValue("theme");
			if (theme != 0) {
				setTheme(theme);
				Properties.setValue("colorBackground", colorBackground);
				Properties.setValue("colorTime", colorTime);
				Properties.setValue("colorData", colorData);
				Properties.setValue("colorLine", colorLine);
				Properties.setValue("colorInactive", colorInactive);
				Properties.setValue("colorDnd", colorDnd);
				Properties.setValue("colorBattery", colorBattery);
				Properties.setValue("colorStrings", colorStrings);
				Properties.setValue("splitHeight", splitHeight);

			}
			Properties.setValue("theme", 0);

		} else {
			gp = Application.getApp().getProperty("powerMode");
			sm = Application.getApp().getProperty("secMode");
			timeCenter = Application.getApp().getProperty("alignCenter");
			dateFormat = Application.getApp().getProperty("dateFormat");
			leadingZero = Application.getApp().getProperty("leadingZero");
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
			colorStrings = Application.getApp().getProperty("colorStrings");
			splitHeight = Application.getApp().getProperty("splitHeight");
			theme = Application.getApp().getProperty("theme");
			if (theme != 0) {
				setTheme(theme);
				Application.getApp().setProperty("colorBackground", colorBackground);
				Application.getApp().setProperty("colorTime", colorTime);
				Application.getApp().setProperty("colorData", colorData);
				Application.getApp().setProperty("colorLine", colorLine);
				Application.getApp().setProperty("colorInactive", colorInactive);
				Application.getApp().setProperty("colorDnd", colorDnd);
				Application.getApp().setProperty("colorBattery", colorBattery);
				Application.getApp().setProperty("colorStrings", colorStrings);
				Application.getApp().setProperty("splitHeight", splitHeight);

			}
			Application.getApp().setProperty("theme", 0);
		
		}
		if (sm == 0) {
			secHidden = '-';
		} else if (sm == 1) {
			secHidden = null;
		} else {
			secHidden = '8';
		}
		
	}

	function setTheme(theme) {
		if (theme == 1) {
			colorBackground = Gfx.COLOR_WHITE;
			colorTime = Gfx.COLOR_BLACK;
			colorData = Gfx.COLOR_BLACK;
			colorLine = Gfx.COLOR_BLACK;
			colorInactive = Gfx.COLOR_WHITE;
			colorDnd = Gfx.COLOR_BLACK;
			colorBattery = Gfx.COLOR_BLACK;
			colorStrings = Gfx.COLOR_BLUE;
			splitHeight = 2;
		} else if (theme == 2) {
			colorBackground = Gfx.COLOR_WHITE;
			colorTime = Gfx.COLOR_BLACK;
			colorData = Gfx.COLOR_BLACK;
			colorLine = Gfx.COLOR_BLUE;
			colorInactive = Gfx.COLOR_LT_GRAY;
			colorDnd = Gfx.COLOR_RED;
			colorBattery = Gfx.COLOR_BLUE;
			colorStrings = Gfx.COLOR_BLUE;
			splitHeight = 8;
		} else if (theme == 3) {
			colorBackground = Gfx.COLOR_BLACK;
			colorTime = Gfx.COLOR_WHITE;
			colorData = Gfx.COLOR_WHITE;
			colorLine = Gfx.COLOR_WHITE;
			colorInactive = Gfx.COLOR_BLACK;
			colorDnd = Gfx.COLOR_RED;
			colorBattery = Gfx.COLOR_BLUE;
			colorStrings = Gfx.COLOR_BLUE;
			splitHeight = 2;
		} else if (theme == 4) {
			colorBackground = Gfx.COLOR_WHITE;
			colorTime = Gfx.COLOR_BLACK;
			colorData = Gfx.COLOR_DK_BLUE;
			colorLine = Gfx.COLOR_ORANGE;
			colorInactive = Gfx.COLOR_WHITE;
			colorDnd = Gfx.COLOR_RED;
			colorBattery = Gfx.COLOR_GREEN;
			colorStrings = Gfx.COLOR_ORANGE;
			splitHeight = 8;
		} else if (theme == 5) {
			colorBackground = Gfx.COLOR_ORANGE;
			colorTime = Gfx.COLOR_BLACK;
			colorData = Gfx.COLOR_BLACK;
			colorLine = Gfx.COLOR_BLUE;
			colorInactive = Gfx.COLOR_ORANGE;
			colorDnd = Gfx.COLOR_RED;
			colorBattery = Gfx.COLOR_BLUE;
			colorStrings = Gfx.COLOR_BLUE;
			splitHeight = 8;
		}
		
	}
}