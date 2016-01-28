package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import test.TestSingletonClass;

	/**
	 *
	 * @author Sebastian Erb
	 */
	public class BackWorker extends Sprite
	{

		/**
		 *
		 */
		public function BackWorker()
		{
			memory = new ByteArray();
			super();

			TestSingletonClass.getInstance().thread = "WORKER";

			if(!Worker.current.isPrimordial)
			{
				memory.shareable = true;
				bm = Worker.current.getSharedProperty("btm");
				mb = Worker.current.getSharedProperty("mtb");
				mb.addEventListener("channelMessage", onMainToBack);
				bm.send(memory);
			}
		}

		private var bm:MessageChannel;

		private var mb:MessageChannel;

		private var memory:ByteArray;

		/**
		 *
		 * @param event
		 */
		protected function onMainToBack(event:Event):void
		{

			var data:Object = mb.receive();

			if(!data.hasOwnProperty("type"))
				return;

			switch(data.type)
			{

				case "start":

					var i:* = undefined;
					var startTime:* = undefined;
					var progress:* = NaN;
					var j:Number = 1;

					try
					{
						var file:File = File.documentsDirectory.resolvePath("workertest.log");
						var f:Object = new Object();
						f.type = "file";
						f.nativePath = file.nativePath;
						f.name = file.name;
						bm.send(f);
					}
					catch(error:Error)
					{
						var err:Object = new Object();
						err.type = "error";
						err.error = error.message;
						bm.send(err);
					}

					var pr:Object = new Object();
					while(j < 10000)
					{
						i = 0;

						while(i < 100)
						{
							i++;
						}
						startTime = getTimer();

						while(getTimer() - startTime < 100)
						{
						}
						progress = 100 * j / 10000;

						pr = new Object();
						pr.type = "progress";
						pr.progress = progress;
						bm.send(pr);

						var fs:FileStream = new FileStream();
						fs.open(file, FileMode.APPEND);
						fs.writeUTFBytes("progress: " + progress + File.lineEnding);
						fs.close();

						TestSingletonClass.getInstance().writefiletest(progress);
						j++;
					}

					progress = 100;
					bm.send(progress);
					break;

			}

		}
	}
}
