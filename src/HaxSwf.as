package
{
	import bitmap.ExperimentalLoader;
	
	import com.hurlant.crypto.rsa.RSAKey;
	import com.hurlant.math.BigInteger;
	
	import crypto.*;
	
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	
	public class HaxSwf extends Sprite
	{
		public function HaxSwf()
		{
			ExternalInterface.addCallback("dataToken", dataToken);
			ExternalInterface.addCallback("serverKey", serverKey);
			ExternalInterface.addCallback("clientKey", clientKey);
		}
		
		private function dataToken(token:String) : void
		{
			// hotel#token#bannerloc
			var tmp:String = token;
			
			LemonEnvironment.hotel = tmp.split("#")[0];
			LemonEnvironment.token = tmp.split("#")[1];
			LemonEnvironment.bannerLoc = tmp.split("#")[2];
			
			LemonEnvironment.loader = new ExperimentalLoader();
		}
		
		private function serverKey(key:String) : void
		{
			LemonEnvironment.diffie.generateSharedKey(key, 10);
			var shared:String = LemonEnvironment.diffie.getSharedKey(16).toUpperCase();
			ExternalInterface.call("encKey", shared);
		}
		
		private function clientKey(key:String) : void
		{			
			LemonEnvironment.diffieDec.generateSharedKey(key, 10);
			var shared:String = LemonEnvironment.diffieDec.getSharedKey(16).toUpperCase();
			ExternalInterface.call("decKey", shared);
		}
	}
}