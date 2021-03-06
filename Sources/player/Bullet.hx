package player;

import kala.behaviors.collision.basic.Collider;
import kala.behaviors.collision.basic.shapes.CollisionRectangle;
import kala.objects.group.Group;
import kala.objects.sprite.Sprite;
import kha.FastFloat;
import states.PlayState;

class Bullet extends Sprite {
	
	#if (cap_30 && !debug)
	static inline var haccelUpdateFactor = 0.35;
	static inline var vaccel = -1.2;
	static inline var scaleSpeed = 0.2;
	#else
	static inline var haccelUpdateFactor = 0.7;
	static inline var vaccel = -0.3;
	static inline var scaleSpeed = 0.1;
	#end
	
	//

	public static var mainGroup:Group<Bullet> = new Group<Bullet>(false, function() return new Bullet());
	public static var minionGroup:Group<Bullet> = new Group<Bullet>(false, function() { 
		var bullet = new Bullet();
		bullet.hspeed = 0;
		bullet.haccel = 0;
		return bullet;
	});
	
	public static inline function shoot1(x:FastFloat, haccel:FastFloat, vspeed:FastFloat):Void {
		var bullet = create(mainGroup, x);
		bullet.y = 360;
		bullet.scale.setXY(2, 2);
		bullet.hspeed = 0;
		#if (cap_30 && !debug)
		bullet.haccel = haccel;
		bullet.vspeed = vspeed;
		#else
		bullet.haccel = haccel / 4;
		bullet.vspeed = vspeed / 2;
		#end
	}
	
	public static inline function shoot2(x:FastFloat):Void {
		var bullet = create(minionGroup, x);
		bullet.y = 425;
		#if (cap_30 && !debug)
		bullet.vspeed = -16;
		#else
		bullet.vspeed = -8;
		#end
	}
	
	static inline function create(group:Group<Bullet>, x:FastFloat):Bullet {
		var bullet = group.createAlive();
		bullet.x = x;
		return bullet;
	}
	
	//
	
	public var vspeed:FastFloat;
	var hspeed:FastFloat;
	var haccel:FastFloat;
	
	public var mask:CollisionRectangle;
	var collider:Collider;
	
	
	public function new() {
		super();
		loadSpriteData(R.playerBullet);
		scale.ox = position.ox = width / 2;
		scale.oy = position.oy = height / 2;
	
		collider = new Collider(this);
		mask = collider.addRect(width / 2 - 1, height / 2 - 10, 4, 16);
	}
	
	override public function update(elapsed:FastFloat):Void {
		if (scale.x > 1) scale.y = scale.x -= scaleSpeed;

		x += hspeed;
		y += vspeed;
		
		if (y < -height) {
			kill();
			return;
		}
		
		hspeed += haccel;
		vspeed += vaccel;
		haccel *= haccelUpdateFactor;
	}
	
}