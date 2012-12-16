package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Kittent extends Entity 
	{
		private var fadeTween_:ColorTween;
		private var runTween_:LinearMotion;
		private var StartRunningTween_:Tween;
		private var BeingCarried_:Boolean = false;
		
		private var Image_:Image;
		private static const CarryX_:int = 15;
		private static const CarryY_:int = 10;
		
		public function Kittent() 
		{
			type = "kittent";
			Image_ = new Image(Assets.KittentImage);
			graphic = Image_;
			setHitbox(Image_.width, Image_.height, 0, 0);
			
			runTween_ = new LinearMotion(RunFinished, Tween.PERSIST);
			
			
			StartRunningTween_ = new Tween(0.5, Tween.PERSIST, StartRunning);
		}
		
		public function StartCountdown():void
		{
			addTween(StartRunningTween_, true);
		}
		
		public function StartRunning():void
		{
			Image_.flipped = true;
			runTween_.setMotion(x, y, x + 390, y, 2.0);
			addTween(runTween_, true);			
		}
		
		public function RunFinished():void
		{
			Image_.flipped = false;
		}
		
		public override function update():void
		{
			if (runTween_.active) {
				x = runTween_.x;
			}
			super.update();
		}
		
		public function FlipImage():void
		{
			if (!Image_.flipped) {
				Image_.flipped = true;
			}
			
		}
		
		public function UnFlipImage():void
		{
			if (Image_.flipped) {
				Image_.flipped = false;
			}
		}
		
		public function BeingCarried(PlayerX:Number, PlayerY:Number):void
		{
			BeingCarried_ = true;
			x = PlayerX + CarryX_;
			y = PlayerY + CarryY_;
			collidable = false;
		}
		
		public function fadeDone():void
		{
			visible = false;
			fadeTween_ = null;
		}
	}

}