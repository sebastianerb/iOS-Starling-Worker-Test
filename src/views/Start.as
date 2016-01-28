package views
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import debug.Debug;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;

	/**
	 *
	 * @author Sebastian Erb
	 */
	public class Start extends PanelScreen
	{

		/**
		 *
		 */
		public function Start()
		{
			super();
			init();
		}

		/**
		 *
		 * @default
		 */
		public var bm:MessageChannel;

		/**
		 *
		 * @default
		 */
		public var file:File;

		/**
		 *
		 * @default
		 */
		public var mb:MessageChannel;

		/**
		 *
		 * @default
		 */
		public var memory:ByteArray = new ByteArray();

		/**
		 *
		 * @default
		 */
		public var my_loader:URLLoader;

		/**
		 *
		 * @default
		 */
		public var worker:Worker;

		private var _label:Label = new Label();

		private var _prog:Number = 0;

		private function get getRandomJump():Number
		{
			var max:int = 10;
			var min:int = 1;
			var rand:Number = ((Math.random() * (max - min)) - min);

			if(rand < 0)
				rand *= -1;

			return rand;
		}

		private function init(p_event:* = null):void
		{

			//
			// Using the following lines will crash the worker!
			// It is only possible to create one instance of this class in Mainthread or even in Worker!
			//
			// there is another call in line: 172, you have to uncomment it for testing.
			/*
			   TestSingletonClass.getInstance().thread = "MAINTHREAD";
			 */

			_label.text = "label";

			this.addChild(_label);

			var _urlRequest:URLRequest = new URLRequest("BackWorker.swf");
			var _loader:Loader = new Loader();
			var _lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_loader.load(_urlRequest, _lc);

		}

		/**
		 *
		 * @param e
		 */
		public function completeHandler(e:Event):void
		{

			worker = WorkerDomain.current.createWorker(e.target.bytes, true);
			bm = worker.createMessageChannel(Worker.current);
			mb = Worker.current.createMessageChannel(worker);

			worker.setSharedProperty("btm", bm);
			worker.setSharedProperty("mtb", mb);

			bm.addEventListener(Event.CHANNEL_MESSAGE, onBackToMain);

			worker.start();
			bm.receive(true);

			_prog = 0;

			var obj2:Object = {"type": "start"}
			mb.send(obj2);
		}

		/**
		 *
		 * @param e
		 */
		public function errorHandler(e:IOErrorEvent):void
		{
			Debug.addlog("In IO ErrorEvent Handler");
		}

		/**
		 *
		 * @param event
		 */
		public function onBackToMain(event:Event):void
		{

			Debug.addlog("onBackToMain: " + event.toString());

			if(bm.messageAvailable)
			{
				var obj:Object = bm.receive();

				if(obj.hasOwnProperty("type"))
					switch(obj.type)
					{
						case "error":
							Debug.addlog("error: " + obj.error);
							break;
						case "file":
							Debug.addlog("file nativePath: " + obj.nativePath);
							Debug.addlog("file name: " + obj.name);
							break;
						case "progress":
							_prog = obj.progress;
							Debug.addlog("progress: " + _prog.toString());
							//							tc.writefiletest(_prog.toString());
							_label.text = _prog.toString();
							break;
					}

				this.invalidate();

			}
		}
	}
}
