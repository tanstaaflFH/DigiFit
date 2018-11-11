using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;

class DigiFitView extends WatchUi.WatchFace {

	var mPowerMode = false;

	var mFirstStatVis;
	var mSecStatVis;
	var mThirdStatVis;
	var mFourthStatVis;
	var mFifthStatVis;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
       	mFirstStatVis = new StatVisual(dc, "StatVis1", Enum.TYPE_STEPS);  
       	mSecStatVis = new StatVisual(dc, "StatVis2", Enum.TYPE_FLOORS);
       	mThirdStatVis = new StatVisual(dc, "StatVis3", Enum.TYPE_CALORIES);
   	    mFourthStatVis = new StatVisual(dc, "StatVis4", Enum.TYPE_DISTANCE);
   	    mFifthStatVis = new StatVisual(dc, "StatVis5", Enum.TYPE_ACTIVE_MINUTES);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var seconds = clockTime.sec;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
        var view = View.findDrawableById("TimeLabel");
        view.setColor(Application.getApp().getProperty("ForegroundColor"));
        view.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        mFirstStatVis.update(dc);
        mSecStatVis.update(dc);
        mThirdStatVis.update(dc);
        mFourthStatVis.update(dc);
        mFifthStatVis.update(dc);
        
        if (mPowerMode) {
        	drawSeconds(dc, seconds);
        }

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	mPowerMode = true;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    	mPowerMode = false;
    }
    
    // update the seconds arc
    hidden function drawSeconds(dc, seconds) {
    	
    	//!draw background circle all around
    	dc.setPenWidth(10);
    	//dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
    	//dc.drawCircle(120,120,117);
    	
    	//!calculate arc values for the seconds bar
    	var percent = seconds/60.0;
		var degree = 90 - Math.floor(percent * 360);
		if (degree < 0) {
			degree = 360 + degree;
		}
		System.println("Seconds: " + seconds + " Percent: " + percent + " Degree: " + degree);
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawArc(120, 120, 115, Graphics.ARC_CLOCKWISE, degree+1, degree-1);
		    	
    }

}
