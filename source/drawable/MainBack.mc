using Toybox.Graphics as Gfx;
using Toybox.WatchUi;
using Toybox.System as Sys;

class MainBack extends WatchUi.Drawable {
	private var label1;
	private var label2;
	private var label3;
	private var label4;
	private var font4;
	private var font5;
	//private var splitTopY = height-2*(height/3)-5;
	//private var splitBottomY = height-2*(height/6)-3;
	private var splitTopY;
	private var splitBottomY;
	private var splitMaxHeight_ = null;
	private var paddingLineY;
	private var width, height;
	private var bannerTopY = 1; 
	private var bannerBottomY = 1; 
	
	
	function initialize(options) {
		Drawable.initialize(options);
		label1 = WatchUi.loadResource(Rez.Strings.Label1);
		label2 = WatchUi.loadResource(Rez.Strings.Label2);
		label3 = WatchUi.loadResource(Rez.Strings.Label3);
		label4 = WatchUi.loadResource(Rez.Strings.Label4);
		font4 = WatchUi.loadResource(Rez.Fonts.id_font_cas10);
		font5 = WatchUi.loadResource(Rez.Fonts.id_font_cas10_2);
		banner = options.get(:banner);
		bannerTop = options.get(:bannerTop);
		bannerBottom = options.get(:bannerBottom);
		splitMaxHeight_ = options.get(:splitMaxHeight);
		splitTopY = options.get(:splitTopY);
		splitBottomY = options.get(:splitBottomY);
		width = System.getDeviceSettings().screenWidth;	
		height = System.getDeviceSettings().screenHeight;
		if (bannerTop) {
			bannerTopY = height / 6;
			
		}
		bannerBottomY = height-(height / 6);
	}
	
	function draw(dc) {
		// Clear the screen
		dc.setColor(colorBackground, Gfx.COLOR_BLACK);
		dc.fillRectangle(0,bannerTopY + 1,width, height-(bannerTopY) - 1);
		//
		//
		//Sys.println("splitTopY "+splitTopY);
		//Sys.println("splitBottomY "+splitBottomY);
		//
		//
		if(banner){
			if(bannerTop){
				// Top banner
				dc.setColor(colorBackgroundBanner, Gfx.COLOR_WHITE);
				dc.fillRectangle(0,0,width, bannerTopY + 1);
				if (dataFieldsType[0] == DF_DEFAULT) {
					dc.setColor(colorBigStrings, Gfx.COLOR_TRANSPARENT);
					dc.drawText(width/2, 5, font4, label1, Gfx.TEXT_JUSTIFY_CENTER);
					dc.setColor(colorStrings, Gfx.COLOR_TRANSPARENT);
					dc.drawText(width/2, 20, font5, label2, Gfx.TEXT_JUSTIFY_CENTER);
				}
			}
			
			if(bannerBottom){
				//Bottom banner
				dc.setColor(colorBackgroundBanner, Gfx.COLOR_WHITE);
				dc.fillRectangle(0,bannerBottomY,dc.getWidth(), height);
				if (dataFieldsType[4] == DF_DEFAULT) {
					dc.setColor(colorStrings, Gfx.COLOR_TRANSPARENT);
					dc.drawText(width/2, height-32, font5, label3, Gfx.TEXT_JUSTIFY_CENTER);
					dc.setColor(colorBigStrings, Gfx.COLOR_TRANSPARENT);
					dc.drawText(width/2, height-20, font4, label4, Gfx.TEXT_JUSTIFY_CENTER);
				}
			}
		}
		
		if (splitMaxHeight_ != null and splitHeight == 8) {
			splitHeight = splitMaxHeight_;
		}
		paddingLineY = 4 - splitHeight / 2;
		// Split top
		dc.setColor(colorLine, Gfx.COLOR_WHITE);
		dc.fillRectangle(0, splitTopY + paddingLineY, dc.getWidth(), splitHeight);
	
		// Split bottom
		dc.setColor(colorLine, Gfx.COLOR_WHITE);
		dc.fillRectangle(0, splitBottomY + paddingLineY, dc.getWidth(), splitHeight);
	}
}