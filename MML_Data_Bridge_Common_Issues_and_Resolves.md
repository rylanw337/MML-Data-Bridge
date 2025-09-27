# MML Data Bridge - Common Issues and Resolves

## Overview
This document addresses the most common issues users encounter when setting up and using MML Data Bridge, along with step-by-step solutions.

---

## Critical Issues

### 1. Struct Size Mismatch Error

**Error Message:**
```
MML Data Bridge: Struct size mismatch for 'filename.csv'
   Your struct is 404 bytes, but data file contains 528 bytes
   This means your struct is missing 1 field(s) or has incorrect field types
```

**Root Cause:**
- Your data struct doesn't match the schema detected in your data file
- Most commonly caused by incorrect delimiter usage in your CSV/TSV files
- Binaries might have been exported incorrectly

**Solution:**
1. **Check your data file format** - ensure single delimiters only
2. **Verify your struct definition** matches the detected schema
3. **Regenerate schema** by setting `Verify Schema = True` in config
4. **Check config file** for the correct field count and types

**Prevention:**
- Always use exactly ONE delimiter between fields
- Don't use multiple tabs or commas for padding, white spacing is OK!
- Test with small files first

---

### 2. Multiple Delimiter Issues

**Symptoms:**
- Schema detects more fields than expected
- Struct size mismatches
- Incorrect data parsing

**Root Cause:**
Using multiple delimiters (tabs or commas) for alignment/padding

**Examples:**
```
WRONG - Multiple tabs for alignment:
DateTime		Event		Impact		Currency		Actual		Forecast		Previous

CORRECT - Single tabs only:
DateTime	Event	Impact	Currency	Actual	Forecast	Previous
```

**Solution:**
1. **Recreate your data files** with single delimiters only
2. **Remove all padding** between fields
3. **Use proper CSV/TSV formatting**

**Tools to Fix:**
- Excel: Save as CSV/TSV (not "Formatted Text")
- Python: Use `csv.writer` with proper delimiter settings
- Text editors: Find and replace multiple delimiters with single ones

---

### 3. Schema Verification Issues

**Error Message:**
```
Schema verification enabled: no metadata found. Disable verification once to build registry/binaries, then re-enable.
```

**Root Cause:**
Schema verification is enabled but no metadata exists yet

**Solution:**
1. **Set `Verify Schema = True`** in your config file
2. **Run your EA once** to generate metadata and binaries
3. **Set `Verify Schema = False`** for production use

**Config File Example:**
```ini
[Settings]
Verify Schema = False
File1 = your_data.csv
```

---

## Common Issues

### 4. File Not Found Errors

**Error Message:**
```
MML Data Bridge: File 'filename.csv' not found in configuration
```

**Solution:**
1. **Check file location** - must be in Common Files directory
2. **Verify filename** in config file matches exactly
3. **Check file permissions** - ensure readable
4. **Verify file extension** - .csv or .tsv only

### 5. Timezone Conversion Problems

**Symptoms:**
- Data appears at wrong times in backtester
- Timezone offsets not handled correctly

**Solution:**
- Use proper ISO 8601 format with timezone: `2025-01-01T08:30:00-05:00`
- Avoid local time formats without timezone info
- Test with known timezone data first

**Supported Formats:**
```
2025-01-01T08:30:00Z (UTC)
2025-01-01T08:30:00-05:00 (EST)
2025-01-01T08:30:00+09:00 (JST)
```

### 6. DateTime Column Detection Issues

**Symptoms:**
- Expected datetime column shows up as Char[] in schema
- Time-based data comparison fails
- Program won't run or produces incorrect results
- Data appears at wrong times in backtester

**Root Cause:**
- DateTime column contains non-ISO 8601 format data
- Mixed data types in datetime column
- Missing timezone information in datetime values
- Invalid datetime format causing schema to classify as text

**Solution:**
1. **Use proper ISO 8601 format** - YYYY-MM-DDThh:mm:ssZ or YYYY-MM-DDThh:mm:ss±hh:mm
2. **Ensure timezone information** - all datetime values must have timezone
3. **Clean datetime data** - remove any non-standard formats
4. **Regenerate schema** after fixing datetime format
5. **Test with known timezone data** first

**Supported DateTime Formats:**
```
2025-01-01T08:30:00Z (UTC)
2025-01-01T08:30:00-05:00 (EST)
2025-01-01T08:30:00+09:00 (JST)
```

**NOT Supported:**
```
2025-01-01 08:30:00 (No timezone)
2025-01-01T08:30:00 (No timezone)
01/01/2025 08:30:00 (Wrong format)
```

### 7. Data Type Detection Issues

**Symptoms:**
- Numbers treated as text
- Dates not recognized
- Incorrect data types in schema

**Solution:**
1. **Clean your data** - remove non-numeric characters from number fields
2. **Use consistent date formats** - ISO 8601 only
3. **Check for mixed data types** in same column
4. **Regenerate schema** if data was updated

---

## Best Practices

### File Format Guidelines

**CSV Files:**
```
Correct:
DateTime,Signal,Price,Volume,Currency
2025-01-01T08:30:00Z,1,1.2345,1000,USD

Incorrect:
DateTime,,,Signal,,,Price,,,Volume,,,Currency
2025-01-01T08:30:00Z,,,1,,,1.2345,,,1000,,,USD
```

**TSV Files:**
```
Correct:
DateTime	Signal	Price	Volume	Currency
2025-01-01T08:30:00Z	1	1.2345	1000	USD

Incorrect:
DateTime		Signal		Price		Volume		Currency
2025-01-01T08:30:00Z		1		1.2345		1000		USD
```

### Development Workflow

1. **Start with small test files** (10-100 rows)
2. **Use `Verify Schema = False`** during development
3. **Test with known data** to verify correctness
4. **Switch to `Verify Schema = True`** for production
5. **Monitor logs** for any error messages

### Troubleshooting Steps

1. **Check config file** - verify all settings
2. **Verify file format** - single delimiters only
3. **Test with simple data** - minimal fields first
4. **Check struct definition** - match schema exactly
5. **Review error messages** - they provide specific guidance

---

## Getting Help

### Before Contacting Support

1. **Read this document** completely
2. **Check your file format** - single delimiters only
3. **Verify your struct** matches the schema
4. **Test with simple data** first
5. **Check the logs** for specific error messages

### Information to Provide

When seeking help, include:
- **Exact error message** from the logs
- **Your data file format** (first few rows)
- **Your struct definition**
- **Config file contents**
- **Steps you've already tried**


