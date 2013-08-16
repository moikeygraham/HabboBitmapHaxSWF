package crypto
{
	import com.hurlant.math.BigInteger;

	public class DiffieHellman
	{
		private var sharedKey:BigInteger;
		private var publicKey:BigInteger;
		
		private var prime:BigInteger;
		private var generator:BigInteger;
		private var secret:BigInteger;
		
		private var tmpSecret:BigInteger;
		
		public function DiffieHellman(p:BigInteger, g:BigInteger)
		{
			this.prime = p;
			this.generator = g;
		}
		
		public function init(bigjob:String, radix:uint = 16) : Boolean
		{
			this.secret = new BigInteger();
			this.secret.fromRadix(bigjob, radix);
			
			this.publicKey = this.generator.modPow(this.secret, this.prime);
			
			return true;
		}
		
		public function generateSharedKey(serverKey:String, radix:uint = 16) : String
		{
			this.tmpSecret = new BigInteger();
			this.tmpSecret.fromRadix(serverKey, radix);
			
			this.sharedKey = this.tmpSecret.modPow(this.secret, this.prime);
			
			return this.getSharedKey(radix);
		}
		
		
		public function getSharedKey(radix:uint = 16) : String
		{
			return this.sharedKey.toRadix(radix);
		}
		
		public function getPublicKey(radix:uint = 16) : String
		{
			return this.publicKey.toRadix(radix);
		}
	}
}