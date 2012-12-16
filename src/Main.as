package 
{
import net.flashpunk.Engine;
import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Main extends Engine 
	{
		
		public function Main():void 
		{
			super(Assets.kScreenWidth, Assets.kScreenHeight, 60, false);
			FP.screen.scale = 2;
			//FP.console.enable();
		}
		
		override public function init():void 
		{
			FP.world = new ScreenWorld(Assets.StartScreen, ScreenWorld.StartScreen);
			//FP.world = new VetWorld();
			FP.screen.color = Assets.kBackgroundcolor;
			
			super.init();
		}
		
	}
	
}