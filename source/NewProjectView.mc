using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Greg;
using Toybox.ActivityMonitor as AcMoni;
using Toybox.Lang as Lang;

class NewProjectView extends Ui.WatchFace {

	var  bluetoothLogo;
	var settingsChanged = true;
	var rectangleView;
	
    function initialize() {
        WatchFace.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
    	
        setLayout(Rez.Layouts.WatchFace(dc));
        bluetoothLogo = Ui.loadResource(Rez.Drawables.id_blue);
      	 
    }
    
    function getSettings(dc){
    	if (!settingsChanged) {
			return;
		}
		settingsChanged = false;
		var rectangle = View.findDrawableById("rectangle");
		rectangle.updateColor();
		
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    
    }

    //! Update the view
    function onUpdate(dc) {
 		Sys.println("RequestUpdate");
 		getSettings(dc);
   		
		
    	Sys.println("Update");
        // Get and show the current time
        var clockTime = Sys.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel");
        view.setText(timeString);
        
        //Date
        var nowInfo = Greg.info(Time.now(), Time.FORMAT_MEDIUM);
		var dateLabel = View.findDrawableById("DateLabel");
		var nowString = Lang.format("$1$ $2$", [nowInfo.day, nowInfo.month]);
		dateLabel.setText(nowString);
		
		//Battery
		var batteryLevel = Sys.getSystemStats();
		var batLabel = View.findDrawableById("BatteryLabel");
		var warningLabel = View.findDrawableById("WarningLabel");
		if (batteryLevel.battery<10.0) {
			batLabel.setColor(Gfx.COLOR_RED);
			warningLabel.setText("BATTERIE FAIBLE");
		}
		else {
			batLabel.setColor(Gfx.COLOR_WHITE);
			warningLabel.setText("");
		}
		var batteryString = Lang.format("$1$%",[batteryLevel.battery.format("%01d")]);
		batLabel.setText(batteryString);

		//Ended update the layout
      	View.onUpdate(dc);
      	
      	if (Sys.getDeviceSettings().phoneConnected == true ){
      		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
        	dc.drawBitmap(160,2, bluetoothLogo);
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
