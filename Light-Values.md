# Finding new Ligth values at determined exposure.

## S number.
The S number is the ratio between light samples used to record calibration footage.
 
 - The S number is calcualted by dividing nieghbouring levels (Level A)/(Level B).
 - Using S1 for 14 Light value samples between 0 and 371 we get Floor(371/13) -> [0, 29, 58, 87, ... , 348, 371].
 - Using S1.2 ...

## Important notes
 - Control service must be built with:
    1. Build from chronos5-control origin/next branch.
    2. Image height 2160px -> 2176px.
    3. No Dark Frame Subtraction.

## To find the dimmest channel
 - set LED to 371 (MAX led level).
 - Configure camera's bit depth to use 12 bit.
 - Configure camrea's gain to 0 (ISO 100).
 - Record ~30 frames of footage.
 - Compute mean using tool.
 - Tweak exposure until:
  - Dimmest channel is the one saturated at the lowest Exposure.
  - Other channels must be above their stated saturation levels.

**Ensure that the sensor is VERY clean.**

Exposure set to 44415ns for target value Red mean -> 3104.

| Channel   | Saturation                  |
|---------  |-----------------------------|
| Red       | 3104.20810626902944377436   |
| Green     | 3735.00000000000000000000   |
| Blue      | 2221.92341477743069372692   |

| Red        | Red Light Values  | Green       | Green Light Values | Blue         | Blue Light Values |
|:-----------|:-----------------:|:------------|:------------------:|:-------------|:-----------------:|
|133.1150063 |000                | 134.2815957 |000                 |131.6472873   |000                |
|140.7875158 |000                | 143.7039893 |000                 |137.1182182   |000                |
|152.2962799 |000                | 157.8375797 |000                 |145.3246146   |000                |
|169.5594262 |000                | 179.0379653 |000                 |157.6342092   |000                |
|195.4541456 |000                | 210.8385437 |000                 |176.0986011   |000                |
|234.2962247 |000                | 258.5394113 |000                 |203.795189    |000                |
|292.5593434 |000                | 330.0907127 |000                 |245.3400708   |000                |
|379.9540214 |000                | 437.4176648 |000                 |307.6573935   |000                |
|511.0460384 |000                | 598.408093  |000                 |401.1333775   |000                |
|707.684064  |000                | 839.8937352 |000                 |541.3473536   |000                |
|1002.641102 |000                | 1202.122199 |000                 |751.6683177   |000                |
|1445.07666  |000                | 1745.464894 |000                 |1067.149764   |000                |
|2108.729996 |                   | 2560.478936 |000                 |1540.371933   |000                |
|3104.21     |371                | 3783.000000 |000                 |2250.205187   |000                |

