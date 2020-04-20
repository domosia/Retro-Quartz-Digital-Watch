using Toybox.Time.Gregorian as Calendar;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;

module DateTimeBuilder{

	function build(){
		var clockTime = System.getClockTime();
		var hour = clockTime.hour;
		var hourString = Lang.format("$1$", [calculateHour(hour)]);
		if (leadingZero and hourString.length() == 1) {
			hourString = "0" + hourString;
		} 
		var minString = Lang.format("$1$", [ clockTime.min.format("%02d")]);
		var secString = Lang.format("$1$", [clockTime.sec.format("%02d")]);
		
		var now = Time.now();
		var info = Calendar.info(now, Time.FORMAT_SHORT);

		return new DateTime(hourString,minString,secString,calculateMeridiam(hour));
	}
	
	function calculateHour(hour){
		var settings = System.getDeviceSettings();
		if(!settings.is24Hour){
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
		if(!settings.is24Hour){
			return hour > 12 ? "PM" : "AM";
		}else{
			return "";
		}
	}

	class DateTime{
		private var hourString;
		private var minString;
		private var secString;
		private var meridiam;
		
		function initialize(ihourString,iminString,isecString,imeridiam){
			hourString=ihourString;
			minString=iminString;
			secString=isecString;
			meridiam=imeridiam;
		}
		
		function getHour(){
			return hourString;
		}
		
		function getMinutes(){
			return minString;
		}
		
		function getSeconds(){
			return secString;
		}
		
		function getMeridiam(){
			return meridiam;
		}
	}
}