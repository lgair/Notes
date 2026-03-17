# Chronos 12 Platform Calibration Process

The Chronos 12 platform calibration process generates many intermediary files in the calibration file. For each 
configuration processed in calibration, there is a corresponding statistics file (.stats). There should be a 
total of [bit_depths]\*[gains]\*[exposures], which is -> 3\*5\*15 = 270 total
configurations (Febuary 17th 2026). Stats files contain all relevant statistics for a given configuration in
the filename `a[bit_depth]_g[gain]_e[exposure]`.

For each `.stats` file, there shall exist a corresponding `.model` file. For example, if there exists 
`a12_g3_e11.stats` as a file in the cached directory for a calibration, then it is implied a `a12_g3_e11.model` 
file exists in the directory of the model used for calibration. 
If there is no such corresponding file, then the analyze data tool should log a message accordingly.

## Inputs for the Analyze Data Tool

The `analyze_data` tool utilized in the calibration process expects two inputs:

1. The path to the cache directory for the current calibration that contains `.stats` files for the given camera undergoing configuration.
2. The path to the directory containing all `.model` files to check the stats for the calibration against.

## Structure of Statistics Files

The statistics files are comprised of 5 main stats:

- **Flat Frame Uniformity**, which itself contains 10 stat values. The ones we care about are:
  - Mean
  - 99.5%
  - 0.5%

- **Target [RBG] Values** (skipped)
- **Flat Frame Sequence Uniformity**, with three stats: Min, Avg, and Max.
- **Temporal Noise Std Dev**
- **Distribution Match**

For each statistical entry reviewed by the analyze data tool, there are 8 components. The first four components of 
an entry correspond to the top half of the sensor, and the latter four correspond to values in the bottom half.

## Expected Model Entries

The model that the stats are compared against is expected to contain the following 12 entries:

1. A mean corresponding to the flat frame average uniformity mean for the top half of the sensor.
2. A w corresponding to the expected range for the flat frame average uniformity mean for the top half of the sensor.
3. A mean corresponding to the flat frame average uniformity mean for the bottom half of the sensor.
4. A w corresponding to the expected range for the flat frame average uniformity mean for the bottom half of the sensor.
5. A w for the 0.5% value of the flat frame average uniformity in the top half of the sensor.
6. A w for the 0.5% value of the flat frame average uniformity in the bottom half of the sensor.
7. A w for the 99.5% value of the flat frame average uniformity in the top half of the sensor.
8. A w for the 99.5% value of the flat frame average uniformity in the bottom half of the sensor.
9. A w for the temporal noise standard deviation in the top half of the sensor.
10. A w for the temporal noise standard deviation in the bottom half of the sensor.
11. A w for the distribution match error in the top half of the sensor.
12. A w for the distribution match error in the bottom half of the sensor.

Model files should follow the same order, with each line (row) representing an entry.

## Example Model File

An example `.model` file could look like this:

```
a12_g3_e11.model

ff_upper_mean=167
ff_upper_w=200
ff_lower_mean=1600
ff_lower_w=150
ff_0_5_upper_w=1578.26
ff_0_5_lower_w=
ff_99_5_upper_w=1781.45
ff_99_5_lower_w=1781.42
std_dev_upper_w=27.4964
std_dev_lower_w=27.4983
upper_error_w=0.004886702
lower_error_w=0.004819812
```

## Conditions for Analyze Data Tool

The `analyze_data` tool processes the generated stats against the expected values and their acceptable range from the 
model file for the configuration. The conditions are as follows:

- FF average uniformity mean is further than w from expected value (mean < expected-w or mean > expected+w) for both top and bottom halves of the sensor.
- FF average uniformity 0.5% is below w (0.5% < w) for both the top and bottom halves of the sensor.
- FF average uniformity 99.5% is above w (99.5% > w) for both the top and bottom halves of the sensor.
- Temporal noise standard deviation is above w (std > w) for both the top and bottom halves of the sensor.
- Distribution match error is above w (error > w) for both the top and bottom halves of the sensor.

If any of the values in the statistics file don't match any of the above conditions, the tool outputs a log message containing:

1. The configuration was outside the expected model values.
2. The actual vs expected value that triggered the error.
3. A coherent message tying this info together so the end user can either abort or continue calibration.

When a calibration aligns with the model data there should be no messages
logged by the analyze data tool.
