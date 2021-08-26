# Color Picker Field

[![Pub](https://img.shields.io/pub/v/color_picker_field)](https://pub.dev/packages/color_picker_field)

Color Picker field for Material and Cupertino, including a Radial Color picker(Hue based)

## Material
| Material Fields | Color wheel | Remove colors | Saturation and Lightness |
|------------------------------|--------------------------------|--------------------------------|--------------------------------|
|<img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/material_fields.png?raw=true" width="200" /> | <img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/material_color_picker1.png?raw=true" width="200" /> | <img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/material_color_picker2.png?raw=true" width="200" /> | <img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/material_color_picker3.png?raw=true" width="200" /> |

## Cupertino
| Cupertino Fields | Color wheel | Remove colors | Saturation and Lightness |
|-------------------------------|---------------------------------|---------------------------------|---------------------------------|
|<img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/cupertino_fields.png?raw=true" width="200" /> | <img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/cupertino_color_picker1.png?raw=true" width="200" /> | <img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/cupertino_color_picker2.png?raw=true" width="200" /> | <img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/cupertino_color_picker3.png?raw=true" width="200" /> |


## Usage

### Just the ColorPickerField without a Form with a controller set
```dart
final ColorPickerFieldController controller = ColorPickerFieldController();
ColorPickerField(
  colors: [],
  defaultColor: Colors.blue,
  onChanged: (Color value) {},
  controller: controller,
  decoration: InputDecoration(
    labelText: 'Colors',
  ),
),
```

### ColorPickerFieldFor with a validator, decoration and an onChange callback
```dart
ColorPickerFormField(
  initialValue: [],
  defaultColor: Colors.blue,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  maxColors: 3,
  decoration: InputDecoration(
    labelText: 'Colors',
    helperText: 'test',
  ),
  validator: (List<Color>? value) {
    if (value!.isEmpty) {
      return 'a minimum of 1 color is required';
    }
    return null;
  },
  onChanged: (Color value) {},
),
```

### Just a CupertinoColorPickerField without a Form
```dart
CupertinoColorPickerField(
  placeholder: 'CupertinoColorPickerField',
  colors: [],
  defaultColor: Colors.blue,
  onChanged: (Color value) {},
  clearButtonMode: ClearButtonVisibilityMode.always,
),
```

### A CupertinoColorPickerField inside a CupertinoFormSection using CupertinoColorPickerFormFieldRow
```dart
CupertinoFormSection.insetGrouped(
  header: const Text('Section 1'),
  children: [
    // A field with an always showing clear button
    CupertinoColorPickerFormFieldRow(
      prefix: const Text('Enter Color'),
      defaultColor: defaultColor,
      clearButtonMode: ClearButtonVisibilityMode.always,
      placeholder: 'Enter Color',
      onChanged: _onChanged,
      validator: (List<Color>? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter at least one color';
        }
        return null;
      },
    ),
    
    // A field with a reversed position and order of the chosen colors list
    CupertinoColorPickerFormFieldRow(
      prefix: const Text('Enter Color'),
      defaultColor: defaultColor,
      placeholder: 'Enter Color',
      onChanged: (Color value) {},
      colorListReversed: true,
      validator: (List<Color>? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter at least one color';
        }
        return null;
      },
    ),

    // Forcing Text Direction using Directionality widget, 
    // by default the TextDirection will be read from the Localization
    Directionality(
      textDirection: TextDirection.rtl,
      child: CupertinoColorPickerFormFieldRow(
        prefix: const Text('Enter Color rtl'),
        defaultColor: defaultColor,
        placeholder: 'Enter Color rtl',
        onChanged: (Color value) {},
        validator: (List<Color>? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter at least one color';
          }
          return null;
        },
      ),
    ),
  ],
),
```

## [API reference](https://pub.dev/documentation/color_picker_field/latest/color_picker_field/color_picker_field-library.html)

