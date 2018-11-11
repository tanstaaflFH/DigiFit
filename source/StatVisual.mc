using Toybox.Graphics;
using Toybox.ActivityMonitor;
using Toybox.Application;

class StatVisual {

	const mFORM_ARC = "arc";
	const mFORM_BAR = "bar"; 

	var mX;
	var mY;
	var mDia;
	var mHeight;
	var mWidth;
	var mColor;
	var mForm;
	var mType;
	
	var mValue;
	var mGoal = 0;
	var mPercent;
	var mString;

	function initialize(dc, identifierProperty, type) {
		System.println("New arc class created");
		
		//! get corresponding properties
		mX = Application.getApp().getProperty(identifierProperty+"_x");
		mY = Application.getApp().getProperty(identifierProperty+"_y");
		mForm = Application.getApp().getProperty(identifierProperty+"_form");
		mColor = Application.getApp().getProperty(identifierProperty+"_color");
		if (mForm.equals(mFORM_ARC)) {
			mDia = Application.getApp().getProperty(identifierProperty+"_diameter");
		} else if (mForm.equals(mFORM_BAR)) {
			mHeight = Application.getApp().getProperty(identifierProperty+"_height");
			mWidth = Application.getApp().getProperty(identifierProperty+"_width");
		}
		
		//! set other system variables
		mType = type;
		
		updateStat();
		draw(dc);
		
	}
	
	function update(dc) {
	
		//System.println("arc class update called");
		updateStat();
		draw(dc);
		
	}
	
	hidden function calculatePercentage(value, goal) {
	
		var percent;
	
		if ( goal == null || goal == 0) {
 			percent = 1;
		} else {
			percent = ( (value*1.0) / (goal*1.0) );
			if (percent > 1) {
				percent = 1;
			}
			//System.println("calculation " + mValue + "/" + mGoal + "=" + mPercent);
  		}
  		
  		return percent;
	
	}
	
	function updateStat() {
	
	   	var info = ActivityMonitor.getInfo();
    	
    	switch ( mType ) {
    	
    		case Enum.TYPE_STEPS: {
    			mValue = info.steps * 1.0;
    			mGoal = info.stepGoal * 1.0;
    			mPercent = calculatePercentage(mValue, mGoal);
	   			//System.println("Steps: " + mValue + "/" + mGoal + "/" + mPercent);
    			mString = mValue.format("%d");
    			break;
    		}
    			
     		case Enum.TYPE_DISTANCE: {
    			mValue = info.distance * 1.0;
    			mGoal = 100000.0;
    			mPercent = calculatePercentage(mValue, mGoal);
    			//System.println("Steps: " + mValue + "/" + mGoal + "/" + mPercent);
    			mString = ( mValue / 100000 ).format("%.2f") + "km";
       			break;
    		}   		
    	
     		case Enum.TYPE_FLOORS: {
    			mValue = info.floorsClimbed * 1.0;
    			mGoal = info.floorsClimbedGoal * 1.0;
    			mPercent = calculatePercentage(mValue, mGoal);
    			mString = "+" + mValue.format("%d");
    			break;
    		}   		

     		case Enum.TYPE_CALORIES: {
    			mValue = info.calories;
    			mGoal = 2500;
    			mPercent = calculatePercentage(mValue, mGoal);
    			mString = mValue.format("%d") + " kCal";
    			break;
    		}   		
    	
     		case Enum.TYPE_ACTIVE_MINUTES: {
    			mValue = info.activeMinutesWeek.total;
    			mGoal = info.activeMinutesWeekGoal;
    			mPercent = calculatePercentage(mValue, mGoal);
    			mString = mValue.format("%d") + " min";
    			break;
    		}
    		
    	}   		
		
	}
	
	hidden function draw(dc) {
	
		//System.println(mForm);
	
		if (mForm.equals(mFORM_ARC)) {
			//System.println("Calling drawArc(dc)");
			drawArc(dc);
		} else if (mForm.equals(mFORM_BAR)) {
			drawBar(dc);
		}
		
	}

	hidden function drawArc(dc) {

		//! calculate foreground arc degrees, taking into account 0° at West rosette
		var degree = 80 - Math.floor(mPercent * 340);
		if (degree < 0) {
			degree = 360 + degree;
		}

		System.println("arc class drawn with value: " + mValue + "/" + mPercent + "/" + degree);	
		
		//! background arc
		dc.setPenWidth(2);
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
		dc.drawArc(mX, mY, mDia/2, Graphics.ARC_CLOCKWISE, 80, 100);
		
		//! foreground arc
		//dc.setPenWidth(2);
		dc.setColor(mColor, Graphics.COLOR_BLACK);
		dc.drawArc(mX, mY, mDia/2, Graphics.ARC_CLOCKWISE, 80, degree);
		
		//! stat values
		dc.drawText(mX, mY+mDia/2+5, Graphics.FONT_XTINY, mString, Graphics.TEXT_JUSTIFY_CENTER);
		 
	}
	
	hidden function drawBar(dc) {

		//! calculate foreground bar width
		var width = Math.floor(mWidth*mPercent);

		System.println("bar class drawn with value: " + mValue + "/" + mPercent + "/" + width);	
		
		//! background bar
		dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
		dc.fillRectangle(mX, mY, mWidth, mHeight);
		
		//! foreground bar
		dc.setColor(mColor, Graphics.COLOR_BLACK);
		dc.fillRectangle(mX, mY+1, width, mHeight-1);
		
		//! borders
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
		dc.fillRectangle(mX, mY, mWidth, 1);
		
		//! stat values
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
		dc.drawText(mX+mWidth/2, mY-1+mHeight/2, Graphics.FONT_XTINY, mString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		 
	}

}