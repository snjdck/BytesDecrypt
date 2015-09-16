package
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import snjdck.flascc.decryptBytes;
	
	public class Shell extends Sprite
	{
		private var fileLdr:URLLoader;
		private var ldr:Loader;
		
		public function Shell()
		{
			var path:String = getSourcePath();
			if(path != null){
				load(path);
			}
		}
		
		private function getSourcePath():String
		{
			for(var key:String in loaderInfo.parameters){
				return key;
			}
			return null;
		}
		
		public function load(path:String):void
		{
			fileLdr = new URLLoader();
			fileLdr.addEventListener(Event.COMPLETE, __onFileLoad);
			fileLdr.dataFormat = URLLoaderDataFormat.BINARY;
			fileLdr.load(new URLRequest(path));
		}
		
		private function __onFileLoad(evt:Event):void
		{
			loadBytes(fileLdr.data);
			fileLdr.removeEventListener(Event.COMPLETE, __onFileLoad);
			fileLdr = null;
		}
		
		public function loadBytes(ba:ByteArray):void
		{
			decryptBytes(ba);
			
			ldr = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, __onLoad);
			var context:LoaderContext = new LoaderContext();
			if(context.hasOwnProperty("allowLoadBytesCodeExecution")){
				context.allowLoadBytesCodeExecution = true;
			}
			ldr.loadBytes(ba, context);
			
			ba.clear();
		}
		
		private function __onLoad(evt:Event):void
		{
			var content:DisplayObject = ldr.content;
			
			ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, __onLoad);
			ldr.unload();
			ldr = null;
			
			stage.addChild(content);
			stage.removeChild(this);
		}
	}
}