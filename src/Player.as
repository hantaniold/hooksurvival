package  
{
	import flash.geom.Point;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Sean Hogan
	 */
	public class Player extends FlxSprite 
	{
		
		public var input:Input_Handler;
		private const base_walk_spd:int = 115;
		
		public var hook:FlxSprite;
		public var hook_notches:FlxGroup;
		
		public const s_idle:int = 0;
		public const s_walk:int = 1;
		public const s_jump:int = 2;
		public const normal_y_accel:int = 480;
		public const hook_accel:int = 480;
		public const hook_pull_speed:Number = 0.7;
		
		public const s_hook_hidden:int = 0;
		public const s_hook_thrown:int = 1;
		public const s_hook_attached:int = 2;
		public var player_hook_offset:Point = new Point(5, 5);
		
		public var playstate:PlayState;
		
		
		public function Player(_x:int,_y:int,_input:Input_Handler,_ps:PlayState) 
		{
			super(_x, _y);
			playstate = _ps;
			input = _input;
			makeGraphic(20, 40, 0xffffffff);
			acceleration.y = 200;
			
			hook = new FlxSprite;
			hook.makeGraphic(14, 14, 0xffff0000);
			hook.acceleration.y = 200;
			
			hook_notches = new FlxGroup(8);
			Script.init_group(hook_notches, hook_notches.maxSize, 6, 6, 0xffff4444);
			hook_notches.setAll("visible", false);
			
		}
		public function add_to(group:FlxGroup):void {
			group.add(this);
			group.add(hook);
			group.add(hook_notches);
		}
		
		override public function update():void 
		{
			
			
			
			if (state == s_idle) {
				velocity.x = 0;
				velocity.y = 0;
				acceleration.y = 0;
				if (input.P_L || input.P_R) {
					state = s_walk;
				}
				if (input.JP_A1) {
					state = s_jump;
					acceleration.y = normal_y_accel;
					velocity.y = -160;
				}
			} else if (state == s_walk) {
				velocity.y = 0;
				acceleration.y = 0;
				if (input.P_L && !input.P_R) {
					velocity.x = -base_walk_spd;
				} else if (input.P_R && !input.P_L) {
					velocity.x = base_walk_spd;
				} else {
					velocity.x = 0;
				}
				
				if (input.JP_A1) {
					state = s_jump;
					acceleration.y = normal_y_accel;
					velocity.y = -160;
				}
			} else if (state == s_jump) {
				if (y + height > 350) {
					y = 350 - height;
					velocity.y = 0;
					state = s_idle;
				}
			}
			
			
			if (input.JP_A2) {
			}
			
			update_hook();
			super.update();
		}
		
		public function update_hook():void {
			if (hook.state == s_hook_hidden) {
				hook.visible = false;
				if (input.JP_A2) {
					hook.visible = true;
					hook.acceleration.y = hook_accel;
					hook.velocity.x = velocity.x * 3; 
					hook.velocity.y = velocity.y * 3;
					hook.x = x;
					hook.y = y;
					hook.state = s_hook_thrown;
					hook_notches.setAll("visible", true);
				}
			} else if (hook.state == s_hook_thrown) {
				if (velocity.x > 0) {
					hook.x += hook_pull_speed;
				} else if (velocity.x < 0) {
					hook.x += -hook_pull_speed;
				}
				if (hook.x > FlxG.width || hook.x + width < 0 || hook.y + hook.height > playstate.ground.y) {
					hook.state = s_hook_hidden;
					hook_notches.setAll("visible", false);
					hook.velocity.x = hook.velocity.y = 0;
					hook.acceleration.y = 0;
				}
				if (hook.overlaps(playstate.block)) {
					hook.velocity.x = hook.velocity.y = 0;
					hook.state = s_hook_attached;
					hook.acceleration.y = 0;
				}
			} else if (hook.state == s_hook_attached) {
				if (input.JP_A2) {
					hook.acceleration.y = hook_accel;
					hook.state = s_hook_hidden;	
					hook_notches.setAll("visible", false);
				}
			}
			
			var x_len:Number = ((hook.x + 5) - (x + player_hook_offset.x)) / (hook_notches.maxSize + 1);
			var y_len:Number = ((hook.y + 8) - (y + player_hook_offset.y)) / (hook_notches.maxSize + 1);
			
			
			for (var i:int = 0; i < hook_notches.maxSize; i++) {
				hook_notches.members[i].x = (x + player_hook_offset.x) + x_len * (i + 1);
				hook_notches.members[i].y = (y + player_hook_offset.y) + y_len * (i + 1);
			}
			
		}
		override public function draw():void 
		{
			
			super.draw();
		}
		
	}

}