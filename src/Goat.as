package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.motion.LinearMotion;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Goat extends Entity 
	{
		private var Image_:Image;
		private var HeadButt_:LinearMotion;
		
		public function Goat() 
		{
			type = "goat";
			Image_ = new Image(Assets.GoatImage);
			graphic = Image_;
			setHitbox(Image_.width, Image_.height, 0, 0);
			
			HeadButt_ = new LinearMotion();
		}
		
		public function DoHeadbutt():void
		{
			HeadButt_.setMotion(x, y, 0, y, 1.0);
			addTween(HeadButt_, true);
		}
		
		public override function update():void
		{
			if (HeadButt_.active) {
				x = HeadButt_.x;
			}
			super.update();
		}		
	}

}