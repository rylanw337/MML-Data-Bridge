#ifndef dataStructs
#define dataStructs

//input a defined length for char array
#define CHAR_FIELD_WIDTH 128 //leave name as is 

//Schemas automatically generated inside config.ini 
struct NEWS {
    datetime time;
    char event[CHAR_FIELD_WIDTH];
    char impact[CHAR_FIELD_WIDTH];
    char currency[CHAR_FIELD_WIDTH];
    int actual;
    int forecast;
    int previous;
};

struct HLC {
    datetime time;
    char currency[CHAR_FIELD_WIDTH];
    char timeframe[CHAR_FIELD_WIDTH];
    double predicted_high;
    double confidence_high;
    double predicted_low;
    double confidence_low;
    double predicted_close;
    double confidence_close;
};

struct TPSL {
    datetime time;
    char ml_model[CHAR_FIELD_WIDTH];
    char signal_type[CHAR_FIELD_WIDTH];
    double confidence;
    double risk_score;
    double probability;
    double price_target;
    double stop_loss;
    double take_profit;
};



#endif 



