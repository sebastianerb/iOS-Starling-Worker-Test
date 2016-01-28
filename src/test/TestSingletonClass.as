package test
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 *
	 * @author Sebastian Erb
	 */
	public class TestSingletonClass
	{

		private static var _instance:TestSingletonClass;

		/**
		 * ATTENTION: It is only possible to create one instance of this class in Mainthread or even
		 * in Worker!
		 *
		 * @return
		 */
		public static function getInstance():TestSingletonClass
		{
			if(!_instance)
				_instance = new TestSingletonClass();

			return _instance;
		}

		/**
		 *
		 */
		public function TestSingletonClass()
		{
			log = File.documentsDirectory.resolvePath("workertest.log");
		}

		public var thread:String = "MAIN";

		private var log:File;

		/**
		 *
		 * @param text
		 */
		public function writefiletest(text:String):void
		{
			var fs:FileStream = new FileStream();
			fs.open(log, FileMode.APPEND);
			fs.writeUTFBytes("TestSingletonClass.as ::: " + thread + " " + text + File.lineEnding);
			fs.close();
		}
	}
}
