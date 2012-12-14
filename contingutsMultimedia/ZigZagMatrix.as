package contingutsMultimedia
{
   public class ZigZagMatrix{
 
      private var height:uint;
      private var width:uint;
      public var numSlices:uint;
      private var currentSlice:uint;
      private var _matrix:Array;

      public function ZigZagMatrix(matrix:Array){
         this.height = matrix[0].length;
         this.width = matrix.length;
         this.numSlices = this.height + this.width - 1;
         this.currentSlice = 0;
         this._matrix = matrix
      }

      public function getCurrentSlice(){
         //var sliceArray:Array = new Array();
         var z1:int = this.currentSlice < this.height ? 0 : this.currentSlice - this.height + 1;
         var z2:int = this.currentSlice < this.width ? 0 : this.currentSlice - this.width + 1;
         for(var i:int = this.currentSlice - z2; i >= z1; --i){
            //var it = this._matrix[i][this.currentSlice - i];
            this._matrix[i][this.currentSlice - i].animate();
            //sliceArray.push(it);
         }

         if(this.currentSlice < this.numSlices){
            this.currentSlice ++;
         }else{
            this.currentSlice = 0;
         }

         //return sliceArray;
      }  
   }  
}