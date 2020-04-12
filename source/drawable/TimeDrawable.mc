using Toybox.Graphics as Gfx;
using Toybox.WatchUi;
using Toybox.System;

class TimeDrawable extends WatchUi.Drawable {
	private var partialUpdateDevice = (Toybox.WatchUi.WatchFace has :onPartialUpdate);
	private var font;
	private var font2;
	private var font5;
	private var meridiamY = 0;
	
	var paddingY = 0;
	
	function initialize(options) {
		Drawable.initialize(options);
		font = WatchUi.loadResource(Rez.Fonts.id_font_digital);
		font2 = WatchUi.loadResource(Rez.Fonts.id_font_digital_sec);
		font5 = WatchUi.loadResource(Rez.Fonts.id_font_cas10_2);
		var paddingY_ = options.get(:paddingY);
		if(paddingY_ != null) {
			paddingY = paddingY_;
		}

		var meridiamY_ = options.get(:meridiamY);
		if(meridiamY_ != null) {
			meridiamY = meridiamY_;
		}
	}

	function draw(dc) {
		var dateTime = DateTimeBuilder.build();
		var hour = dateTime.getHour();
		var minute = dateTime.getMinutes();
		var sec = dateTime.getSeconds();
		var meridiam = dateTime.getMeridiam();
		
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
					// first digit is 2 or 0
					timeWidth = fontTimeWidth * 4 + fontTimeSpaceWidth * 2 + fontSeparatorWidth;
				}
			} else {
				// hour one digit
				if (hour.substring(0,1).toCharArray()[0] == '1') {
					// firs digit is 1
					timeWidth = fontTime1Width + fontTimeWidth * 2 + fontTimeSpaceWidth * 2 + fontSeparatorWidth;
				} else {
					// first digit is 2 or 0
					timeWidth = fontTimeWidth * 3 + fontTimeSpaceWidth * 2 + fontSeparatorWidth;
				}
			}
		}
		var secondsWidth;
		if (gp == 2) {
			secondsWidth = 0;
		} else if ((gp < 2 and !sleepMode) or (sleepMode and secHidden != null) or (gp == 0 and partialUpdateDevice)) {
			secondsWidth = fontSecondsWidth + fontSecondsSpaceWidth;
		} else {
			secondsWidth = 0;
		}
		var yPosition = dc.getHeight()/2 + 3 + paddingY;
		var xPosition = dc.getWidth() / 2 - (timeWidth + secondsWidth) / 2 + timeWidth;
		secXPosition =  xPosition + fontSecondsSpaceWidth;

		// Draw Time
		dc.setColor(colorTime, Gfx.COLOR_TRANSPARENT);
		if (meridiam != "") {
			dc.drawText(30, dc.getHeight()-2*(dc.getHeight()/3)-8 + meridiamY, font5, meridiam, Gfx.TEXT_JUSTIFY_LEFT);
		}
		dc.drawText( xPosition, yPosition, font, hour+":"+minute, Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER);
		// Draw Seconds
		drawSeconds(dc,sec,false);
	}
	
	function drawSeconds(dc, sec, isPartialUpdate) {
		if (gp < 2) {
			var yPositionSec = dc.getHeight()/2  +  dc.getFontHeight(font) / 2 - dc.getFontHeight(font2) -1  + paddingY;
			var xPositionSec = secXPosition;
			var width = 45;
			var height = 41;
			if (dc has :setClip) {
				dc.setClip(xPositionSec, yPositionSec + 10, width, height);
			}
			if (isPartialUpdate) {
				// clear sec
				dc.setColor(colorBackground, Gfx.COLOR_BLACK);
				dc.fillRectangle(xPositionSec, yPositionSec + 10, width, height);
			}
			if (isPartialUpdate or !sleepMode or gp == 0) {
				// show sec
				dc.setColor(colorTime, Gfx.COLOR_TRANSPARENT);
				dc.drawText(xPositionSec, yPositionSec, font2, sec, Gfx.TEXT_JUSTIFY_LEFT);
			} else {
				// no sec, sleep mode
				if (secHidden == '8') {
					dc.setColor(colorInactive, Gfx.COLOR_TRANSPARENT);
				} else {
					dc.setColor(colorTime, Gfx.COLOR_TRANSPARENT);
				}
				if (secHidden != null) {
					dc.drawText(xPositionSec, yPositionSec, font2, secHidden + secHidden, Gfx.TEXT_JUSTIFY_LEFT);
				}
			}
			if (dc has :setClip) {
				dc.clearClip();
			}
		}
	}

}