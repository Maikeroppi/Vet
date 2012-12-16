package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class ScreenWorld extends World 
	{
		public static const StartScreen:int = 1;
		public static const EndScreen:int = 2;
		public static const Transition:int = 3;
		
		private var Screen_:Entity;
		private var Type_:int;
		private var ScreenDuration_:Number;
		private var ScreenDone_:Tween;
		private var TransitionWorld_:World;
		private var EndMusic_:Sfx;
		
		public function ScreenWorld(WorldImage:Class, Type:int, duration:Number = 0, WorldToGoTo:World = null) 
		{
			Screen_ = new Entity(0, 0, new Image(WorldImage));
			add(Screen_);
			Type_ = Type;
			
			if (Type == Transition && duration != 0.0) {
				TransitionWorld_ = WorldToGoTo;
				ScreenDone_ = new Tween(duration, Tween.PERSIST, StartTransition);
				addTween(ScreenDone_,true);
			}
			
			if (Type == EndScreen) {
				EndMusic_ = new Sfx(Assets.GoatWinsMusic);
				EndMusic_.play();
			}
		}
		
		public function StartTransition():void
		{
			if (TransitionWorld_ != null) FP.world = TransitionWorld_;
		}
		
		public override function update():void
		{
			if(Type_ == StartScreen) {
				if ( Input.check(Key.S) ) {
					FP.world = new VetWorld();
					
				}
			}
			super.update();
		}		
	}

}