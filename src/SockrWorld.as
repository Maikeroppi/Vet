package  
{

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class SockrWorld extends World 
	{
		
		public static var CurrentLevel:Level;
		public var OgmoData:XML;
		
		private var Player1Entity_:Paddle;
		private var Player2Entity_:Paddle;
		private var BackdropEntity_:Entity;
		private var PlayerCheck_:Boolean;
		
		// Variable for holding the entities in Birthday.oep
		public static var EntityMap:Dictionary = new Dictionary;

		public function SockrWorld()
		{
			BackdropEntity_ = new Entity(0, 0);
			BackdropEntity_.graphic = Image.createRect(Assets.kScreenWidth, Assets.kScreenHeight, 0xff7DA0FF, 1.0);
			BackdropEntity_.layer = 5;
			
			PlayerCheck_ = true;
		}
		
		public function loadEntities(xml:Class):void
		{
			var rawData:ByteArray = new xml;
			var dataString:String = rawData.readUTFBytes(rawData.length);
			OgmoData = new XML(dataString);
			
			var dataElement:XML;
			var dataList:XMLList = OgmoData.EntityDefinitions.EntityDefinition;
			var currentEntity:Entity;
			
			for each(var key:Class in Assets.ImageDictionary) {
				trace(key);
			}
			
			var Name:String;
			for each(dataElement in dataList) {
				// Convert XML to type String for switch statement as well as EntityMap key
				Name = dataElement.@Name;
				trace(Name);
				var ImageVal:Image;
						
				switch(Name) {
				case "Player1":
					Player1Entity_ = new Paddle(1);
					EntityMap["Player1"] = Player1Entity_;
					ImageVal = new Image(Assets.Player1Image);
					Player1Entity_.graphic = ImageVal;
					Player1Entity_.setHitbox(ImageVal.width, ImageVal.height,0,0);
					break;
				case "Player2":
					Player2Entity_ = new Paddle(2);
					EntityMap["Player2"] = Player2Entity_;
					ImageVal = new Image(Assets.Player2Image);
					Player2Entity_.graphic = ImageVal;
					Player2Entity_.setHitbox(ImageVal.width, ImageVal.height, 0, 0);
					break;
					
				case "Ball":
					var BallEntity:Ball;
					BallEntity = new Ball();
					EntityMap["Ball"] = BallEntity;
					break;
					
				default:
					//trace("No associated entity");
					if (dataElement.ImageDefinition.@DrawMode == "Image") {
						currentEntity = new Entity(
							dataElement.Origin.@X, dataElement.Origin.@Y); 
						currentEntity.graphic = new Image(Assets.ImageDictionary[dataElement.ImageDefinition.@ImagePath]);
						currentEntity.type = Name.toLowerCase();
						currentEntity.collidable = true;
						trace(dataElement.Size.Width);
						trace(dataElement.Size.Height);
						currentEntity.setHitbox(dataElement.Size.Width, dataElement.Size.Height);
						EntityMap[Name] = currentEntity;						
					}
					break;
				}
			}
		}
		
		override public function update():void
		{
		
			super.update();
		}
		
		public function changeLevel(levelData:Class):void 
		{
			var level:Level = new Level(levelData);
			var dataList:XMLList = level.LevelData.Objects.*;
			var dataElement:XML;
			var currentEntity:Entity;
			
			CurrentLevel = level;
			
			// Clear current entities / level if set
			removeAll();
			
			
			// Load entities
			for each(dataElement in dataList) {
				currentEntity = EntityMap[dataElement.name()];
				currentEntity.x = dataElement.@x;
				currentEntity.y = dataElement.@y;
				add(currentEntity);
			}
			
			add(level);
			//add(BackdropEntity_);
			
			FP.camera.x = 0;
			FP.camera.y = 0;
		}
		
		override public function begin():void
		{
			// Get our entities from Ogmo file
			loadEntities(Assets.SockrOgmoFile);		
			changeLevel(Assets.SockrField);
			
			super.begin();
		}
	}
		
}

