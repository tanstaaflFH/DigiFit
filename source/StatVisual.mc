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
	
	function updateStat() {
	
	   	var info = ActivityMonitor.getInfo();
    	
    	switch ( mType ) {
    	
    		case Enum.TYPE_STEPS: {
    			mValue = info.steps * 1.0;
    			mGoal = info.stepGoal * 1.0;
    			if ( mGoal == null || mGoal == 0) {
     				mPercent = 1;
    			} else {
    				mPercent = ( mValue / mGoal );
    				if (mPercent > 1) {
    					mPercent = 1;
    				}
    				//System.println("calculation " + mValue + "/" + mGoal + "=" + mPercent);
      			}
    			//System.println("Steps: " + mValue + "/" + mGoal + "/" + mPercent);
    			mString = mValue.format("%d");
    			break;
    		}
    			
     		case Enum.TYPE_DISTANCE: {
    			mValue = info.distance * 1.0;
    			mGoal = 100000.0;
    			if ( mGoal == null || mGoal == 0) {
     				mPercent = 1;
    			} else {
    				mPercent = ( mValue / mGoal );
    				if (mPercent > 1) {
    					mPercent = 1;
    				}
    				//System.println("calculation " + mValue + "/" + mGoal + "=" + mPercent);
      			}
    			//System.println("Steps: " + mValue + "/" + mGoal + "/" + mPercent);
    			mString = ( mValue / 100000 ).format("%.2f") + "k";
       			break;
    		}   		
    	
     		case Enum.TYPE_FLOORS: {
    			mValue = info.floorsClimbed * 1.0;
    			mGoal = info.floorsClimbedGoal * 1.0;
    			if ( mGoal == null || mGoal == 10) {
    				mPercent = 1;
    			} else {
    				mPercent = ( mValue / mGoal );
    				if (mPercent > 1) {
    					mPercent = 1;
    				}
    			}
    			mString = "+" + mValue.format("%d");
    			break;
    		}   		

     		case Enum.TYPE_CALORIES: {
    			mValue = info.calories;
    			break;
    		}   		
    	
     		case Enum.TYPE_ACTIVE_MINUTES: {
    			mValue = info.activeMinutesWeek;
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
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
		dc.fillRectangle(mX, mY, mWidth, mHeight);
		
		//! foreground arc
		dc.setColor(mColor, Graphics.COLOR_BLACK);
		dc.fillRectangle(mX, mY, width, mHeight);
		
		//! stat values
		dc.drawText(mX+mWidth/2, mY+mHeight/2, Graphics.FONT_XTINY, mString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		 
	}

}