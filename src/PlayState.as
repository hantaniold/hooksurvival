package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	
	public class PlayState extends FlxState 
	{
		
		public var player:Player;
		public var ground:FlxSprite;
		public var block:FlxSprite;
		
		public var input:Input_Handler = new Input_Handler;
		override public function create():void 
		{
			
			player = new Player(50, 300,input,this);
			player.add_to(this);
			
			ground = new FlxSprite(0, 350);
			ground.makeGraphic(500, 50, 0xff33ff33);
			add(ground);
			
			block = new FlxSprite(200, 200);
			block.makeGraphic(60, 60, 0xff333333);
			add(block);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			player = null;
			input = null;
		}
		override public function update():void 
		{
			input.update();
			
			
			super.update();
		}
		
		override public function draw():void 
		{
			super.draw();
		}
		
		
	}

}