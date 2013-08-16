package 
{
	import bitmap.ExperimentalLoader;
	import bitmap.SulakeBanner;
	
	import crypto.DiffieHellman;
	
	import flash.display.Bitmap;

	public class LemonEnvironment
	{
		public static var diffie:DiffieHellman;
		public static var diffieDec:DiffieHellman;
		public static var sulake:SulakeBanner;
		public static var loader:ExperimentalLoader;
		
		public static var bannerImg:Bitmap;
		public static var token:String = null;
		public static var hotel:String = null;
		
		public static var serverKey:String = null;
		public static var publicKey:String = null;
		public static var decPublicKey:String = null;
		public static var toSendKey:String = null;
		
		public static var bannerLoc:String = null;
	}
}