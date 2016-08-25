using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.ActivityMonitor as AcMoni;
using Toybox.System as Sys;
using Toybox.Application as App;

class RectangleStepsView extends Ui.Drawable {

    hidden var mColor, mMaxWidth, mRectangle;
    var myWidth=20;
	
    function initialize(params) {
        // You should always call the parent's initializer and
        // in this case you should pass the params along as size
        // and location values may be defined.
        Drawable.initialize(params);

        // Get any extra values you wish to use out of the params Dictionary
      
        mMaxWidth = params.get(:maxWidth);
        updateColor();
        
    }
    
    function onUpdate( dc ) {
    	if (Sys.getDeviceSettings().activityTrackingOn == true) {
    		//Steps
			var actInfo = AcMoni.getInfo();
			if (actInfo != null) {
				var steps = actInfo.steps;
				if (steps == null) {steps = 0;}
				var stepGoal = actInfo.stepGoal;
				if (stepGoal == null) {stepGoal = 1;}
				steps = steps.toFloat();
				stepGoal = stepGoal.toFloat();
				var fraction = steps/stepGoal;
				if (fraction > 1) {
					fraction = 1;
				}

				dc.setColor(mColor,mColor);
	    		dc.fillRectangle(32, 120, fraction*150, 2);
			}
    	}
    	else {
    		dc.setColor(mColor,mColor);
    		dc.fillRectangle(32, 120, 0, 2);
    	}    	
		
		
    }
    
    function updateColor(){
    	mColor = checkColor(App.getApp().getProperty("lineColor"), Gfx.COLOR_ORANGE);
    }
    

    
    function draw(dc){
    	

		
		var actInfo = AcMoni.getInfo();
		if (actInfo != null) {
			var steps = actInfo.steps;
			if (steps == null) {steps = 0;}
			var stepGoal = actInfo.stepGoal;
			if (stepGoal == null) {stepGoal = 1;}
			steps = steps.toFloat();
			stepGoal = stepGoal.toFloat();
			var fraction = steps/stepGoal;
			
	
			dc.setColor(mColor,mColor);
    		dc.fillRectangle(32, 120, fraction*150, 2);
		}
	}
	
		
	//Get the color
	function checkColor(c, defcolor) {
		
		if (c == null) {
			return defcolor;
		}
		
		return c;
		
	}
		
	
	
	 
    
}