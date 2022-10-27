import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../components/color_picker_controllers.dart';
import '../models/animated_color_list_model.dart';

class EditableColorPickerField extends StatefulWidget {
  const EditableColorPickerField({
    Key? key,
    required this.style,
    required this.listKey,
    required this.focusNode,
    required this.colorList,
    required this.controller,
    required this.itemBuilder,
    this.readOnly = false,
    this.colorListReversed = false,
    this.autofocus = false,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.mouseCursor,
    this.scrollPadding = const EdgeInsets.all(0.0),
    this.scrollController,
    this.scrollPhysics,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scrollBehavior,
    this.itemCount = 0,
  }) : super(key: key);

  final ColorPickerFieldController controller;
  final FocusNode focusNode;
  final bool readOnly;
  final TextStyle style;
  final bool colorListReversed;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final MouseCursor? mouseCursor;

  final EdgeInsets scrollPadding;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final Clip clipBehavior;
  final String? restorationId;
  final ScrollBehavior? scrollBehavior;
  final int itemCount;
  final AnimatedListModel<Color> colorList;
  final AnimatedListItemBuilder itemBuilder;
  final Key listKey;

  @override
  State<EditableColorPickerField> createState() =>
      _EditableColorPickerFieldState();
}

class _EditableColorPickerFieldState extends State<EditableColorPickerField>
    with
        AutomaticKeepAliveClientMixin<EditableColorPickerField>,
        WidgetsBindingObserver {
  bool _didAutoFocus = false;
  FocusAttachment? _focusAttachment;

  bool get _hasFocus => widget.focusNode.hasFocus;

  @override
  void initState() {
    super.initState();
    _focusAttachment = widget.focusNode.attach(context);
    widget.focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didAutoFocus && widget.autofocus) {
      _didAutoFocus = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          FocusScope.of(context).autofocus(widget.focusNode);
        }
      });
    }
  }

  void _didChangeColorEditingValue() {
    setState(() {/* We use widget.controller.value in build(). */});
  }

  @override
  void didUpdateWidget(EditableColorPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_didChangeColorEditingValue);
      widget.controller.addListener(_didChangeColorEditingValue);
    }

    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocusChanged);
      _focusAttachment?.detach();
      _focusAttachment = widget.focusNode.attach(context);
      widget.focusNode.addListener(_handleFocusChanged);
      updateKeepAlive();
    }
  }

  void _handleFocusChanged() {
    if (_hasFocus) {
      WidgetsBinding.instance.addObserver(this);
    } else {
      WidgetsBinding.instance.removeObserver(this);
    }
    updateKeepAlive();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeColorEditingValue);
    _focusAttachment!.detach();
    widget.focusNode.removeListener(_handleFocusChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => widget.focusNode.hasFocus;

  @override
  Widget build(BuildContext context) {
    _focusAttachment!.reparent();
    super.build(context);
    return MouseRegion(
      cursor: widget.mouseCursor ?? SystemMouseCursors.grab,
      child: SizedBox(
        height: widget.style.fontSize,
        child: AnimatedList(
          key: widget.listKey,
          physics: widget.scrollPhysics,
          controller: widget.scrollController,
          reverse: widget.colorListReversed,
          padding: const EdgeInsets.all(1.0),
          scrollDirection: Axis.horizontal,
          initialItemCount: widget.itemCount,
          itemBuilder: widget.itemBuilder,
        ),
      ),
    );
  }
}
