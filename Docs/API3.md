## Contents:
1. [Properties](#properties)
   1. [Legend](#legend)
   2. [Format](#format)
   3. [Exceptions](#exceptions)
2. [Sensor](#sensor)
3. [Record](#record)
4. [Trigger](#trigger)
5. [White Balance](#white-balance)
6. [Utils](#utils)
7. [Info](#info)
8. [State](#state)
9. [Playback](#playback)
10. [Saving](#saving)
11. [Text Overlays](#text-overlays)
12. [Assistive overlays](#assistive-overlays)
13. [Storage](#storage)

# Properties

## Legend
`G` - `get` method can be called on this property.

`S` - `set` method can be called on this property.

`R` - `range` method can be called on this property and it returns a two element array representing the range of valid values for this property.

`L` - `range` method can be called on this property and it returns a list (an array) of all valid values for this property.

`N` - change to this property emits a notify event containing the name of the property. It might contain a name of a different property. It might also not be emitted in all cases.

## Format

### get

**Accepts** an array of property names. Requests are executed in the order in which they are listed.  
**Returns** an array of one element dictionaries. The key of each one element dictionary is the property name and the value is the retrived value. The order of properties in the output array is the same as in the input array. Input and output arrays are of the same size (if there are no errors).

### set

**Accepts** an array of one element dictionaries. The one element's key is the property name and the value is the value to be set - "propertyName":\<value\>. Requests are executed in the order in which they are listed.  
**Returns** an array of one element dictionaries. The key of each one element dictionary is the property name and the value is the retrived value. The order of properties in the output array is the same as in the input array. Input and output arrays are of the same size (if there are no errors).

### range

**Accepts** an array of property names. Requests are executed in the order in which they are listed.  
**Returns** an array of one element dictionaries. The key of each one element dictionary is the property name and the value is an array. The array is either:
- a two element array which gives an inclusive valid range for the value of the property
- a many element array which gives a list of all valid values.

The order of properties in the output array is the same as in the input array. Input and output arrays are of the same size (if there are no errors).

## Exceptions

*Get/Set/Range* requests are executed until the first error - that means that no other property dictionaries are returned after the one resulting in error (input and output arrays might not be the same size). In case of an error when executing a *get/set/range* for a property, instead of a dictionary holding property name and retrived value, an error dictionary is returned - the key is *'error'* and the value contains a descriptive message.


# Sensor

## Exposure Control Properties

| Property | G | S | R | N | Type | Description                                                                                                                                                                                                                                                                                                                        |
|----------|---|---|---|---|------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`exposurePeriod`|G|S|R|N|double| Exposure time in nanoseconds.<br/>All other exposure manipulating properties (`exposureFraction` and `shutterAngle`) are simply convenience wrappers around `exposurePeriod`. Minimum exposure period is dependent on the sensor, current resolution and current frame period. Maximum exposure period is dependent on the sensor. |
|`exposureFraction`|G|S|R|`exposurePeriod`|double| Exposure time expressed as a fraction of a second.<br/>Convenience property to set and read exposure period as a fraction of a second (1/50th, 1/200th, ...). Notify gives exposure time in nanoseconds.                                                                                                                           |
|`shutterAngle`|G|S|R|`exposurePeriod`|double| Exposure time expressed as a shutter angle (0°-360°).<br/>Convenience property to set and read exposure period as a shutter angle relative to the frame period. The angle is expressed in thousandths of degrees. In theory it would go from 0.0 to 360.0. Notify gives exposure time in nanoseconds.                              |

## ISO Control Properties

| Property      | G | S | R | N | Type | Description                          |
|---------------|---|---|---|---|-----|--------------------------------------|
| `currentIso`  |G|S|L|N|int| Current ISO value.                   |
| `currentGain` |G|S|L|`currentIso`|int| Current ISO value expressed as gain. |

## Bit Depth

| Property   | G | S | R | N | Type   | Description |
|------------|---|---|---|---|--------|-------------|
| `bitDepth` |G|S|L|N|enum|Bit depth.|

## FrameRate Control Properties

| Property | G | S | R | N | Type | Description |
|----------|---|---|---|---|------|-------------|
|`framePeriod`|G|S|R|N|double|Frame period time in nanoseconds.<br/>All other frame-rate manipulating properties (`frameRate`) are simply convenience wrappers around `framePeriod`. Minimum frame period is dependent on the sensor, current resolution and current exposure period. Maximum frame period is dependent on the sensor. |
|`frameRate`|G|S|R|`framePeriod`|double|Frame time expressed as numbers of frames per second.<br/>Convenience property to set and read frame period as numbers of frames per second. Notify gives frame period in nanoseconds.|

## Resolution Properties

| Property | G | S | R | N | Type | Description |
|----------|---|---|---|---|------|-------------|
|`resolutionW`|G|S|R|N|int|Horizontal resolution.<br/>Ranges returns bounds - not every value in that range might be valid.|
|`resolutionH`|G|S|R|N|int|Vertical resolution.<br/>Ranges returns bounds - not every value in that range might be valid.|

## Sensor Configuration

| Property | G | S | R | N | Type | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
|----------|---|---|---|---|------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`sensorConfiguration`|G|S|RL|N|dict| Configure sensor - set sensor properties.<br/><br/>Set accepts a dictionary of:<br/>- exposurePeriod<br/>- framePeriod<br/>- currentIso<br/>- bitDepth<br/>- resolutionW<br/>- resolutionH<br/><br/>Each property must appear exactly once. Only the base expression for each property can be used (for exposure that's exposurePeriod, not shutterAngle or exposureFraction). Get and range return dictionaries of values and ranges (respectively) for all the properties including all the expressions of properties (so exposurePeriod and exposureFraction and shutterAngle). Ranges depend on the sensor - they are maximum ranges supported for the sensor - not the current configuration. |

| Method | Input | Output | Description |
|--------|-------|--------|-------------|
|`trySensorConfiguration`|array of dict|dict|Validate sensor configuration.<br/><br/>Accepts an ordered list of sensor properties in the format "propertyName":\<value\>. The list doesn't have to contain all sensor properties (values of missing properties will be taken from the current sensor configuration) but it cannot contain more entries than there are sensor properties and it cannot contain duplicated entries (multiple expressions of the same property count as duplicates (so `exposurePeriod` and `shutterAngle` are duplicates)).<br/>The method examines the properties starting from the last one and tries to create a valid configuration. It returns an two-element dictionary: "get":dict, "range":dict. Both dictionaries (the one belonging to the "get" key and the one belonging to the "range" key) are of the same size and each entry represents a sensor property. Both dictionaries contain all the properties including all the expressions (so exposurePeriod and exposureFraction and shutterAngle). Each "get" dictionary entry is a pair "propertyName":\<value\> and each "range" dictionary entry is a pair "propertyName":\<range\>. If the requested property value is not valid for the current configuration "get" dictionary entry has the form "propertyName":{"error":\<Error_Description\>}. Note that if the requested configuration is valid, the returned get dictionary will be identical to a call to `sensorConfiguration` `get` but the returned range dictionary will not be identical to a call to `sensorConfiguration` `range`. This is because `range` will return valid ranges for the given configuration.<br/><br/>Note: this method is a read-only utility method, it makes no changes to the camera.|

# Record

| Property            | G | S | R | N | Type   | Description |
|---------------------|---|---|---|---|--------|-------------|
| `recording` |G|S|R|N| bool   | State of recording. |
| `recMaxFrames`      |G|S|R|N| int    |Maximum number of frames that can be stored to memory.|
| `recMaxSeconds`     |G|S|R|N| double |Maximum record time in seconds that can be stored to memory.|
| `disableRingBuffer` |G|S|R|N| bool   |Enable/Disable the ring buffer.|

| Method | Input | Output | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
|--------|-------|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`estimateSegmentSize`|dict|dict| Get an estimate for the number of seconds (and number of frames) of record time available for a given sensor and installed memory. Input is a dictionary of the following keys:<br/>- resolutionW<br/>- resolutionH<br/>- framePeriod<br/>- bitDepth<br/>- recMaxFrames (optional)<br/>- recMaxSeconds (optional)<br/><br/>Returns a dictionary of `number_of_frames`, `max_number_of_frames` and `duration` (in seconds as float). The `number_of_frames` and `max_number_of_frames` will be the same when recMaxFrames is not provided.<br/><br/>If **recMaxFrames** (or **recMaxSeconds**) is provided the total number of frames is ignored and **recMaxFrames** (or **recMaxSeconds**) is used as the number of frames in calculation of the estimate.<br/>Note, recMaxFrames must be smaller than max number of frames (recMaxSeconds must be smaller than max duration).<br/>Note, only one of **recMaxFrames** and **recMaxSeconds** can be provided, not both.<br/><br/>Note: this method is a read-only utility method, it makes no changes to the camera, it only calculates the estimates. |

# Trigger

| Property                      | G | S | R | N | Type          | Description                                                                                                                                                                                                                                             |
|-------------------------------|---|---|---|---|---------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `triggerMode`                 |G| S | L | N | array of enum | Trigger mode. Each element of the array can be one of:<br/> - Disabled<br/> - Toggle_Trigger_Mode<br/> - Record_End_Trigger_Mode<br/> - Exposure_Trigger_Mode<br/> - Shutter_Gating_Trigger_Mode<br/> - Frame_Sync_Output_Mode<br/> - IRIG_B_Input_Mode |
| `triggerDebounce`             |G| S | L | N | bool          | Toggle trigger debounce.                                                                                                                                                                                                                                |
| `triggerDebounceDuration`     |G| S | R | N | double        | Trigger debounce duration in us.                                                                                                                                                                                                                        |
| `triggerFrameSyncOutputDelay` |G| S | L | N | bool          | Toggle frame sync output delay.                                                                                                                                                                                                                         |
| `triggerInvert`               |G| S | L | N | bool          | Toggle invert.                                                                                                                                                                                                                                          |
| `triggerLogicLevel`           |G|   |   |   | bool          | Read current level of the channel - high or low.                                                                                                                                                                                                        |
| `triggerPullup`               |G| S | L | N | bool          | Toggle pull-up.                                                                                                                                                                                                                                         |
| `triggerVoltageThreshold`     |G| S | R | N | float         | Voltage threshold.                                                                                                                                                                                                                                      |
| `triggerDelayMode`            |G| S | L | N | enum          | Delay mode. Can be one of:<br/> - Time_Based<br/> - Frame_Based                                                                                                                                                                                         |
| `triggerDelayRecordEnd`       |G| S | R | N | float         | Delay between trigger event and record end.                                                                                                                                                                                                             |
| `triggerDelayRecordLength`    |G| S | R | N | float         | Length of the recording that is kept.                                                                                                                                                                                                                   |

| Method            | Input | Output | Description                                                                                                                                                                                           |
|-------------------|-------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `getTriggerFrame` |   | dict   | Returns a dictionary "frame":\<int\> with the frame index during which the trigger event happened. If trigger was not used during the last recording a dictionary "no-trigger":0 is returned instead. |

# White Balance

Only on color cameras.

## WhiteBalance Configuration

| Property | G | S   | R   | N | Type | Description |
|----------|---|-----|-----|---|------|-------------|
|`wbTemperature`|G| S   | R   |N and possibly `wbColor`|int|Color temperature in Kelvins. `wbColor` signal is emmited only if temperature is changed while `wbSource` is set to **wbTemperature**. |
|`wbSource`|G| S   | L   |N and possibly `wbColor`|enum|Selection of white balance source:<br/>- wbTemperature<br/>- wbCustomColor<br/>`wbColor` signal is emmited only when value computed from color temperature and value provided by custom source differ. |

| Method       | Input | Output | Description                                                                                                                                                                                 |
|--------------|-------|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `estimateWB` |       | string | Estimates the white balance from a patch at the center of the image. It then changes the `wbSource` to `wbCustomColor`. |
| `wbPresets`  |       | dict   | Returns a dictionary of preset_name/temperature_in_K pairs that contains common color temperatures. |


# Utils

| Property                  | G | S | R | N | Type   | Description                                                              |
|---------------------------|---|---|---|---|--------|--------------------------------------------------------------------------|
| `dateTime`                |G| S |   | N | string | ISO-8601 formatted string holding the current date and time.             |
| `autoSyncTime`            |G| S | L | N | bool   | Should internet be used to retreive the current time from an NTP server. |
| `temperature`             |G|   |   |   | double | Returns the temperature of the cpu in ℃ as a float.                      |
| `lcdBrightness`           |G| S | R |   | int    | Brightness of the LCD at the back of the camera.                         |
| `isCalibrationDataLoaded` |G|   | L | N | bool    | True if calibration data is loaded.                                      |
| `isCustomSettingsLoaded`  |G|   | L | N | bool    | True if camera settings are loaded.                                     |

| Method          | Input | Output        | Description                                                                                                                                                     |
|-----------------|-------|---------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `shutdown`      | enum  | string | Shutdown/Reboot camera. Available modes are:<br/>- `Shutdown`<br/>- `Restart`                                                                                   |
| `sensorPresets` |       | array of dict | Get sensor presets. Returns an array of dictionaries of:<br/>- resolutionW<br/>- resolutionH<br/>- bitDepth<br/>- frameRate<br/>- shutterAngle |
| `revertToDefaults` |   | string | Revert all camera settings to factory defaults. |

# Info

## Camera Info Properties
| Property                    | G | S   | R   | N      | Type   | Description                                                  |
|-----------------------------|---|-----|-----|--------|--------|--------------------------------------------------------------|
| `cameraApiVersion`          |G|     |     |        | string | API version supported by the camera.                         |
| `cameraMemoryGB`            |G|     |     |        | int    | Amount of RAM installed, in units of `GiB`.                  |
| `cameraModel`               |G|     |     |        | string | Camera model number (eg: "CN4K12-1.0-128C").                        |
| `cameraSerial`              |G|     |     |        | string | Camera unique serial number.                                 |
| `cameraHardwareRevision`    |G|    |     |    | string | Returns camera hardware revision.                            |
| `cameraSoftwareVersion`     |G|    |     |    | string | Returns camera software version.                             |
| `cameraPMICfirmwareVersion` |G|    |     |    | string | Returns camera PMIC firmware version.                        |
| `cameraNVMeSize`            |G|     |     |        | float  | Size of NVMe installed, in units of MiB.                     |
| `cameraNVMeFreeSpace`       |G|     |     |        | float  | Free space available in the NVMe installed, in units of MiB. |

## Sensor Info Properties
| Property | G | S   | N   | Type | Description |
|---|---|-----|-----|---|---|
|`sensorName`|G|     |     | string | Descriptive string of the image sensor.|
|`sensorColorPattern`|G|     |     | string | String of ‘R’ ‘G’ and ‘B’ that defines the color filter pattern in left-to-right and top-to-bottom order or ‘mono’ for monochrome sensors. |
|`sensorPixelRate`|G|     |     | double | Approximate pixel rate of the image sensor in pixels per second. |

# State

| Property        | G | S | N | Type | Description                                                                                                                             |
|-----------------|---|---|---|------|-----------------------------------------------------------------------------------------------------------------------------------------|
| `displaySource` |G|S|N| enum  | Set display state. Options are:<br/>- none<br/>- live<br/>- playback_from_DDR |

# Playback

| Property           | G | S | R | N | Type | Description                                                                                                                                                                                                                                                                            |
|--------------------|---|---|---|---|------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `playbackRate`     |G|S|R|N| int  | The playback rate in fps. It can be negative to play backward.                                                                                                                                                                                                                         |
| `playbackPosition` |G|S|R|N*| int  | The playback position in the current segment/file/sequence. Notifications are not emited while the video service is in the `playback` state. Range returns the length of the segment or file or image sequence. The playback position cannot be changed while playback is in progress. |
| `playbackStart`    |G|S|R|N| int  | The start of the playback region in the current segment/file/sequence.                                                                                                                                                                                                                 |
| `playbackEnd`      |G|S|R|N| int  | The end of the playback region in the current segment/file/sequence. The playback will loop to the **playbackStart** after reaching the **playbackEnd**.                                                                                                                               |
| `playback`         |G|S|R|N| bool | The current state of the playback service.                                                                                                                                                                                                                                             |

# Saving

| Method              | Input | Output        | Description                                                                                                                                                                                                                                                                                                                                         |
|---------------------|-------|---------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `startFileSave`     | dict  | string        | Starts the saving process. Assumes that all relevant saving properties have been set. The input is a dictionary of:<br/>- **start** \<int\><br/>- **length** \<int\> \[optional\]<br/>- **end** \<int\> \[optional\] <br/>Exactly one of **length** or **end** must be provided.<br/><br/>Returns **"ok"** on success or an error message on error. |
| `getBitratePresets` | dict  | dict        | Given the bitDepth, frameRate and format as an input dictionary, returns a dictionary with bitrates for each quality preset (except custom).                                                                                                                                                                                                        |

| Property                  | G | S   | R | N   | Type   | Description                                                                                                                                                                                                         |
|---------------------------|---|-----|---|-----|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `saveFilePath`            |G| S   |   | N   | string | Destination file or directory to be written.                                                                                                                                                                        |
| `saveFileName`            |G| S   |  | N   | string | The name the mp4 file should have when h26x format is used, and the name of the directory containing the image sequence when dng or tiff format is used. If empty, the name is generated based on the current time. |
| `saveFileFormat`          |G| S   | L | N   | enum   | The encoding to be used when saving the footage. Can be one of:<br/>- h264<br/>- h265<br/>- CinemaDNG<br/>- TIFF                                                                                                    |
| `saveFrameRate`           |G| S   | R | N   | double | The desired framerate of the encoded video file, in frames per second.                                                                                                                                              |
| `saveQuality`             |G| S   | R | N   | enum   | Quality preset. Can be one of:<br/>- Smaller_File_Size<br/>- Balanced<br/>- Maximum_Quality<br/>- Custom<br/>When custom is chosen `saveBitrate` property is used.                                                  |
| `saveBitrate`             |G| S   | R | N   | int    | The maximum encoded bitrate for compressed formats in kbs.                                                                                                                                                          |
| `saveTimestampInCSV`      |G| S   | R | N   | bool   | Toggle saving timestamps into a CSV file when saving footage.                                                                                                                                                       |
| `saveTimestampInFilename` |G| S   | R | N   | bool   | Toggle writing timestamps into frame filenames. Used only when saving image sequences (dng and tiff).                                                                                                               |
| `save`                    |G| S   | R | N   | enum   | State of saving: Any of:<br/>- **isNotSaving**<br/>- **isSaving**<br/>Can only be set to **isNotSaving** to stop the ongoing saving process. To start the saving use **saveFileStart** method.                      |
| `saveProgress`            |G|     | R |     | int    | Get returns the number of the frame currently being saved. Range returns start and end of the range.                                                                                                                |

# Text Overlays

| Property                     | G | S | R | N | Type   | Description                                                                                                           |
|------------------------------|---|---|---|---|--------|-----------------------------------------------------------------------------------------------------------------------|
| `textOverlay`                |G| S | L | N | bool   | Toggle text overlays.                                                                                                 |
| `textOverlayCustomString`    |G| S | R | N | string | Custom string to be appened to the timestamp.                                                                         |
| `textOverlayFontSize`        |G| S | L | N | int    | Font size.                                                                                                            |
| `textOverlayPosition`        |G| S | L | N | enum   | Position of overlays. Can be one of:<br/>- Top<br/>- Bottom<br/>- Underneath                                          |
| `textOverlaySecondPrecision` |G| S | R | N | int    | The number of digits used after seconds.                                                                              |
| `textOverlayString`          |G|   |   |   | string | Return the current text overlay.                                                                                      |
| `textOverlayWithData`        |G| S | L | N | bool   | Should date be included in the overlay.                                                                               |
| `isTimingSignalPresent`      |G|   | L | N | enum   | The state of the timing signal. Can be one of:<br/> - Unknown<br/> - NoSignal<br/> - HasSignal<br/> - NoSignal_NoData |

| Method                                  | Input | Output | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|-----------------------------------------|-------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `getCharactersAvailableForTextOverlays` |   | dict | Calculate the max available length for custom overlay text string based on selected Text Overlay settings. Returns a dictionary:<br/>When there is space for custom overlay string,<br/> - `custom_overlay_max_available_length`: Max number of characters available for Custom Text Overlay string<br/> - `overlay_max_line_num`: Max number of lines of the entire text overlay<br/> - `generated_longest_overlay_last_line`: The last line of generated text overlay, including absolute/related frame numbers and/or timestamps and/or IRIG-B status. It is used to wrap with input Custom Text Overlay and calculate the remaining length dynamically<br/><br/>When generated text overlay is out-of-range:<br/> - `error`:`Text overlay is out-of-range`<br/> - `overlay_max_line_num`: Same as above. |

# Assistive Overlays

| Property                  | G | S | R | N | Type | Description                                                                      |
|---------------------------|---|---|---|---|------|----------------------------------------------------------------------------------|
| `overlayZebra`            |G|S|   |   | dict | Configure zebra overlay. Options are:<br/>- state - "enabled"/"disabled"         |
| `overlayHistogram`        |G|S|   |   | dict | Configure histogram overlay. Options are:<br/>- state - "enabled"/"disabled"     |
| `overlayFocusPeaking`     |G|S|   |   | dict | Configure focus peaking overlay. Options are:<br/>- state - "enabled"/"disabled" |
| `focusPeakingSensitivity` |G|S|R|   | int  | Sensitivity of focus peaking overlay.                                            |

# Storage

| Method                        | Input | Output        | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
|-------------------------------|-------|---------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `connectToNetworkShare`       | dict  | string        | Attempts to connect to a network shared storage device such as SMB or NFS according to the string parameters within the input dictionary.<br/>`IP-Path`: IP Path to either a "SMB" or "NFS" share. SMB IP-Paths have "smb://" at the beginning of the string to delineate them from NFS share IP-Paths.<br/>`Username` [OPTIONAL]: Username to connect to "SMB" type share.<br/>`Password` [OPTIONAL]: Password to connect to "SMB" type share.<br/><br/>Returns **"ok"** on success or an error message on error. |
| `deleteEntry`                 | dict  | string        | Remove entry according to the string parameters contained within the input dictionary.<br/>`Path`: Path to entry to delete.<br/><br/>Returns **"ok"** on success or an error message on error.                                                                                                                                                                                                                                                                                                                     |
| `ejectStorageDevice`          | dict  | string        | Safely eject a given storage device according to the string parameters within the input dictionary.<br/>`storageMediaName`: Name of the storage media to eject.<br/><br/>Returns **"ok"** on success or an error message on error.                                                                                                                                                                                                                                                                                 |
| `formatStorageDevice`         | dict  | string        | Format a given storage device according to the string parameters within the input dictionary.<br/>`storageMediaName`: Name of media device to be formatted.<br/>`fileSystemType` [OPTIONAL]: target filesystem to format`storageMediaName` to can be either "exfat" or "ext4". Optional if`storageMediaName` is internal storage device such as NVME in which case the system will always format as "ext4".<br/><br/>Returns **"ok"** on success or an error message on error.                                     |
| `listConnectedStorageDevices` |       | dict          | List useful filesystem usage stats for all connected storage devices.<br/><br/>Returns a constructed dictionary on success where the storage device name is the key and the value is an array of strings containing the device info.<br/>`spaceUsed`: The amount of space used (in human-readable format).<br/>`spaceAvaiable`: The amount of space available (in human-readable format).<br/>`totalCapacity`: The total capacity of the filesystem (in human-readable format).                                    |
| `listEntries`                 | dict  | array of dict | List entries according to the string parameters within the input dictionary.<br/>`Path`: The path to the entry to list entries from, relative to`/media`.<br/><br/> Returns an array of dictionaries sorted by last modified time. Dictionaries contain the following entries.<br/>`Name`: Name of entry listed.<br/>`Type`: Type of entry, either of "dir" or "file" type.<br/>`File_Size`: Size of entry in human readable format.<br/>`Last_Modified`: Time the entry was last modified.                        |
| `transferEntry`               | dict  | string        | Transfer a filesystem entry (IE file or directory) according to the following string parameters contained within the input dictionary.<br/>`method`: The transfer method, either "copy" or "move".<br/>`source`: The path of the source entry to be transferred.<br/>`destination`: The path of the destination to where the entry will be transferred.<br/><br/>Returns **"ok"** on success or an error message on error.                                                                                         |
