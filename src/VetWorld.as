package  
{

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.Tween;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class VetWorld extends World 
	{
		
		public static var CurrentLevel:Level;
		public var OgmoData:XML;
		
		private var PlayerEntity_:Player;
		private var KittentEntity_:Kittent;
		private var GoatEntity_:Goat;
		
		private var PlayerHasAnimal_:Boolean = false;
		private var CloudTween_:Tween;
		private var CloudEntity_:Entity;
		
		private var Level1Done_:Boolean = false;
		private var LoadGoatLevel_:Boolean = false;
		
		
		public static var EntityMap:Dictionary = new Dictionary;

		public function VetWorld()
		{
			CloudTween_ = new Tween(1.0, Tween.PERSIST, CloudDone);
			CloudEntity_ = new Entity(40, 120, new Image(Assets.CloudImage));
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
				case "Player":
					PlayerEntity_ = new Player();
					EntityMap["Player"] = PlayerEntity_;
					break;
					
				case "Kittent":
					KittentEntity_ = new Kittent();
					EntityMap["Kittent"] = KittentEntity_;
					break;
					
				case "Goat":
					GoatEntity_ = new Goat();
					EntityMap["Goat"] = GoatEntity_;
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
			
			var x:int, y:int, width:int, height:int, LevelWidth:int, LevelHeight:int;
			
			if( PlayerEntity_.Controllable == true) {
				x = PlayerEntity_.x;
				y = PlayerEntity_.y;
				width = PlayerEntity_.width;
				height = PlayerEntity_.height;
			} else {
				x = KittentEntity_.x;
				y = KittentEntity_.y;
				width = KittentEntity_.width;
				height = KittentEntity_.height;
			}
			
			LevelWidth = CurrentLevel.LevelWidth_;
			LevelHeight = CurrentLevel.LevelHeight_;
			
			// Don't let player go off the level
			if( PlayerEntity_.Controllable == true) {
				if (x < 0) {
					PlayerEntity_.moveBy( -x, 0);
				}
				
				if (x > (LevelWidth - width)) {
					PlayerEntity_.moveBy((LevelWidth - width) - x, 0);
				}
			} else {
				if (x < 0) {
					KittentEntity_.moveBy( -x, 0);
				}
				
				if (x > (LevelWidth - width)) {
					KittentEntity_.moveBy((LevelWidth - width) - x, 0);
				}

			}
					
			
			// Update camera
			FP.camera.x = x - (Assets.kScreenWidth / 2);
			if(y > Assets.kScreenHeight) FP.camera.y = y - (Assets.kScreenHeight / 2);		
						
			// Don't go past right edge of level
			var WidthFromEdge:Number = LevelWidth - Assets.kScreenWidth;
			if (FP.camera.x > WidthFromEdge) FP.camera.x = WidthFromEdge;
			
			// Don't go past left edge of level
			if (FP.camera.x < 0) FP.camera.x = 0;
			
			// Don't let camera go outside of screen
			if (FP.camera.y < 0) FP.camera.y = 0;
			if (FP.camera.y > (LevelHeight - Assets.kScreenHeight)) FP.camera.y = LevelHeight - Assets.kScreenHeight;
			
			if (PlayerEntity_.collide("kittent", PlayerEntity_.x, PlayerEntity_.y)) {
				if (PlayerEntity_.IsMonster == true) {
					//FP.world = new ScreenWorld(Assets.GameOver, ScreenWorld.EndScreen);
				} else {
					PlayerEntity_.carryAnimal(KittentEntity_);
					PlayerHasAnimal_ = true;
				}
			}
			
			if (PlayerEntity_.collide("goat", PlayerEntity_.x, PlayerEntity_.y) != null) {
				FP.world = new ScreenWorld(Assets.GoatWins, ScreenWorld.EndScreen);
			}
			
			if ( (PlayerHasAnimal_ == true) && (PlayerEntity_.collide("table", PlayerEntity_.x, PlayerEntity_.y) != null) ) {
				PlayerHasAnimal_ = false;
				KittentEntity_.visible = false;
				KittentEntity_.collidable = false;
				PlayerEntity_.GiveUpControl();
				
				add(CloudEntity_);
				addTween(CloudTween_, true);
			}
		}
		
		public function CloudDone():void
		{
			Level1Done_ = true;
			FP.world = new ScreenWorld(Assets.ExamComplete, ScreenWorld.Transition, 1.0, this);			
		}
		
		public function changeLevel(levelData:Class):void 
		{
			var level:Level = new Level(levelData);
			var dataList:XMLList = level.LevelData.Entities.*;
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
			if (Level1Done_) {
				changeLevel(Assets.Level2);
				GoatEntity_.DoHeadbutt();
				PlayerEntity_.LookRight();
				PlayerEntity_.Controllable = true;
				
				//KittentEntity_.AssumeControl();
				//KittentEntity_.visible = true;
				//changeLevel(Assets.Level1);
				//
				//PlayerEntity_.update();
				//PlayerEntity_.MakeMonster();
			} else {
				// Get our entities from Ogmo file
				loadEntities(Assets.VetOgmoFile);		
				changeLevel(Assets.Level1);
			
				super.begin();
			
				// Make the kittent run
				KittentEntity_.StartCountdown();
			}
		}
	}
		
}

