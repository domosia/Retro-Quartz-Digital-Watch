using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi;

class TimeDrawable extends WatchUi.Drawable {
	private var partialUpdateDevice = (Toybox.WatchUi.WatchFace has :onPartialUpdate);
	private var font;
	private var font2 = new [2];
	private var font5;
	private var yPosition;
	private var secStringArray;
	private var firstChrSec = '6';

	private var fontTimeWidth;
	private var fontTime1Width;
	private var fontSecondsWidth = new [2];
	private var fontSecondWidth = new [2];
	private var fontSecondWidthX = new [2];
	private var fontTimeSpaceWidth;
	private var fontSeparatorWidth;
	private var fontSecondsSpaceWidth;
	private var yPositionSec;
	private var xPositionSec;
	private var fonSecondsHeight;
	private var hour;
	private var minute;
	private var sec;
	private var meridiam;
	
	function initialize(options) {
		Drawable.initialize(options);
		font = WatchUi.loadResource(Rez.Fonts.id_font_digital);
		font5 = WatchUi.loadResource(Rez.Fonts.id_font_cas10_meridiam);
		font2 [0] = WatchUi.loadResource(Rez.Fonts.id_font_digital_sec);
		font2 [1] = WatchUi.loadResource(Rez.Fonts.id_font_digital_sec_2);

		// Get font size types
		fontTimeWidth = options.get(:fontTimeWidth);
		fontTime1Width = options.get(:fontTime1Width);
		fontSecondWidth [0] = options.get(:fontSecondsWidth);
		fontSecondWidthX [0] = fontSecondWidth [0] + 3;
		fontSecondsWidth [0] = fontSecondWidth [0] * 2 + 3;
		fontSecondWidth [1] = options.get(:fontSecondsWidth2);
		fontSecondWidthX [1] = fontSecondWidth [1] + 3;
		fontSecondsWidth [1] = fontSecondWidth [1] * 2 + 3;
		fontTimeSpaceWidth = options.get(:fontTimeSpaceWidth);
		fontSeparatorWidth = options.get(:fontSeparatorWidth);
		fontSecondsSpaceWidth = options.get(:fontSecondsSpaceWidth);
		
		yPosition = options.get(:yPosition);
	}
	
	function draw(dc) {
		getTime();
		
		// calculate time center position
		var timeWidth;
		if (timeCenter == 0) {
			// classic position
			timeWidth = fontTimeWidth * 4 + fontTimeSpaceWidth * 2 + fontSeparatorWidth;
		} else {
			// force center
			if (hour.length() > 1) {
				// hour two digits
				if (hour.substring(0,1).toCharArray()[0] == '1') {
					// firs digit is 1
					timeWidth = fontTime1Width + fontTimeWidth * 3 + fontTimeSpaceWidth * 2 + fontSeparatorWidth;
				} else {
					// first digit is not 1
					timeWidth = fontTimeWidth * 4 + fontTimeSpaceWidth * 2 + fontSeparatorWidth;
				}
			} else {
				// hour one digit
				if (hour.substring(0,1).toCharArray()[0] == '1') {
					// firs digit is 1
					timeWidth = fontTime1Width + fontTimeWidth * 2 + fontTimeSpaceWidth * 2 + fontSeparatorWidth;
				} else {
					// first digit is not 1
					timeWidth = fontTimeWidth * 3 + fontTimeSpaceWidth * 2 + fontSeparatorWidth;
				}
			}
		}
		var secondsWidth;
		if (gp == 2) {
			secondsWidth = 0;
		} else if (!sleepMode or (sleepMode and secHidden != null) or (gp == 0 and !gpDND and partialUpdateDevice) or (timeCenter == 0)) {
			secondsWidth = fontSecondsWidth[secSize] + fontSecondsSpaceWidth;
		} else {
			secondsWidth = 0;
		}
		var xPosition = dc.getWidth() / 2 - (timeWidth + secondsWidth) / 2 + timeWidth + 1;
		xPositionSec =  xPosition + fontSecondsSpaceWidth;
		yPositionSec = yPosition  +  dc.getFontHeight(font) - dc.getFontHeight(font2[secSize]);
		fonSecondsHeight = dc.getFontHeight(font2[secSize]) + 1;

		// Draw Time
		dc.setColor(colorTime, Gfx.COLOR_TRANSPARENT);
		if (meridiam != "") {
			dc.drawText(15, yPosition + 10, font5, meridiam, Gfx.TEXT_JUSTIFY_RIGHT);
		}
		dc.drawText( xPosition, yPosition, font, hour + ":" + minute, Gfx.TEXT_JUSTIFY_RIGHT);
		// Draw Seconds
		drawSeconds(dc,sec,false);
		//
		//
		//Sys.println("yPosition "+yPosition);
		//
		//

	}
	
	function drawSeconds(dc, sec, isPartialUpdate) {
		if (gp < 2) {
			if (isPartialUpdate) {
				// show sec
				secStringArray = sec.toCharArray();
				if (firstChrSec == secStringArray[0]) {
					// one digit
					//Sys.println(secStringArray[1]);
					dc.setClip(xPositionSec + fontSecondWidthX[secSize], yPositionSec, fontSecondWidth[secSize], fonSecondsHeight);
					dc.setColor(colorTime, colorBackground);
					dc.drawText(xPositionSec + fontSecondWidthX[secSize], yPositionSec, font2[secSize], secStringArray[1], Gfx.TEXT_JUSTIFY_LEFT);
				} else {
					// two digits
					//Sys.println(sec);
					dc.setClip(xPositionSec, yPositionSec, fontSecondsWidth[secSize], fonSecondsHeight);
					dc.setColor(colorTime, colorBackground);
					dc.drawText(xPositionSec, yPositionSec, font2[secSize], sec, Gfx.TEXT_JUSTIFY_LEFT);
				}
				dc.clearClip();
				firstChrSec = secStringArray[0];
			} else if (!sleepMode or (gp == 0 and !gpDND and partialUpdateDevice)) {
				// show sec
				dc.setColor(colorTime, colorBackground);
				dc.drawText(xPositionSec, yPositionSec, font2[secSize], sec, Gfx.TEXT_JUSTIFY_LEFT);

			} else {
				// no sec, sleep mode
				if (secHidden == '8') {
					dc.setColor(colorInactiveSec, colorBackground);
				} else {
					dc.setColor(colorTime, colorBackground);
				}
				if (secHidden != null) {
					dc.drawText(xPositionSec, yPositionSec, font2[secSize], secHidden + secHidden, Gfx.TEXT_JUSTIFY_LEFT);
				}
			}
		}
	}

	function getTime() {
		var clockTime = System.getClockTime();
		var hour_ = clockTime.hour;
		hour = Lang.format("$1$", [calculateHour(hour_)]);
		if (leadingZero and hour.length() == 1) {
			hour = "0" + hour;
		} 
		minute = Lang.format("$1$", [ clockTime.min.format("%02d")]);
		sec = Lang.format("$1$", [clockTime.sec.format("%02d")]);
		
		meridiam = calculateMeridiam(hour_);
	}
	
	function calculateHour(hour){
		var settings = System.getDeviceSettings();
		if(timeFormat == 1){
			if(hour == 0){
			 	hour = 12;
			} else if(hour > 12){
				hour = hour - 12;
			}
		}
		
		return hour;
	}
	
	function calculateMeridiam(hour){
		var settings = System.getDeviceSettings();
		if(timeFormat == 1){
			return hour > 11 ? "P" : "";
		}else{
			return "";
		}
	}
}