import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/task_entity.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

/// Screen for creating a new task or editing an existing task.
class TaskFormScreen extends StatefulWidget {
  final TaskController controller;
  final TaskEntity? task;

  const TaskFormScreen({
    super.key,
    required this.controller,
    this.task,
  });

  bool get isEditing => task != null;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final FocusNode _titleFocusNode;
  late final FocusNode _descFocusNode;

  bool _isSubmitting = false;
  String? _titleError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController =
        TextEditingController(text: widget.task?.description ?? '');
    _titleFocusNode = FocusNode();
    _descFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _titleFocusNode.dispose();
    _descFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    // Validate title using strict core validator
    final error = Validators.validateTitle(_titleController.text);
    if (error != null) {
      setState(() {
        _titleError = error;
      });
      _titleFocusNode.requestFocus();
      return;
    }

    setState(() {
      _titleError = null;
      _isSubmitting = true;
    });

    bool success;
    if (widget.isEditing) {
      success = await widget.controller.updateTask(
        id: widget.task!.id,
        title: _titleController.text,
        description: _descController.text,
      );
    } else {
      success = await widget.controller.addTask(
        title: _titleController.text,
        description: _descController.text,
      );
    }

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? AppStrings.taskUpdatedMessage
                : AppStrings.taskCreatedMessage,
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMedium,
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final titleText =
        widget.isEditing ? AppStrings.editTaskTitle : AppStrings.addTaskTitle;
    final saveButtonLabel =
        widget.isEditing ? AppStrings.updateButton : AppStrings.saveButton;

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Close',
          onPressed: _handleCancel,
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: AppDimensions.paddingScreen,
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight -
                      (AppDimensions.spaceMD * 2),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Input Fields Group
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Task Title Field
                          CustomTextField(
                            controller: _titleController,
                            focusNode: _titleFocusNode,
                            label: AppStrings.titleLabel,
                            hint: AppStrings.titleHint,
                            errorText: _titleError,
                            autofocus: !widget.isEditing,
                            textInputAction: TextInputAction.next,
                            onChanged: (val) {
                              if (_titleError != null) {
                                setState(() {
                                  _titleError = Validators.validateTitle(val);
                                });
                              }
                            },
                            onSubmitted: (_) {
                              _descFocusNode.requestFocus();
                            },
                          ),
                          const SizedBox(height: AppDimensions.spaceLG),

                          // Description Field (Optional, multi-line)
                          CustomTextField(
                            controller: _descController,
                            focusNode: _descFocusNode,
                            label: AppStrings.descriptionLabel,
                            hint: AppStrings.descriptionHint,
                            maxLines: 5,
                            minLines: 3,
                            textInputAction: TextInputAction.newline,
                          ),
                        ],
                      ),

                      // Bottom Action Buttons (Save & Cancel)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppDimensions.spaceXL,
                          bottom: AppDimensions.spaceSM,
                        ),
                        child: Row(
                          children: [
                            // Cancel Button
                            Expanded(
                              child: CustomButton(
                                text: AppStrings.cancelButton,
                                variant: ButtonVariant.secondary,
                                onPressed: _isSubmitting ? null : _handleCancel,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spaceMD),

                            // Save Button
                            Expanded(
                              child: CustomButton(
                                text: saveButtonLabel,
                                variant: ButtonVariant.primary,
                                isLoading: _isSubmitting,
                                onPressed: _handleSave,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
