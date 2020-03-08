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
		
		drawTime(dc, dateTime.getHour(), dateTime.getMinutes(), dateTime.getSeconds(), dateTime.getMeridiam());
	}
	
	function drawSeconds(dc,sec,isPartialUpdate){
		var yPositionSec = dc.getHeight()/2  +  dc.getFontHeight(font) / 2 - dc.getFontHeight(font2) -1  + paddingY;
		var xPositionSec = dc.getWidth() - margin(dc) - 46;
		var width = 45;
		var height = 41;
		if (dc has :setClip) {
			dc.setClip(xPositionSec, yPositionSec + 10, width, height);
		}
		if (isPartialUpdate) {
			// clear sec
			dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
			dc.fillRectangle(xPositionSec, yPositionSec + 10, width, height);
		}
		if (isPartialUpdate or partialUpdateDevice or !sleepMode) {
			// show sec
			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
			dc.drawText(xPositionSec, yPositionSec, font2, sec, Gfx.TEXT_JUSTIFY_LEFT);
		} else {
			// no sec, sleep mode
			dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
			dc.drawText(xPositionSec, yPositionSec, font2, "--", Gfx.TEXT_JUSTIFY_LEFT);
		}
		if (dc has :setClip) {
			dc.clearClip();
		}
	}

	private function drawTime(dc, hour, minute,sec,meridiam){
		// Draw Time
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		if(meridiam != ""){
			dc.drawText(30, dc.getHeight()-2*(dc.getHeight()/3)-8 + meridiamY, font5, meridiam, Gfx.TEXT_JUSTIFY_LEFT);
		}
		var margin = margin(dc);
		var yPosition = dc.getHeight()/2 + 3 + paddingY;
		var xPosition = dc.getWidth() - margin(dc) - 50; 
		dc.drawText( xPosition, yPosition, font, hour+":"+minute, Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER);
		// Draw Seconds
		drawSeconds(dc,sec,false);
	}
	
	private function margin(dc){
		return (dc.getWidth() - 195)/2;
	}
}