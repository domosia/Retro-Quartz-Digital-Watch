using Toybox.Graphics as Gfx;
using Toybox.WatchUi;
using Toybox.System;

class TimeDrawableVivoHR extends WatchUi.Drawable {
	private var font2;
	private var font5;
	private var font3;
	
	var paddingY = 0;
	
	function initialize(options) {
	    Drawable.initialize(options);
    	font2 = WatchUi.loadResource(Rez.Fonts.id_font_digital_sec);
    	font5 = WatchUi.loadResource(Rez.Fonts.id_font_cas10_2);
    	font3 = WatchUi.loadResource(Rez.Fonts.id_font_digital_date);
    	var paddingY_ = options.get(:paddingY);
        if(paddingY_ != null) {
            paddingY = paddingY_;
        }
	}
	    
	function draw(dc) {
		var dateTime = DateTimeBuilder.build();
		
		drawTime(dc, dateTime.getHour(), dateTime.getMinutes(), dateTime.getSeconds(), dateTime.getMeridiam());
	}
	
	function drawSeconds(dc,sec,isPartialUpdate){
        var secString = "";
        	secString = sec;
        	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        var yPosition = dc.getHeight()/2  +  (dc.getFontHeight(font2) - dc.getFontHeight(font3) - 2)/2 + paddingY;
        dc.drawText(dc.getWidth() - margin(dc), yPosition, font3, secString, Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER);
    
    }
    
    private function drawTime(dc, hour, minute,sec,meridiam){
    	// Draw Time
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		if(meridiam != ""){
			dc.drawText(30, dc.getHeight()-2*(dc.getHeight()/3)-22, font5, meridiam, Gfx.TEXT_JUSTIFY_LEFT);
		}
		var margin = margin(dc);
		var yPosition = dc.getHeight()/2 + 5 + paddingY;
        dc.drawText(dc.getWidth()-35 - margin , yPosition, font2, minute, Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER);
        //dc.drawText(dc.getWidth()-77 - margin, yPosition, Gfx.FONT_SYSTEM_LARGE, ":", Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth()-90 - margin, yPosition, font2, hour, Gfx.TEXT_JUSTIFY_RIGHT| Gfx.TEXT_JUSTIFY_VCENTER);

        // Draw Seconds
        drawSeconds(dc,sec,false);
    }
    
    private function margin(dc){
    	return (dc.getWidth() - 130)/2;
    }
}