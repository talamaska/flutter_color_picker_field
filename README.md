# color_picker_field

Color Picker Field

Color Picker field for Material and Cupertino, including a Radial Color picker(Hue based)
## Getting Started

* Install from pub.dev
```
flutter pub color_picker_field
```

* Include in code
```
import 'color_picker_field/color_picker_field.dart';
```

* Usage

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

```dart
CupertinoColorPickerField(
  placeholder: 'CupertinoColorPickerField',
  colors: [],
  defaultColor: Colors.blue,
  onChanged: (Color value) {},
  clearButtonMode: ClearButtonVisibilityMode.always,
),
```

```dart
CupertinoFormSection.insetGrouped(
  header: const Text('Section 1'),
  children: [
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

## Screenshots

### Material
| Material Color Picker fields | Material Color Picker screen 1 | Material Color Picker screen 2 | Material Color Picker screen 3 |
|------------------------------|--------------------------------|--------------------------------|--------------------------------|
|<img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/material_fields.png?raw=true" width="200" /> | <img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/material_color_picker1.png?raw=true" width="200" /> | <img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/material_color_picker2.png?raw=true" width="200" /> | <img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/material_color_picker3.png?raw=true" width="200" /> |

### Cupertino
| Cupertino Color Picker fields | Cupertino Color Picker screen 1 | Cupertino Color Picker screen 2 | Cupertino Color Picker screen 3 |
|-------------------------------|---------------------------------|---------------------------------|---------------------------------|
|<img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/cupertino_fields.png?raw=true" width="200" /> | <img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/cupertino_color_picker1.png?raw=true" width="200" /> | <img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/cupertino_color_picker2.png?raw=true" width="200" /> | <img src="https://github.com/talamaska/flutter_color_picker_field/blob/master/screenshots/cupertino_color_picker3.png?raw=true" width="200" /> |
