package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	public class Script 
	{
		
		/**
		 * Inits a flxgroup to have the desired things
		 */
		public static function init_group(group:FlxGroup,nr:int, width:int, height:int, color:uint, image:Class = null):void {
			for (var i:int = 0; i < nr; i++) {
				var s:FlxSprite = new FlxSprite(0, 0);
				if (image != null) {
					s.loadGraphic(image, true, false, width, height);
				} else {
					s.makeGraphic(width, height, color);
				}
				group.add(s);
			}
		}
		
	}

}