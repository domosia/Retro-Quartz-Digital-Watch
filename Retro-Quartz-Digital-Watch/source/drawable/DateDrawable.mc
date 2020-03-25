using Toybox.Graphics as Gfx;
using Toybox.WatchUi;
using Toybox.System;

class DateDrawable extends WatchUi.Drawable {
	var font3;
	private var height = System.getDeviceSettings().screenHeight;
	private var width = System.getDeviceSettings().screenWidth;
	var dayX = width-30;
	var dayY = (height/6+2);
	var dateY = 4*(height/6)+6;
	var dateX = width-30;
	var stepX = 30;
	var stepY;
	function initialize(options) {
		Drawable.initialize(options);
		font3 = WatchUi.loadResource(Rez.Fonts.id_font_digital_date);
		var stepX_ = options.get(:stepX);
		if(stepX_ != null) {
			stepX = stepX_;
		}
		var stepY_ = options.get(:stepY);
		if(stepY_ != null) {
			stepY = stepY_;
		}
		var dateY_ = options.get(:dateY);
		if(dateY_ != null) {
			dateY = dateY_;
		}
		var dateX_ = options.get(:dateX);
		if(dateX_ != null) {
			dateX = dateX_;
		}
		var dayY_ = options.get(:dayY);
		if(dayY_ != null) {
			dayY = dayY_;
		}
		var dayX_ = options.get(:dayX);
		if(dayX_ != null) {
			dayX = dayX_;
		}
		stepY = dateY;
	}
	
	function draw(dc) {
		var dateTime = DateTimeBuilder.build();
		drawDate(dc, dateTime.getDay(), dateTime.getMonth(), dateTime.getDayOfWeek());
		drawStep(dc, dateTime.getStep());
	}
	
	private function drawStep(dc,stepStr){
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		dc.drawText(stepX, stepY, font3, stepStr, Gfx.TEXT_JUSTIFY_LEFT);
		//dc.drawText(stepX, stepY, font3, "5716", Gfx.TEXT_JUSTIFY_LEFT);
	}
	
	private function drawDate(dc, dayStr, monthStr, dayWeekStr){
		//Draw Date
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dateX, dateY, font3, monthStr+"-"+dayStr, Gfx.TEXT_JUSTIFY_RIGHT);
		dc.drawText(dayX, dayY, font3, dayWeekStr.toLower(), Gfx.TEXT_JUSTIFY_RIGHT);
	}
}