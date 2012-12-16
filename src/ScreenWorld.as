package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
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
		
		private var Screen_:Entity;
		private var Type_:int;
		public function ScreenWorld(WorldImage:Class, Type:int) 
		{
			Screen_ = new Entity(0, 0, new Image(WorldImage));
			add(Screen_);
			Type_ = Type;
		}
		
		public override function update():void
		{
			if(Type_ == StartScreen) {
				if ( Input.check(Key.W) || Input.check(Key.A) || Input.check(Key.D) || Input.check(Key.D) ) {
					FP.world = new VetWorld();
					
				}
			}
		}		
	}

}