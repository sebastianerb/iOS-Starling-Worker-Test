package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.Worker;
	import debug.Debug;
	import starling.core.Starling;
	import starling.textures.RenderTexture;
	import starling.utils.HAlign;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.SystemUtil;
	import starling.utils.VAlign;

	/**
	 *
	 * @author Sebastian Erb
	 */
	public class iOSWorkerStarling extends Sprite
	{
		/**
		 *
		 */
		public function iOSWorkerStarling()
		{
			super();

			var iOS:Boolean = SystemUtil.platform == "IOS";
			var stageSize:Rectangle = new Rectangle(0, 0, StageWidth, StageHeight);
			var screenSize:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			var viewPort:Rectangle = RectangleUtil.fit(stageSize, screenSize, ScaleMode.SHOW_ALL);
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2;

			Debug.addlog("+++ [initWorker] -> Worker.isSupported: " + Worker.isSupported);
			Debug.addlog("+++ [initWorker] -> Worker.current.isPrimordial: " + Worker.current.isPrimordial);

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			Starling.handleLostContext = true;
			RenderTexture.optimizePersistentBuffers = iOS;

			_starling = new Starling(MainApplication, stage, viewPort, null, Context3DRenderMode.AUTO, Context3DProfile.BASELINE);
			_starling.stage.stageWidth = StageWidth;
			_starling.stage.stageHeight = StageHeight;
			_starling.antiAliasing = 1;
			_starling.showStats = true;
			_starling.supportHighResolutions = true;
			_starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
			_starling.enableErrorChecking = Capabilities.isDebugger;
			_starling.start();
		}

		/**
		 *
		 * @default 480
		 */
		private const StageHeight:int = 480;

		/**
		 *
		 * @default 320
		 */
		private const StageWidth:int = 320;

		private var _starling:Starling;
	}
}
