using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class BluetoothUi {

	private var x;
	private var y;
	private var bluetoothIconBlack;
	private var bluetoothIconGrey;
	function initialize(x_,y_,bluetoothIconBlack_,bluetoothIconGrey_){
		x = x_;
		y = y_;
		bluetoothIconBlack = bluetoothIconBlack_;
		bluetoothIconGrey = bluetoothIconGrey_;
	}

	enum {
		NotInitialized,
		NotConnected,
		Connected
	}

	function draw(dc){
		var state = bluetoothState();
		if(state == NotInitialized) {
			return;
		}
		
		dc.drawBitmap(x, y, state == Connected ? bluetoothIconBlack : bluetoothIconGrey);
	}

	private function bluetoothState(){
		var settings = Sys.getDeviceSettings();
		var state = null;
		if (settings has : connectionInfo) {
			// Check the connection state v3.0.0
			var bluetoothState = settings.connectionInfo[:bluetooth].state ;

			if(bluetoothState == Sys.CONNECTION_STATE_CONNECTED){
				state = Connected;
			}else if(bluetoothState == Sys.CONNECTION_STATE_NOT_CONNECTED){
				state = NotConnected;
			}else{
				state = NotInitialized;
			}

		}else {
			if(settings.phoneConnected){
				state = Connected;
			}else{
				state = NotConnected;
			}
		}
		return state;
	}
}