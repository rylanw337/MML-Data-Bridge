# MML Data Bridge - User Technical Specifications

## Overview
MML Data Bridge is a high-performance data integration system designed to efficiently bridge external CSV/TSV data with MetaTrader 5. The system uses optimized processing for speed, reliability, and memory efficiency.

## What You Need to Know

### Supported File Formats
- **CSV files** (comma-separated values)
- **TSV files** (tab-separated values)
- **DateTime format**: Must use ISO 8601 format (see examples below)
- **File location**: Place your files in MT5's Common Files directory

### CRITICAL: File Format Requirements
**CSV files**: Use exactly ONE comma (,) between each field
**TSV files**: Use exactly ONE tab character between each field
**DO NOT** use multiple delimiters for padding or alignment
**DO NOT** use spaces around delimiters

**Correct Format Examples:**
```
CSV: DateTime,Signal,Price,Volume,Currency
TSV: DateTime	Signal	Price	Volume	Currency

INCORRECT:
CSV: DateTime,,,Signal,,,Price,,,Volume,,,Currency
TSV: DateTime		Signal		Price		Volume		Currency
```

### Automatic Data Type Detection
The system automatically figures out what type of data each column contains:
- **Text** → Character type
- **Dates** → DateTime type  
- **Decimal numbers** → Double type
- **Whole numbers** → Integer type


```
EXAMPLE
Your data: "2025-05-26T05:30:00-04:00,100,3.14,USD"
System detects: DateTime, Integer, Double, Character
```

### Speed Benefits
- **3-5x faster** than reading CSV files directly
- **Optimized storage** for better performance
- **Efficient memory usage** for large datasets

## DateTime Format Requirements

### Required Format
Your datetime columns must use ISO 8601 format with timezone information:

**Supported Formats:**
- `2025-05-26T05:30:00Z` (UTC)
- `2025-05-26T05:30:00-04:00` (Eastern Time)
- `2025-05-26T05:30:00+05:30` (India Time)
- `2025-05-26T05:30:00-08:00` (Pacific Time)
- `2025-05-26T05:30:00+09:00` (Japan Time)

### Why Timezone Matters
- **Accurate Backtesting**: Your signals fire at the correct time in MT5's Strategy Tester
- **Live Trading Sync**: Real-time data matches market timing perfectly
- **Global Data**: Works with data from any timezone automatically
- **No Manual Work**: The system converts everything to UTC automatically

## API Reference

#### 1. Bridge Initialization
void initializeBridge(string eaName);
    **Purpose:** Initializes the MML Data Bridge system and creates binary cache files
    **Arguments:**  `eaName` (string) - Name of your Expert Advisor for folder organization
    **Returns:** void
    **Usage:** Call in OnInit() function

#### 2. Bridge Shutdown
void shutDownBridge();
    **Purpose:** Cleans up resources and closes file handles
    **Usage:** Call in OnDeinit() function

#### 3. Data Retrieval
template<typename T>
bool returnData(const string csvFileName, T &out);
    **Purpose:** Retrieves data records from binary cache
    **Arguments:**  `csvFileName` (string) - Name of the CSV/TSV file to read from
                    `out` (T&) - Reference to struct variable to populate with data
    **Returns:** bool - true if data is available, false otherwise
    **Usage:** Call in OnTick() or other functions to get data
    **Sample Output:**

```
EXAMPLE OUTPUT

NEWS DATA: 2025.01.01 08:30:00 | Event: Non-Farm Payrolls | Impact: High | Currency: USD | Actual: 200 | Forecast: 180 | Previous: 190
```
#### 4. String Conversion
string CharArrayToStr(char &arr[]);
    **Purpose:** Converts char arrays to readable strings for display
    **Arguments:**  `arr` (char[]) - Character array to convert
    **Returns:** string - Readable string representation
    **Usage:** Use when displaying text fields from data structures
    **Sample Output:**

```
EXAMPLE OUTPUT

"Non-Farm Payrolls"  // Converted from char array
```


## Setup and Configuration

### Two Operating Modes

**Development Mode** (`Verify Schema = True`):
- Use this when you're testing or changing your data files
- Automatically detects new files and data changes
- Slower but more flexible

**Production Mode** (`Verify Schema = False`):
- Use this for live trading or when your data is stable
- Much faster performance
- Prevents accidental changes to your data structure

### How Files Are Organized
```
Your EA Folder:
ES_final/
├── ES_final_config.ini    ← Your configuration file
├── ES_final_config.bin    ← System metadata
├── file1.bin              ← Your converted data
└── file2.bin              ← Your converted data
```

## Best Practices

### For Best Performance
1. **Use `Verify Schema = False`** for live trading (faster)
2. **Use `Verify Schema = True`** when testing or changing data
3. **Keep the binary files** - they make everything faster
4. **Monitor your file sizes** - very large files use more memory

### Preparing Your Data Files
1. **Use ISO 8601 datetime format** (see examples above)
2. **Make sure all rows have the same number of columns**
3. **Don't leave datetime cells empty**
4. **Use UTF-8 encoding** for best compatibility

## System Requirements

### Supported Platforms
- **MetaTrader 5**: All versions
- **Operating Systems**: Windows
- **File Systems**: NTFS, FAT32, ext4

### Data Requirements
- **File Formats**: CSV, TSV only
- **DateTime**: ISO 8601 format required
- **Encoding**: UTF-8 recommended
- **Size**: No practical limits

**CRITICAL: Single Delimiter Requirement**
- **CSV files**: Use exactly ONE comma (,) between each field
- **TSV files**: Use exactly ONE tab character between each field
- **DO NOT** use multiple delimiters for padding or alignment
- **DO NOT** use spaces around delimiters
- Multiple delimiters will cause incorrect field detection and schema errors

**Correct Format Examples:**
```
CSV: DateTime,Signal,Price,Volume,Currency
TSV: DateTime	Signal	Price	Volume	Currency

INCORRECT:
CSV: DateTime,,,Signal,,,Price,,,Volume,,,Currency
TSV: DateTime		Signal		Price		Volume		Currency
```

## Integration

### API Functions
```mql5
// Initialization
initializeBridge(string eaName);

// Data Retrieval
bool returnData<T>(string fileName, T &data);

// Cleanup
shutDownBridge();
```

### Data Structures
```mql5
// Example struct
struct MyData {
    datetime timestamp;
    int signal;
    double value;
    string symbol;
};
```

## Security & Reliability

### Data Protection
- **File Validation**: Strict format checking
- **Error Handling**: Robust error recovery
- **Memory Management**: Efficient resource usage
- **Data Integrity**: Validation at every step

### Performance Monitoring
- **File Modification**: Automatic detection
- **Schema Changes**: Validation and updates
- **Memory Usage**: Efficient allocation
- **Error Tracking**: Comprehensive logging

---

*This technical specification provides users with essential information for optimal MML Data Bridge usage while maintaining system security and performance.*
