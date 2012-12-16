package  
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	
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
		private var Controllable_:Boolean = false;
		
		private static const CarryX_:int = 15;
		private static const CarryY_:int = 10;
		private static const VSpeed_:int = -200;
		private static const HSpeed_:int = 200;
		private static const Gravity_:int = 4;
		
		private var TouchingGround_:Boolean = false;
		private var Velocity_:Point;
		private var Jumping_:Boolean = false;
		
		public function Kittent() 
		{
			type = "kittent";
			Image_ = new Image(Assets.KittentImage);
			graphic = Image_;
			setHitbox(Image_.width, Image_.height, 0, 0);
			
			runTween_ = new LinearMotion(RunFinished, Tween.PERSIST);
			Velocity_ = new Point(0, 0);
			
			StartRunningTween_ = new Tween(0.5, Tween.PERSIST, StartRunning);
		}
		
		public function AssumeControl():void
		{
			Controllable_ = true;
			collidable = true;
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
		
		public override function moveCollideY(e:Entity):Boolean
		{
			return moveCollideX(e);
		}
		
		public override function moveCollideX(e:Entity):Boolean
		{
			TouchingGround_ = true;
			return super.moveCollideX(e);
		}
		
		public override function update():void
		{
			var MoveX:Number = 0;
			var MoveY:Number = 0;
			
			if (Controllable_) {
				if ( Input.check(Key.A) ) {
					MoveX = -1.0;
					Image_.flipped = false;
				}
				
				if ( Input.check(Key.D) ) {
					MoveX = 1.0;
					Image_.flipped = true;
				}
				
				if ( Input.check(Key.W) && (TouchingGround_ == true)) {
					Velocity_.y = VSpeed_;
					Jumping_ = true;
					
					TouchingGround_ = false;
				}
							
				MoveX *= HSpeed_ * FP.elapsed;
				MoveY = Velocity_.y * FP.elapsed;
				Velocity_.y += Gravity_;

		
				// Will update animal position too
				moveBy(MoveX, MoveY, ["level"], true);
			} else {
				if (runTween_.active) {
					x = runTween_.x;
				}
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