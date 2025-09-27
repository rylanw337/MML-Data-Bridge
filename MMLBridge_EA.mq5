#property strict
#include <Trade/Trade.mqh>
#include <MMLUtility.mqh>
#include <dataStructs.mqh>

CTrade trade; // trade object

//+------------------------------------------------------------------+
//| Expert initialization                                            |
//+------------------------------------------------------------------+
int OnInit() {
   initializeBridge("ES_final");
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   shutDownBridge();
}

//Declare data structures for all test files
NEWS news;
HLC hlc;
TPSL tpsl;

//+------------------------------------------------------------------+
//| Expert tick                                                      |
//+------------------------------------------------------------------+
void OnTick() {

   // Check for news data
   if(returnData<NEWS>("ml_news_predictions.tsv", news)) {
      Print(" NEWS DATA: ", TimeToString(news.time, TIME_DATE|TIME_SECONDS),
            " | Event: ", CharArrayToStr(news.event),
            " | Impact: ", CharArrayToStr(news.impact),
            " | Currency: ", CharArrayToStr(news.currency),
            " | Actual: ", news.actual,
            " | Forecast: ", news.forecast,
            " | Previous: ", news.previous);
   }

   // Check for predictions data
   if(returnData<HLC>("ml_HLC_predictions.csv", hlc)) {
      Print("PREDICTIONS DATA: ", TimeToString(hlc.time, TIME_DATE|TIME_SECONDS),
            " | Currency: ", CharArrayToStr(hlc.currency),
            " | Timeframe: ", CharArrayToStr(hlc.timeframe),
            " | Predicted High: ", hlc.predicted_high, " (Confidence: ", hlc.confidence_high, ")",
            " | Predicted Low: ", hlc.predicted_low, " (Confidence: ", hlc.confidence_low, ")",
            " | Predicted Close: ", hlc.predicted_close, " (Confidence: ", hlc.confidence_close, ")");
   }

   // Check for ML signals data
   if(returnData<TPSL>("ml_SLTP_signals.csv", tpsl)) {
      Print("ML SIGNALS DATA: ", TimeToString(tpsl.time, TIME_DATE|TIME_SECONDS),
            " | Model: ", CharArrayToStr(tpsl.ml_model),
            " | Signal: ", CharArrayToStr(tpsl.signal_type),
            " | Confidence: ", tpsl.confidence,
            " | Risk Score: ", tpsl.risk_score,
            " | Probability: ", tpsl.probability,
            " | Price Target: ", tpsl.price_target,
            " | Stop Loss: ", tpsl.stop_loss,
            " | Take Profit: ", tpsl.take_profit);
   }     
}


