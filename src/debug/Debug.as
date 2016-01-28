package debug
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.DateTimeStyle;
	import flash.globalization.LocaleID;

	/**
	 *
	 * @author Sebastian Erb
	 */
	public class Debug
	{
		/**
		 *
		 * @default
		 */
		public static const DEFAULT_FILENAME:String = "workertest.log";

		/**
		 *
		 * @default
		 */
		public static const THREAD_MAIN:String = "MAINTHREAD";

		/**
		 *
		 * @default
		 */
		public static const THREAD_WORKER:String = "WORKER";

		private static const DEBUG:Boolean = true;

		private static const DEBUG_DEEP:Boolean = true;

		private static var _instance:Debug;

		/**
		 *
		 * @return
		 */
		public static function getInstance():Debug
		{
			if(!_instance)
				_instance = new Debug();

			return _instance;
		}

		/**
		 *
		 */
		public static function initWorkerDebug():void
		{
			getInstance().thread = "WORKER";
		}

		/**
		 *
		 * @param args
		 */
		public static function addlog(... args):void
		{

			if(!DEBUG)
				return;

			var lineCall1:String = "";
			var lineCall2:String = "";
			var callerName1:String = "";
			var callerName2:String = "";
			var callerMethod1:String = "";
			var callerMethod2:String = "";

			var err:Error = new Error();
			var errStr:String = err.getStackTrace();
			var stacksArr:Array = errStr.split("\n");

			if(stacksArr.hasOwnProperty(2))
			{
				lineCall2 = stacksArr[2].slice(4, stacksArr[2].length);
				callerName2 = lineCall2.split("/")[0] + " ::: ";
				callerMethod2 = lineCall2.split("()")[0] + "() -> ";

				if(DEBUG_DEEP && stacksArr.hasOwnProperty(3))
				{
					lineCall1 = stacksArr[3].slice(4, stacksArr[3].length);
					callerName1 = lineCall1.split("/")[0] + " ::: ";
					callerMethod1 = lineCall1.split("()")[0] + "() -> ";
				}
			}

			var formatter:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT, DateTimeStyle.SHORT, DateTimeStyle.NONE);
			var formatstring:String = "dd.MM.yyyy HH:mm:ss";
			var logmessage:String;
			formatter.setDateTimePattern(formatstring);

			for(var i:uint = 0; i < args.length; i++)
			{
				logmessage = "[" + formatter.format(new Date()) + "] DEBUG ::: " + getInstance().thread + " ::: " + callerMethod1 + callerMethod2 + args[i].toString();
				trace(logmessage);
				getInstance().write(logmessage);
			}

		}

		/**
		 *
		 */
		public function Debug():void
		{

			log = File.documentsDirectory.resolvePath(DEFAULT_FILENAME);

		}

		/**
		 *
		 * @default
		 */
		private var log:File;

		/**
		 *
		 * @default
		 */
		private var thread:String = "MAIN";

		/**
		 *
		 * @param msg
		 */
		private function write(msg:String):void
		{
			if(!log)
				return;

			try
			{
				var fs:FileStream = new FileStream();
				fs.open(log, FileMode.APPEND);
				fs.writeUTFBytes(msg + File.lineEnding);
				fs.close();
			}
			catch(error:Error)
			{
				trace("ERROR with write");
			}
		}
	}
}
