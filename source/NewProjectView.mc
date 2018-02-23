using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Greg;
using Toybox.ActivityMonitor as AcMoni;
using Toybox.Lang as Lang;

class NewProjectView extends Ui.WatchFace 
{
	var  bluetoothLogo;
	var settingsChanged = true;
	var rectangleView;
	
    function initialize() 
    {
        WatchFace.initialize();
    }

    //! Load your resources here
    function onLayout(dc) 
    {
        setLayout(Rez.Layouts.WatchFace(dc));
        bluetoothLogo = Ui.loadResource(Rez.Drawables.id_blue);
      	 
    }
    
    function getSettings(dc){
    	if (!settingsChanged) 
    	{
			return;
		}
		settingsChanged = false;
		var rectangle = View.findDrawableById("rectangle");
		rectangle.updateColor();
		
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() { }

    //! Update the view
    function onUpdate(dc) 
    {
    	//Sys.println("Update");
 		getSettings(dc);
   		
        // Get and show the current time
        var clockTime = Sys.getClockTime();
        var hour = clockTime.hour;
        if (!Sys.getDeviceSettings().is24Hour)
        {
        	if(hour > 12)
        	{
        		hour = hour - 12;
        	}
        }
        var timeString = Lang.format("$1$:$2$", [hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel");
        view.setText(timeString);
        
        //Date
        var nowInfo = Greg.info(Time.now(), Time.FORMAT_MEDIUM);
		var dateLabel = View.findDrawableById("DateLabel");
		var nowString = Lang.format("$1$, $2$ $3$", [nowInfo.day_of_week, nowInfo.day, nowInfo.month]);
		dateLabel.setText(nowString);
		
		//Info - branding
		var infoLabel = View.findDrawableById("InfoLabel");
		var branding = "sixtop.net";
		infoLabel.setText(branding);
		
		//Battery and notification count
		var batteryLevel = Sys.getSystemStats();
		var batLabel = View.findDrawableById("BatteryLabel");
		var warningLabel = View.findDrawableById("WarningLabel");
		if (batteryLevel.battery<10.0) // critical batt level
		{
			batLabel.setColor(Gfx.COLOR_RED);
			var batteryString = Lang.format("$1$%",[batteryLevel.battery.format("%01d")]);
			batLabel.setText(batteryString);
			warningLabel.setText("");
		}
		else //We can display the notification count
		{
			batLabel.setText("");
			var n = Sys.getDeviceSettings().notificationCount;
			if(n > 0)
			{
				warningLabel.setText(n+"");
			}
		}
		
		//Activity
		var activityLabel = View.findDrawableById("ActivityLabel");
		if (Sys.getDeviceSettings().activityTrackingOn == true) 
    	{
    		var actInfo = AcMoni.getInfo();
    		if(actInfo!=null)
    		{
			    activityLabel.setText(kilofy(actInfo.distance/100) + "m  " + kilofy(actInfo.calories) + "cal");
			    infoLabel.setText(kilofy(actInfo.steps) + " steps");
    		}
    		else 
    		{
    			activityLabel.setText("");
    			infoLabel.setText(branding);
    		}
    	}
    	else 
    	{
    		activityLabel.setText("");
    		infoLabel.setText(branding);
    	}
	    
		//Ended update the layout
      	View.onUpdate(dc);
      	
      	//draw bluetooth icon
      	if (Sys.getDeviceSettings().phoneConnected == true )
      	{
      		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
        	dc.drawBitmap(162,161, bluetoothLogo);
      	}
    }
    
    function kilofy(number)
    {
    	if(number>1000)
    	{
    		return (number.toFloat() / 1000).format("%.1f") + "k";
    	}
    	else
    	{
    		return number;
    	}
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    
    }

}
