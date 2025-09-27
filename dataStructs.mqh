#ifndef dataStructs
#define dataStructs

//input a defined length for char array
#define CHAR_FIELD_WIDTH 128 //leave name as is 


// test_news_large.tsv: DateTime, Char, Char, Char, Int, Int, Int
struct NEWS {
    datetime time;           // DateTime
    char event[CHAR_FIELD_WIDTH];     // Char
    char impact[CHAR_FIELD_WIDTH];     // Char
    char currency[CHAR_FIELD_WIDTH];   // Char
    int actual;             // Int
    int forecast;           // Int
    int previous;          // Int
};

// test_predictions.csv: DateTime, Char, Char, Doåuble, Double, Double, Double, Double, Double
struct HLC {
    datetime time;           // DateTime
    char currency[CHAR_FIELD_WIDTH];     // Char
    char timeframe[CHAR_FIELD_WIDTH];    // Char
    double predicted_high;   // Double
    double confidence_high;  // Double
    double predicted_low;    // Double
    double confidence_low;   // Double
    double predicted_close;  // Double
    double confidence_close; // Double
};

// test_ml_signals.csv: DateTime, Char, Char, Double, Double, Double, Double, Double, Double
struct TPSL {
    datetime time;           // DateTime
    char ml_model[CHAR_FIELD_WIDTH];     // Char
    char signal_type[CHAR_FIELD_WIDTH];   // Char
    double confidence;       // Double
    double risk_score;       // Double
    double probability;      // Double
    double price_target;     // Double
    double stop_loss;        // Double
    double take_profit;      // Double
};



#endif 



