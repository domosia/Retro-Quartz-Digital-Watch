const DF_DATE		= 1;
const DF_WEEKDAYS	= 2;
const DF_STEPS		= 3;
const DF_HR			= 4;
const DF_CALORIES	= 5;
const DF_DISTANCE	= 6;
const DF_ALTITUDE	= 7;
const day_of_week_array = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];

const fontTimeWidth = 28;
const fontTime1Width = 7;
const fontSecondsWidth = 43;
const fontTimeSpaceWidth = 4;
const fontSeparatorWidth = 19;
const fontSecondsSpaceWidth = 7;


// false: looking watch
// true: watch is sleeping
var sleepMode = false;
// 0: sec always on
// 1: sec off
var gp = 0;
// second type on sleep mode
var secHidden = null;
// 0: mm-dd
// 1: dd-mm
var dateFormat = 0;
var timeCenter = 0;

var dataFieldsType = new [4];

var colorBackground = 0;
var colorTime = 0;
var colorData = 0;
var colorLine = 0;
var colorInactive = 0;
var colorDnd = 0;
var colorBattery = 0;

var secXPosition;