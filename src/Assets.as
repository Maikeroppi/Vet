package  
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Assets 
	{
		// Load up OGMO stuff
		[Embed(source = "../data/Level1.oel", mimeType = "application/octet-stream")]
		public static const Level1:Class;
		
		
		[Embed(source = "../data/Vet.oep", mimeType = "application/octet-stream")]
		public static const VetOgmoFile:Class;
		
		// Images
		[Embed(source = "../data/Goat.png")]
		public static const GoatImage:Class;
		
		[Embed(source = "../data/Kittent.png")]
		public static const KittentImage:Class;
		
		[Embed(source = "../data/Player.png")]
		public static const PlayerImage:Class;
		
		[Embed(source = "../data/Puppei.png")]
		public static const PuppeiImage:Class;
		
		[Embed(source = "../data/Tiles.png")]
		public static const TilesImage:Class;
		
		[Embed(source = "../data/Table.png")]
		public static const TableImage:Class;
		
		[Embed(source = "../data/EvilBoxxyBox.png")]
		public static const EvilBoxxyBoxImage:Class;
		
		[Embed(source = "../data/StartScreen.png")]
		public static const StartScreen:Class;
		
		[Embed(source = "../data/YouWin.png")]
		public static const YouWin:Class;
		
		[Embed(source = "../data/GameOver.png")]
		public static const GameOver:Class;
		
		
		public static var ImageDictionary:Object = {
			"Player.png":Assets.PlayerImage
			, "Kittent.png":Assets.KittentImage
			, "Goat.png":Assets.GoatImage
			, "Puppei.png":Assets.PuppeiImage
			, "Tiles.png":Assets.TilesImage
			, "Table.png":Assets.TableImage
			, "EvilBoxxyBox.png":Assets.EvilBoxxyBoxImage
		};
			
		// Set screen size
		public static const kScreenWidth:int = 320;
		public static const kScreenHeight:int = 240;
		public static const kBackgroundcolor:uint = 0xFFFFFFFF;
		
		// Set tile parameters
		public static const kTileWidth:int = 16;
		public static const kTileHeight:int = 16;
		public static const kScreenWidthInTiles:int = kScreenWidth / kTileWidth;
		public static const kScreenHeightInTiles:int = kScreenHeight / kTileHeight;
		
		
				
		public function Assets() 
		{
			
		}
		
	}

}