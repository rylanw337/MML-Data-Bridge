#property strict
#include <dataStructs.mqh>


// Make sure this matches the .ex5 name in MQL5/Libraries
#import "MMLDataBridge.ex5"
  // These exactly match your exported functions:
  void initializeBridge_internal(string eaName);  
  void shutdownBridge_internal();  // 
 bool getRecordBytes_internal(const string csvFileName, uchar &out[]); // exported above
  string CStrFromCharArray(const char &arr[], int max_len = CHAR_FIELD_WIDTH);
#import



// ---- Public API #1b: initializeBridge(eaName) ----
void initializeBridge(string eaName){
 initializeBridge_internal(eaName);
}

// ---- Public API #2: shutDownBridge() ----
void shutDownBridge() { 
  shutdownBridge_internal();
}

// ---- Public API #3: CharArrayToStr() ----
string CharArrayToStr(char &arr[]) { 
  return CStrFromCharArray(arr); }

// ---- Public API #4: returnData<T>() ----
// Pull raw bytes from the bridge and map them into a POD struct T.
// Templated wrapper that preserves your original returnData signature
template<typename T>
bool returnData(const string csvFileName, T &out)
{
   // Ask bridge for the raw bytes (bridge will size 'bytes' correctly)
   uchar bytes[];
   if (!getRecordBytes_internal(csvFileName, bytes))
      return false;

   const int need = sizeof(out);
   const int have = ArraySize(bytes);

   if (have != need) {
      if (have > need) {
         PrintFormat("MML Data Bridge: Struct size mismatch for '%s'", csvFileName);
         PrintFormat("   Your struct is %d bytes, but data file contains %d bytes", need, have);
         PrintFormat("   This means your struct is missing %d field(s) or has incorrect field types", (have - need) / 128);
         PrintFormat("   Solution: Add missing field(s) to your struct or check field data types");
         PrintFormat("   Expected fields based on schema: Check your config file for the correct field count");
         // If BIN has more bytes than struct, we can safely copy only the front 'need' bytes.
         uchar tmp[]; ArrayResize(tmp, need);
         ArrayCopy(tmp, bytes, 0, 0, need);
         return CharArrayToStruct(out, tmp, 0);
      } else {
         PrintFormat("MML Data Bridge: Struct size mismatch for '%s'", csvFileName);
         PrintFormat("   Your struct is %d bytes, but data file contains %d bytes", need, have);
         PrintFormat("   This means your struct has %d extra field(s) or incorrect field types", (need - have) / 128);
         PrintFormat("   Solution: Remove extra field(s) from your struct or check field data types");
         PrintFormat("   Expected fields based on schema: Check your config file for the correct field count");
         // If BIN has fewer bytes than struct, we can't fill it -> fail.
         return false;
      }
   }

   // Correct order: struct first, bytes second
   return CharArrayToStruct(out, bytes, 0);
}

