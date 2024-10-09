## Contents:

1. [API](#api)
2. [Legend](#legend)
3. [Control Service](#control-service)
4. [Video Service](#video-service)
5. [Saving Service](#saving-service)

# API

## Format

### get

**Accepts** an array of property names. Requests are executed in the order in which they are listed.  
**Returns** an array of one element dictionaries. The key of each one element dictionary is the property name and the
value is the retrived value. The order of properties in the output array is the same as in the input array. Input and
output arrays are of the same size (if there are no errors).

### set

**Accepts** an array of one element dictionaries. The one element's key is the property name and the value is the value
to be set - "propertyName":\<value\>. Requests are executed in the order in which they are listed.  
**Returns** an array of one element dictionaries. The key of each one element dictionary is the property name and the
value is the retrived value. The order of properties in the output array is the same as in the input array. Input and
output arrays are of the same size (if there are no errors).

### range

**Accepts** an array of property names. Requests are executed in the order in which they are listed.  
**Returns** an array of one element dictionaries. The key of each one element dictionary is the property name and the
value is an array. The array is either:

- a two element array which gives an inclusive valid range for the value of the property
- a many element array which gives a list of all valid values.

The order of properties in the output array is the same as in the input array. Input and output arrays are of the same
size (if there are no errors).

### Exceptions

*Get/Set/Range* requests are executed until the first error - that means that no other property dictionaries are
returned after the one resulting in error (input and output arrays might not be the same size). In case of an error when
executing a *get/set/range* for a property, instead of a dictionary holding property name and retrived value, an error
dictionary is returned - the key is *'error'* and the value contains a descriptive message.

# Legend

`G` - `get` method can be called on this property.

`S` - `set` method can be called on this property.

`R` - `range` method can be called on this property and it returns a two element array representing the range of valid
values for this property.

`L` - `range` method can be called on this property and it returns a list (an array) of all valid values for this
property.

`N` - change to this property emits a notify event containing the name of the property. It might contain a name of a
different property. It might also not be emitted in all cases.

# Control Service

## Exposure Control Properties

| Property           | G | S | R | N                | Type   | Description                                                                                                                                                                                                                                                                                                                        |
|--------------------|---|---|---|------------------|--------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `exposurePeriod`   | G | S | R | N                | double | Exposure time in nanoseconds.<br/>All other exposure manipulating properties (`exposureFraction` and `shutterAngle`) are simply convenience wrappers around `exposurePeriod`. Minimum exposure period is dependent on the sensor, current resolution and current frame period. Maximum exposure period is dependent on the sensor. |
| `exposureFraction` | G | S | R | `exposurePeriod` | double | Exposure time expressed as a fraction of a second.<br/>Convenience property to set and read exposure period as a fraction of a second (1/50th, 1/200th, ...). Notify gives exposure time in nanoseconds.                                                                                                                           |
| `shutterAngle`     | G | S | R | `exposurePeriod` | double | Exposure time expressed as a shutter angle (0°-360°).<br/>Convenience property to set and read exposure period as a shutter angle relative to the frame period. The angle is expressed in thousandths of degrees. In theory it would go from 0 to 360000. Notify gives exposure time in nanoseconds.                               |

## ISO Control Properties

| Property      | G | S | R | N            | Type | Description                  |
|---------------|---|---|---|--------------|------|------------------------------|
| `currentIso`  | G | S | L | N            | int  | ISO value.                   |
| `currentGain` | G | S | L | `currentIso` | int  | ISO value expressed as gain. |

## Bit Depth

| Property   | G | S | R | N | Type | Description |
|------------|---|---|---|---|------|-------------|
| `bitDepth` | G | S | L | N | enum | Bit depth.  |

## FrameRate Control Properties

| Property      | G | S | R | N             | Type   | Description                                                                                                                                                                                                                                                                                              |
|---------------|---|---|---|---------------|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `framePeriod` | G | S | R | N             | double | Frame period time in nanoseconds.<br/>All other frame-rate manipulating properties (`frameRate`) are simply convenience wrappers around `framePeriod`. Minimum frame period is dependent on the sensor, current resolution and current exposure period. Maximum frame period is dependent on the sensor. |
| `frameRate`   | G | S | R | `framePeriod` | double | Frame time expressed as numbers of frames per second.<br/>Convenience property to set and read frame period as numbers of frames per second. Notify gives frame period in nanoseconds.                                                                                                                   |

## Resolution Properties

| Property      | G | S | R | N | Type | Description                                                                                      |
|---------------|---|---|---|---|------|--------------------------------------------------------------------------------------------------|
| `resolutionW` | G | S | R | N | int  | Horizontal resolution.<br/>Ranges returns bounds - not every value in that range might be valid. |
| `resolutionH` | G | S | R | N | int  | Vertical resolution.<br/>Ranges returns bounds - not every value in that range might be valid.   |

## WhiteBalance Configuration

| Property        | G | S | R | N | Type | Description                                                                                   |
|-----------------|---|---|---|---|------|-----------------------------------------------------------------------------------------------|
| `wbTemperature` | G | S | R | N | int  | Color temperature in Kelvins.                                                                 |
| `wbSource`      | G | S | L | N | enum | Selection of white balance source. Valid values:<br/>- wbTemperature<br/>- wbCustomColor<br/> |

| Method       | Input | Output | Description                                                                                         |
|--------------|-------|--------|-----------------------------------------------------------------------------------------------------|
| `estimateWB` |       | string | Estimates the white balance from a patch at the center of the image.                                |
| `wbPresets`  |       | dict   | Returns a dictionary of preset_name/temperature_in_K pairs that contains common color temperatures. |

## Sensor Configurationx

| Property              | G | S | R  | N | Type | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
|-----------------------|---|---|----|---|------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `sensorConfiguration` | G | S | RL | N | dict | Configure sensor - set sensor properties.<br/><br/>Set accepts a dictionary of:<br/>- exposurePeriod<br/>- framePeriod<br/>- iso<br/>- bitMode<br/>- resolutionW<br/>- resolutionH<br/><br/>Each property must appear exactly once. Only the base expression for each property can be used (for exposure that's exposurePeriod, not shutterAngle or exposureFraction). Get and range return dictionaries of values and ranges (respectively) for all the properties including all the expressions of properties (so exposurePeriod and exposureFraction and shutterAngle). Ranges depend on the sensor - they are maximum ranges supported for the sensor - not the current configuration. |

| Method                   | Input         | Output | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
|--------------------------|---------------|--------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `trySensorConfiguration` | array of dict | dict   | Validate sensor configuration.<br/><br/>Accepts an ordered list of sensor properties in the format "propertyName":\<value\>. The list doesn't have to contain all sensor properties (values of missing properties will be taken from the current sensor configuration) but it cannot contain more entries than there are sensor properties and it cannot contain duplicated entries (multiple expressions of the same property count as duplicates (so `exposurePeriod` and `shutterAngle` are duplicates)).<br/>The method examines the properties starting from the last one and tries to create a valid configuration. It returns an two-element dictionary: "get":dict, "range":dict. Both dictionaries (the one belonging to the "get" key and the one belonging to the "range" key) are of the same size and each entry represents a sensor property. Both dictionaries contain all the properties including all the expressions (so exposurePeriod and exposureFraction and shutterAngle). Each "get" dictionary entry is a pair "propertyName":\<value\> and each "range" dictionary entry is a pair "propertyName":\<range\>. If the requested property value is not valid for the current configuration "get" dictionary entry has the form "propertyName":{"error":\<Error_Description\>}. Note that if the requested configuration is valid, the returned get dictionary will be identical to a call to `sensorConfiguration` `get` but the returned range dictionary will not be identical to a call to `sensorConfiguration` `range`. This is because `range` will return valid ranges for the given configuration.<br/><br/>Note: this method is a read-only utility method, it makes no changes to the camera. |

## Record Mode Properties

| Property        | G | S | R | N | Type   | Description                                                  |
|-----------------|---|---|---|---|--------|--------------------------------------------------------------|
| `recMaxFrames`  | G | S | R | N | int    | Maximum number of frames that can be stored to memory.       |
| `recMaxSeconds` | G | S | R | N | double | Maximum record time in seconds that can be stored to memory. |

## Record Mode Methods

| Method                | Input | Output | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
|-----------------------|-------|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `estimateSegmentSize` | dict  | dict   | Get an estimate for the number of seconds (and number of frames) of record time available for a given sensor and installed memory. Input is a dictionary of the following keys:<br/>- resolutionW<br/>- resolutionH<br/>- framePeriod<br/>- bitMode<br/>- recMaxFrames (optional)<br/>- recMaxSeconds (optional)<br/>- recSegments (optional)<br/><br/>Returns a dictionary of `number_of_frames`, `max_number_of_frames` and `duration` (in seconds as float). The `number_of_frames` and `max_number_of_frames` will be the same when recMaxFrames is not provided.<br/><br/>If **recSegments** is provided the method also returns `number_of_frames_per_segment` and `segment_duration` (in seconds as float).<br/><br/>If **recMaxFrames** (or **recMaxSeconds**) is provided the total number of frames is ignored and **recMaxFrames** (or **recMaxSeconds**) is used as the number of frames in calculation of the estimate.<br/>Note, recMaxFrames must be smaller than max number of frames (recMaxSeconds must be smaller than max duration).<br/>Note, only one of **recMaxFrames** and **recMaxSeconds** can be provided, not both.<br/><br/>Note: this method is a read-only utility method, it makes no changes to the camera, it only calculates the estimates. |

## Utils Properties

| Property      | G | S | R | N | Type   | Description                                                                                                                                                                                                                                        |
|---------------|---|---|---|---|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `dateTime`    | G | S |   | N | string | ISO-8601 formatted string holding the current date and time.                                                                                                                                                                                       |
| `temperature` | G |   |   |   | dict   | Returns a dictionary:<br/> - key=cpu : value=\<string containing the temperature of the cpu in ℃ as a float\><br/> - key=sensor : value=\<string containing the temperature of the sensor in ℃ as a float or 'Off' if the sensor is powered down\> |

## Recording Property

| Property    | G | S | R | N | Type | Description                                                |
|-------------|---|---|---|---|------|------------------------------------------------------------|
| `recording` | G | S | R | N | bool | State of recording. Any of:<br/>- **true**<br/>- **false** |

## LCD Properties

| Property        | G | S | R | N | Type | Description                                      |
|-----------------|---|---|---|---|------|--------------------------------------------------|
| `lcdBrightness` | G | S | R |   | int  | Brightness of the LCD at the back of the camera. |

## Methods

| Method          | Input | Output        | Description                                                                                                                                             |
|-----------------|-------|---------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| `shutdown`      | enum  | string        | Shutdown/Reboot camera. Available modes are:<br/>- `Shutdown`<br/>- `Restart`                                                                           |
| `sensorPresets` |       | array of dict | Get sensor presets. Returns an array of dictionaries of:<br/>- resolutionW<br/>- resolutionH<br/>- bitMode<br/>- frameRate<br/>- shutterAngle<br/>- iso |

## Camera Info Properties

| Property                    | G | S | R | N | Type   | Description                                                     |
|-----------------------------|---|---|---|---|--------|-----------------------------------------------------------------|
| `cameraApiVersion`          | G |   |   |   | string | ??? The string "0.9" for this release of the API specification. |
| `cameraMemoryGB`            | G |   |   |   | float  | Amount of RAM installed, in units of `GiB`.                     |
| `cameraModel`               | G |   |   |   | string | Camera model number (eg: "CR14-1.0").                           |
| `cameraSerial`              | G |   |   |   | string | Camera unique serial number.                                    |
| `cameraHardwareRevision`    | G |   |   |   | string | Returns camera hardware revision.                               |
| `cameraSoftwareVersion`     | G |   |   |   | string | Returns camera software version.                                |
| `cameraPMICfirmwareVersion` | G |   |   |   | string | Returns camera PMIC firmware version.                           |
| `cameraNVMeSize`            | G |   |   |   | float  | Size of NVMe installed, in units of GiB.                        |

## Sensor Info Properties

| Property             | G | S | N | Type   | Description                                                                                                                                |
|----------------------|---|---|---|--------|--------------------------------------------------------------------------------------------------------------------------------------------|
| `sensorName`         | G |   |   | string | Descriptive string of the image sensor.                                                                                                    |
| `sensorColorPattern` | G |   |   | string | String of ‘R’ ‘G’ and ‘B’ that defines the color filter pattern in left-to-right and top-to-bottom order or ‘mono’ for monochrome sensors. |
| `sensorColorMono`    | G |   |   | string | String that defines the color capability of the sensor: 'color' or ‘mono’.                                                                 |
| `sensorPixelRate`    | G |   |   | double | Approximate pixel rate of the image sensor in pixels per second.                                                                           |
| `sensorVIncrement`   | G |   |   | int    | Minimum quantization of vertical resolutions.                                                                                              |
| `sensorHIncrement`   | G |   |   | int    | Minimum quantization of horizontal resolutions.                                                                                            |

## State

| Property        | G | S | N | Type | Description                                                                                                                             |
|-----------------|---|---|---|------|-----------------------------------------------------------------------------------------------------------------------------------------|
| `displaySource` | G | S | N | enum | Set display state. Options are:<br/>- none<br/>- live<br/>- playback_from_DDR<br/>- playback_from_file_dng<br/>- playback_from_file_vcu |

## Saving

| Method          | Input | Output | Description                                                                                                                                                                                                                                                    |
|-----------------|-------|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `startFileSave` | dict  | string | Starts the saving process. Assumes that all relevant saving properties have been set. The input is a dictionary of:<br/>- **start** \<int\><br/>- **length** \<int\><br/>- **segmentID** \<int\><br/>Returns **"ok"** on success or an error message on error. |

# Video Service

## Overlays Properties

| Property              | G | S | R | N | Type | Description                                                                      |
|-----------------------|---|---|---|---|------|----------------------------------------------------------------------------------|
| `overlayZebra`        | G | S |   |   | dict | Configure zebra overlay. Options are:<br/>- state - "enabled"/"disabled"         |
| `overlayHistogram`    | G | S |   |   | dict | Configure histogram overlay. Options are:<br/>- state - "enabled"/"disabled"     |
| `overlayFocusPeaking` | G | S |   |   | dict | Configure focus peaking overlay. Options are:<br/>- state - "enabled"/"disabled" |

## Playback Properties

| Property           | G | S | R | N  | Type | Description                                                                                                                                                                                                                                                                            |
|--------------------|---|---|---|----|------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `playbackRate`     | G | S | R | N  | int  | The playback rate in fps. It can be negative to play backward.                                                                                                                                                                                                                         |
| `playbackPosition` | G | S | R | N* | int  | The playback position in the current segment/file/sequence. Notifications are not emited while the video service is in the `playback` state. Range returns the length of the segment or file or image sequence. The playback position cannot be changed while playback is in progress. |
| `playbackStart`    | G | S | R | N  | int  | The start of the playback region in the current segment/file/sequence.                                                                                                                                                                                                                 |
| `playbackEnd`      | G | S | R | N  | int  | The end of the playback region in the current segment/file/sequence. The playback will loop to the **playbackStart** after reaching the **playbackEnd**.                                                                                                                               |
| `playbackSegment`  | G | S | R | N  | int  | Index of the current playback segment.                                                                                                                                                                                                                                                 |
| `playback`         | G | S | R | N  | bool | The current state of the video service. Options are:<br/>- **true** - playback is in progress<br/>- **false** - playback is paused                                                                                                                                                     |

# Saving Service

## File Save Properties

| Property         | G | S | R | N | Type   | Description                                                                                                                                                                                |
|------------------|---|---|---|---|--------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `saveFilePath`   | G | S |   | N | string | Destination file or directory to be written.                                                                                                                                               |
| `saveFileFormat` | G | S | R | N | enum   | The encoding to be used when saving the footage.                                                                                                                                           |
| `save`           | G | S | R | N | enum   | State of saving: Any of:<br/>- **isNotSaving**<br/>- **isSaving**<br/>Can only be set to **isNotSaving** to stop the ongoing saving process. To start the saving use **saveStart** method. |
| `saveProgress`   | G |   | R |   | int    | Get returns the number of the frame currently being saved. Range returns start and end of the range.                                                                                       |

