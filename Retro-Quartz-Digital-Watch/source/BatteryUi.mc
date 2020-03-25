using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class BatteryUi {

	private var x;
	private var y;
	private var width;
	private var height;

	function initialize(x_, y_, width_, height_){
		me.x = x_;
		me.y = y_;
		me.width = width_;
		me.height = height_;
	}
	
	function draw(dc){
		var battery = Sys.getSystemStats().battery;
		var split = 2;
		var block = 3;
		var size = 6;
		var lowBattery = 25;
		var fullBattery = 100;
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		dc.drawRectangle(x, y, width, height);
		dc.fillRectangle(x+split+((size)*(block+1)), y+(2*split), 3, height-(4*split));
		if(battery>lowBattery){
			dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
		}else{
			dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
		}
		for (var i = 0; i < (size*(battery/fullBattery)); i += 1){
			dc.fillRectangle(x+split+(i*(block+1)), y+split, block, height-(2*split));
		}
	}
}