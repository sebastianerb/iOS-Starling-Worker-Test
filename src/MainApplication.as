package
{
	import feathers.controls.Drawers;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.Slide;
	import feathers.themes.MetalWorksMobileTheme;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import views.Start;

	/**
	 *
	 * @author Sebastian Erb
	 */
	public class MainApplication extends Sprite
	{

		/**
		 *
		 */
		public function MainApplication()
		{
			new MetalWorksMobileTheme();
			super();
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddetToStage);
		}

		private var _drawers:Drawers = new Drawers();

		private var _navigator:ScreenNavigator = new ScreenNavigator();

		private function onAddetToStage(p_event:starling.events.Event):void
		{
			//			CHouseThemeLoader.getInstance().initialize();

			_drawers.content = _navigator;
			_drawers.height = Starling.current.stage.stageHeight;
			_drawers.width = Starling.current.stage.stageWidth;

			_navigator.width = Starling.current.stage.stageWidth;
			_navigator.height = Starling.current.stage.stageHeight;
			_navigator.transition = Slide.createSlideLeftTransition();

			_navigator.addScreen("start", new ScreenNavigatorItem(Start));
			_navigator.showScreen("start");

			this.addChild(_drawers);

		}
	}
}
