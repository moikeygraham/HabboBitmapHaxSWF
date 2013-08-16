package crypto
{
	import flash.utils.ByteArray;
	
	public class SulakeArrayFunctions extends Object
	{
		public function SulakeArrayFunctions()
		{
			// ~constructor
		}
		
		public static function getDecodedSize(char:int) : int
		{
			var mod:int = char % 4;
			
			switch (mod)
			{
				case 0:
				{
					return char / 4 * 3;
				}
				case 2:
				{
					return (char - 2) / 4 * 3 + 1;
				}
				case 3:
				{
					return (char - 3) / 4 * 3 + 2;
				}
				default:
				{
					break;
				}
			}
			
			return 0;
		}
		
		public static function getEncodedSize(char:int) : int
		{
			var mod:int = char % 3;
			
			switch (mod)
			{
				case 0:
					return char / 3 * 4;
					
				case 1:
					return (char - 1) / 3 * 4 + 2;
					
				case 2:
					return (char - 2) / 3 * 4 + 3;
					
				default:
					break;
			}
			
			return 0;
		}
		
		public static function hexStringToByteArray(hex:String) : ByteArray
		{
			var local3:int = 0;
			var local4:int = 0;
			var local5:int = 0;
			var local6:int = 0;
			var result:ByteArray = new ByteArray();
			
			if (hex.length % 2 != 0)
			{
				hex = "0" + hex;
			}
			
			while (local3 < (hex.length - 1))
			{
				local4 = parseInt(hex.charAt(local3 + 0), 16);
				local5 = parseInt(hex.charAt((local3 + 1)), 16);
				
				local6 = local4 << 4 | local5;
				
				result.writeByte(local6);
				
				local3++;
				local3++;
			}
			
			return result;
		}
		
		public static function byteArrayToHexString(data:ByteArray, toUpper:Boolean = false) : String
		{
			var byte:uint = 0;
			var firstChar:uint = 0;
			var secondChar:uint = 0;
			var result:String = "";
			
			data.position = 0;
			
			while (data.bytesAvailable)
			{
				byte = data.readUnsignedByte();
				firstChar = byte >> 4;
				secondChar = byte & 15;
				
				result = result + firstChar.toString(16);
				result = result + secondChar.toString(16);
			}
			
			if (toUpper)
			{
				result = result.toUpperCase();
			}
			
			return result;
		}
		
		public static function stringToByteArray(data:String) : ByteArray
		{
			var result:ByteArray = new ByteArray();
			var iterator:int = 0;
			
			while (iterator < data.length)
			{
				result.writeByte(data.charCodeAt(iterator));
				iterator++;
			}
			
			result.position = 0;
			return result;
		}
		
		public static function byteArrayToString(data:ByteArray) : String
		{
			var result:String = "";
			
			data.position = 0;
			
			while (data.bytesAvailable)
			{
				result = result + String.fromCharCode(data.readByte());
			}
			
			return result;
		}
		
		public static function bigIntegerToRadix(data:ByteArray, radix:uint = 16) : String
		{
			return "";
		}
	}
}