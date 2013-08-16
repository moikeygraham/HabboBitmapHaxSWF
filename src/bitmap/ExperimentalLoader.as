package bitmap
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	

	public class ExperimentalLoader
	{
		private var load:Loader;
		
		public function ExperimentalLoader()
		{
			load = new Loader();
			load.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			
			//var url:URLRequest = new URLRequest("http://hotel-" + LemonEnvironment.hotel + ".habbo.com/gamedata/banner?token=" + LemonEnvironment.token);
			var url:URLRequest = new URLRequest(LemonEnvironment.bannerLoc);
			load.load(url);
		}
		
		private function loaded(event:Event) : void
		{
			var tmp:Bitmap = Bitmap(load.content);
			
			LemonEnvironment.bannerImg = tmp;

			LemonEnvironment.sulake = new SulakeBanner(LemonEnvironment.token);
			LemonEnvironment.sulake.CalculateKeys();
		}
	}
}