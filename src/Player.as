package  
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.TiledSpritemap;
	import net.flashpunk.tweens.misc.ColorTween;
	
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Player extends Entity
	{
		private static const HSpeed_:int = 200;
		private static const VSpeed_:int = -150;
		private static const Gravity_:int = 4;
		private static const CarryX_:int = 15;
		private static const CarryY_:int = 10;
		
		
		private var Carrying_:Boolean = false;
		private var Animal_:Kittent;
		private var Sprites_:Spritemap;
		private var FadeTween_:ColorTween;
		private var IsDead_:Boolean = false;
		private var Velocity_:Point;
		private var Jumping_:Boolean = false;
		private var TouchingGround_:Boolean = false;
		
		public function Player()
		{
			type = "player";
			
			Sprites_ = new Spritemap(Assets.PlayerImage, 16, 16);
			graphic = Sprites_;
			
			Sprites_.add("stand", [0], 1, true);
			Sprites_.add("walk", [1, 2], 4, true);
			Sprites_.add("jump", [3, 4], 3, true);
			Sprites_.add("carry_walk", [5, 6], 4, true);
			Sprites_.add("death", [7, 8, 9], 5, true);
			
			setHitbox(16, 16, 0, 0);
			FadeTween_ = new ColorTween(FadeDone);
			FadeTween_.tween(0.4, 0xffffffff, 0x00ffffff, 1.0, 0.0, null);
			
			Velocity_ = new Point(0, 0);
		}
		
		public function FadeDone():void
		{
			IsDead_ = true;
			FP.world = new ScreenWorld(Assets.GameOver, ScreenWorld.EndScreen);
		}
		
		public function IsDead():Boolean 
		{
			return IsDead_;
		}
		
		public function carryAnimal(animal:Kittent):void
		{
			Animal_ = animal;
			Animal_.BeingCarried(x, y);
			Carrying_ = true;
		}
		
		public override function moveCollideX(e:Entity):Boolean
		{
			Jumping_ = false;
			TouchingGround_ = true;
			Sprites_.play("stand");
			return super.moveCollideX(e);
		}
		
		public override function moveCollideY(e:Entity):Boolean
		{
			return moveCollideX(e);
		}
		
		public override function moveBy(x:Number, y:Number, solidType:Object = null, sweep:Boolean = false):void
		{
			if (Carrying_) {
				if (Jumping_) Animal_.moveBy(x, y, solidType, sweep);
				else Animal_.moveBy(x, 0, solidType, sweep);
			}
			super.moveBy(x, y, solidType, sweep);
		}
		
		public override function update():void
		{
			var MoveX:int = 0;
			var MoveY:int = 0;
			var EntityMapDict:Dictionary = VetWorld.EntityMap;
			
			if ( Input.check(Key.A) ) {
				MoveX = -1.0;
				Sprites_.play("walk");
				if (Sprites_.flipped == false) {
					Sprites_.flipped = true;
					if (Carrying_) {
						Animal_.FlipImage();
						Animal_.x = x - CarryX_;
					}
				}
			}
			
			if ( Input.check(Key.D) ) {
				MoveX = 1.0;
				Sprites_.play("walk");
				if(Sprites_.flipped == true) {
					Sprites_.flipped = false;
					if (Carrying_) {
						Animal_.UnFlipImage();
						Animal_.x = x + CarryX_;
					}
				}
			}
			
			if ( Input.check(Key.W) && (TouchingGround_ == true)) {
				Velocity_.y = VSpeed_;
				Jumping_ = true;
				Sprites_.play("jumping");
				TouchingGround_ = false;
			}
			
			
			
			MoveX *= HSpeed_ * FP.elapsed;
			MoveY = Velocity_.y * FP.elapsed;
			Velocity_.y += Gravity_;
			
			if (!TouchingGround_) {
				Sprites_.play("jump");
			} else {
				if (MoveX == 0) {
					Sprites_.play("stand");
				} else {
					Sprites_.play("walk");				
				}
			}
			
			// Will update animal position too
			moveBy(MoveX, MoveY, ["level"], true);
		
			var e:Entity = collide("evilboxxybox", x, y);
			if (e != null) {
				e.collidable = false;
				//addTween(FadeTween_, true);
				Sprites_.play("death");
				IsDead_ = true;
			}
			
			//Sprites_.alpha = FadeTween_.alpha;
			
			super.update();
		}
		
	}

}