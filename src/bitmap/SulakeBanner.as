package bitmap
{
	import com.hurlant.crypto.rsa.RSAKey;
	import com.hurlant.math.BigInteger;
	
	import crypto.*;
	
	import flash.display.BitmapData;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	public class SulakeBanner
	{
		private var token:String = "";
		
		private var bannerData:BitmapData;
		private var bannerPixels:ByteArray;
		
		private var decodeRes:String = "";
		private var xorRes:String = "";
		
		private var primeLen:int = 0;
		private var generatorLen:int = 0;
		
		private var primeStr:String = "";
		private var generatorStr:String = "";
		
		private var prime:BigInteger;
		private var generator:BigInteger;
		
		private var oldRandSecret:String = "";
		
		public function SulakeBanner(t:String)
		{
			this.token = t;
			this.bannerData = LemonEnvironment.bannerImg.bitmapData;
			this.bannerPixels = this.bannerData.getPixels(this.bannerData.rect);
		}
		
		public function CalculateKeys() : void
		{
			this.decodeRes = this.decode(this.bannerPixels, this.bannerData.width,
				4, new Point(4, 39), new Point(80, 30));
			
			this.xorRes = this.xor(this.decodeRes, this.token);
			
			this.primeLen = this.xorRes.charCodeAt(0);
			this.generatorLen = this.xorRes.charCodeAt(this.primeLen + 1);
			
			this.primeStr = this.xorRes.substr(1, this.primeLen);
			this.generatorStr = this.xorRes.substr(this.primeLen + 2, this.generatorLen);
			
			this.prime = new BigInteger();
			this.prime.fromRadix(this.primeStr, 10);
			this.generator = new BigInteger();
			this.generator.fromRadix(this.generatorStr, 10);
			// Enc Diffie
			LemonEnvironment.diffie = new DiffieHellman(this.prime, this.generator);
			this.generateSecret(false);
			
			// Dec Diffie
			LemonEnvironment.diffieDec = new DiffieHellman(this.prime, this.generator);		
			this.generateSecret(true);
			
			// BELOW IS THE RSA IMPLEMENTATION THAT I'VE COMMENTED OUT!
			/*
			var src:ByteArray = new ByteArray();
			var dest:ByteArray = new ByteArray();
			src.writeMultiByte(LemonEnvironment.publicKey, "iso-8859-1");
			
			var rsa:RSAKey = RSAKey.parsePublicKey("90e0d43db75b5b8ffc8a77e31cc9758fa43fe69f14184bef64e61574beb18fac" + "32520566f6483b246ddc3c991cb366bae975a6f6b733fd9570e8e72efc1e511f" + "f6e2bcac49bf9237222d7c2bf306300d4dfc37113bcc84fa4401c9e4f2b4c41a" + "de9654ef00bd592944838fae21a05ea59fecc961766740c82d84f4299dfb33dd", "3");
			rsa.encrypt(src, dest, src.length);
			rsa.dispose();
			
			LemonEnvironment.publicKey = toCipher.toString();*/
			
			ExternalInterface.call("toSend", LemonEnvironment.publicKey, LemonEnvironment.decPublicKey);
		}
		
		protected function decode(pixels:ByteArray, width:uint, startPos:uint, area1:Point, area2:Point) : String
		{
			var row:int = 0;
			var pos:uint = 0;
			var rowPos:int = 0;
			
			var byte:uint = 0;
			var mask:uint = 0;
			
			var result:String = "";
			
			var len:uint = 0;
			var buffer:uint = 0;
			
			var curRow:uint = 0;
			
			var start:uint = 0;
			
			if (startPos == 4)
			{
				start = 1;
			}
			
			for (var y:int = area1.y; y < area1.y + area2.y; y++)
			{
				for (row = area1.x; row < area1.x + area2.x; row++)
				{
					pos = ((y + curRow) * width + row) * startPos;
					rowPos = start;
					
					while (rowPos < startPos)
					{
						pixels.position = pos + rowPos;
						byte = pixels.readUnsignedByte();
						mask = byte & 1;
						buffer = buffer | mask << 7 - len;
						
						if (len == 7)
						{
							result = result + String.fromCharCode(buffer);
							buffer = 0;
							len = 0;
						}
						else
						{
							len = len + 1;
						}
						rowPos++;
					}
					
					if (row % 2 == 0)
					{
						curRow = curRow + 1;
					}
				}
				
				curRow = 0;
			}
			
			return result;
		}
		
		protected function xor(decoded:String, token:String) : String
		{
			var decodeChar:uint = 0;
			var result:String = "";
			var tokenCheck:int = 0;
			var iteration:int = 0;
			
			for (iteration = 0; iteration < decoded.length; iteration++)
			{
				decodeChar = decoded.charCodeAt(iteration);
				result = result + String.fromCharCode(decodeChar ^ token.charCodeAt(tokenCheck));
				tokenCheck++;
				
				if (tokenCheck == token.length)
				{
					tokenCheck = 0;
				}
			}
			
			return result;
		}
		
		protected function generateSecret(isDec:Boolean) : void
		{
			var secretLen:int = 10;
			var randStr:String = null;
			var tFinal:String = null;
			var dhPublic:String = null;
			
			while (secretLen > 0)
			{
				randStr = this.generateRandomHexString(30);
				
				if(isDec == true){
					LemonEnvironment.diffieDec.init(randStr);
					dhPublic = LemonEnvironment.diffieDec.getPublicKey(10);
				}
				else
				{
					LemonEnvironment.diffie.init(randStr);
					dhPublic = LemonEnvironment.diffie.getPublicKey(10);
				}
			
				
				if (dhPublic.length < 64)
				{
					if (tFinal == null || dhPublic.length > tFinal.length)
					{
						// Will always be true...
						tFinal = dhPublic;
						this.oldRandSecret = randStr;
					}
				}
				else
				{
					tFinal = dhPublic;
					this.oldRandSecret = randStr;
					break;
				}
				
				secretLen = secretLen - 1;
			}
			
			if (randStr != this.oldRandSecret)
			{
				if(isDec == true){
				LemonEnvironment.diffieDec.init(this.oldRandSecret);
					}
					else{
						LemonEnvironment.diffie.init(this.oldRandSecret);
					}
			}
			
			if(isDec == true){
			LemonEnvironment.decPublicKey = tFinal;
			}else{
				LemonEnvironment.publicKey = tFinal;
			}
		}
		
		protected function generateRandomHexString(len:uint = 16) : String
		{
			var rand:uint = 0;
			var result:String = "";
			
			for (var i:int = 0; i < len; i++)
			{
				rand = uint(Math.random() * 255);
				result = result + rand.toString(16);
			}
			
			return result;
		}
	}
}